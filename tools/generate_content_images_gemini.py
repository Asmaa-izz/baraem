#!/usr/bin/env python3
"""
مولّد صور مكتبة المحتوى لتطبيق "براعم" — نسخة Google Gemini (nano-banana /
gemini-2.5-flash-image)، بديل مجاني لـ tools/generate_content_images.py
(Pollinations). يقرأ assets/content/content.json ويولّد لكل (مجموعة/عنصر/
مثال) صورة عبر Gemini API ويحفظها في:
    assets/content/<category_id>/<item_id>/<n>.jpg

يستخدم مفتاح "stylesGemini" في content.json (وليس "styles") — نفس الـ ids
والترتيب المستخدم مع Pollinations، لكن بأوصاف إضاءة/تصوير/خلفية مختلفة تمامًا
لكل ستايل حتى تتنوّع أجواء الصور بدل ما تحس متشابهة.

خصائص:
- Idempotent: بيتخطّى الصور الموجودة (إلا مع --force).
- متوازي: عدة طلبات بنفس الوقت (بحد أدنى، لأن الطبقة المجانية من Gemini
  محدودة الطلبات بالدقيقة/باليوم).
- لا يوجد seed ثابت بواجهة Gemini (بعكس Pollinations)، فـ --salt هون بيضيف
  وصف تنويع إضافي للبرومبت بدل seed رقمي، لتوليد نتيجة مختلفة عمدًا.

الإعداد:
    1. مفتاح API مجاني من https://aistudio.google.com/apikey
    2. ضعيه بمتغيّر بيئة GEMINI_API_KEY، أو بملف .env بالجذر بالشكل:
           GEMINI_API_KEY = your-key-here
       (يقبل أيضًا اسم API_KEY لو موجود بهذا الشكل بالملف)

الاستخدام:
    python3 tools/generate_content_images_gemini.py            # ولّد الناقص
    python3 tools/generate_content_images_gemini.py --force     # أعد توليد الكل
    python3 tools/generate_content_images_gemini.py --workers 2 # تحكّم بالتوازي
"""

import argparse
import base64
import json
import os
import sys
import threading
import time
import urllib.error
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

# على ويندوز الطرفية الافتراضية cp1252 فتفشل طباعة العربية؛ نفرض UTF-8.
for _stream in (sys.stdout, sys.stderr):
    try:
        _stream.reconfigure(encoding="utf-8")
    except (AttributeError, ValueError):
        pass

REPO_ROOT = Path(__file__).resolve().parent.parent
CONTENT_DIR = REPO_ROOT / "assets" / "content"
CONTENT_JSON = CONTENT_DIR / "content.json"
ENV_FILE = REPO_ROOT / ".env"
API_URL = "https://generativelanguage.googleapis.com/v1beta/interactions"
MODEL = "gemini-2.5-flash-image"
MIN_VALID_BYTES = 2000
MAX_RETRIES = 6

VARIATION_HINTS = [
    "a slightly different angle",
    "a fresh new composition",
    "different framing",
    "an alternate unique take",
]

# بوابة مباعدة: الطبقة المجانية من Gemini محدودة الطلبات بالدقيقة بشكل صارم،
# فنفرض حداً أدنى من الفاصل الزمني بين بدايات الطلبات عبر كل العمّال.
_pace_lock = threading.Lock()
_next_allowed = [0.0]


def pace(min_interval):
    with _pace_lock:
        now = time.monotonic()
        wait = _next_allowed[0] - now
        if wait > 0:
            time.sleep(wait)
        _next_allowed[0] = time.monotonic() + min_interval


def load_api_key():
    key = os.environ.get("GEMINI_API_KEY")
    if key:
        return key.strip()
    if ENV_FILE.exists():
        for line in ENV_FILE.read_text(encoding="utf-8").splitlines():
            if "=" not in line:
                continue
            name, _, value = line.partition("=")
            if name.strip().upper() in ("GEMINI_API_KEY", "API_KEY"):
                return value.strip()
    sys.exit(
        "لم يُعثر على مفتاح Gemini API. عرّفي GEMINI_API_KEY كمتغيّر بيئة، "
        "أو ضعيه بملف .env بالجذر بالشكل: GEMINI_API_KEY = your-key-here\n"
        "(المفتاح المجاني من https://aistudio.google.com/apikey)"
    )


def build_jobs(spec, salt=0):
    """يحوّل التعريف إلى قائمة مهام توليد مفردة (يقرأ stylesGemini)."""
    styles = spec["stylesGemini"]
    common = spec.get("common", "")
    section_common = spec.get("sectionCommon", common)
    jobs = []

    variation = ""
    if salt:
        variation = f", {VARIATION_HINTS[salt % len(VARIATION_HINTS)]} than a typical attempt"

    def add_job(category, item, index, subject, style, constraint):
        parts = [subject, style["prompt"]]
        if constraint:
            parts.append(constraint)
        prompt = ", ".join(parts) + variation
        out_path = CONTENT_DIR / category["id"] / item["id"] / f'{index}.jpg'
        jobs.append({
            "label": f'{category["id"]}/{item["id"]}/{index} ({style["id"]}, {item["label"]}: {subject})',
            "prompt": prompt,
            "out_path": out_path,
        })

    for category in spec["categories"]:
        for item in category["items"]:
            subjects = item["subjects"]
            for index, style in enumerate(styles, start=1):
                subject = subjects[(index - 1) % len(subjects)]
                add_job(category, item, index, subject, style, common)

            for offset, section in enumerate(item.get("sections", [])):
                index = len(styles) + offset + 1
                style = styles[offset % len(styles)]
                add_job(category, item, index, section, style, section_common)
    return jobs


def fetch_image(prompt, api_key, delay):
    """يطلب صورة من Gemini ويرجع البايتات (يرمي استثناء عند الفشل)."""
    payload = {
        "model": MODEL,
        "input": prompt,
        "response_format": {
            "type": "image",
            "mime_type": "image/jpeg",
            "aspect_ratio": "1:1",
        },
    }
    request = urllib.request.Request(
        API_URL,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Content-Type": "application/json",
            "x-goog-api-key": api_key,
        },
        method="POST",
    )
    pace(delay)
    with urllib.request.urlopen(request, timeout=180) as response:
        body = json.loads(response.read().decode("utf-8"))

    for step in body.get("steps", []):
        if step.get("type") != "model_output":
            continue
        for block in step.get("content", []):
            if block.get("type") == "image" and block.get("data"):
                data = base64.b64decode(block["data"])
                if len(data) < MIN_VALID_BYTES:
                    raise ValueError(f"استجابة صغيرة جداً ({len(data)} بايت)")
                return data

    raise ValueError("لا توجد صورة بالرد (يُحتمل رفض الطلب لأسباب سلامة المحتوى)")


def run_job(job, force, api_key, delay):
    out_path = job["out_path"]
    if out_path.exists() and not force:
        return ("skip", job["label"])
    out_path.parent.mkdir(parents=True, exist_ok=True)
    last_error = None
    for attempt in range(1, MAX_RETRIES + 1):
        try:
            data = fetch_image(job["prompt"], api_key, delay)
            out_path.write_bytes(data)
            return ("ok", job["label"])
        except urllib.error.HTTPError as error:
            last_error = error
            # 429 = تجاوز الحد؛ تراجع أطول تدريجياً قبل إعادة المحاولة.
            backoff = (delay * 2 * attempt) if error.code == 429 else (2 * attempt)
            time.sleep(backoff)
        except Exception as error:  # noqa: BLE001 - نريد المتابعة على أي فشل شبكي
            last_error = error
            time.sleep(2 * attempt)
    return ("fail", f'{job["label"]} :: {last_error}')


def main():
    parser = argparse.ArgumentParser(description="توليد صور مكتبة محتوى براعم عبر Gemini")
    parser.add_argument("--force", action="store_true", help="أعد توليد الصور الموجودة")
    parser.add_argument("--workers", type=int, default=1, help="عدد الطلبات المتوازية")
    parser.add_argument("--delay", type=float, default=8.0, help="أدنى فاصل زمني (ثوانٍ) بين الطلبات")
    parser.add_argument("--only", default=None, help="فلترة حسب معرّف المجموعة (مثل animals)")
    parser.add_argument("--item", default=None, help="فلترة حسب معرّفات عناصر مفصولة بفواصل (مثل spoon,fork)")
    parser.add_argument("--salt", type=int, default=0, help="نوّع البرومبت لإعادة توليد صورة معيبة بشكل مختلف")
    args = parser.parse_args()

    if not CONTENT_JSON.exists():
        sys.exit(f"لم يُعثر على {CONTENT_JSON}")

    api_key = load_api_key()

    spec = json.loads(CONTENT_JSON.read_text(encoding="utf-8"))
    if args.only:
        spec["categories"] = [c for c in spec["categories"] if c["id"] == args.only]
    if args.item:
        wanted = {name.strip() for name in args.item.split(",")}
        for category in spec["categories"]:
            category["items"] = [it for it in category["items"] if it["id"] in wanted]
        spec["categories"] = [c for c in spec["categories"] if c["items"]]

    jobs = build_jobs(spec, salt=args.salt)
    print(f"إجمالي المهام: {len(jobs)}  |  التوازي: {args.workers}  |  فاصل: {args.delay}ث  |  force={args.force}")

    results = {"ok": 0, "skip": 0, "fail": 0}
    failures = []
    with ThreadPoolExecutor(max_workers=args.workers) as pool:
        futures = {pool.submit(run_job, job, args.force, api_key, args.delay): job for job in jobs}
        for future in as_completed(futures):
            status, message = future.result()
            results[status] += 1
            icon = {"ok": "✓", "skip": "○", "fail": "✗"}[status]
            print(f"  {icon} {message}")
            if status == "fail":
                failures.append(message)

    print("\n— الملخّص —")
    print(f"  مولّدة: {results['ok']}   متخطّاة: {results['skip']}   فاشلة: {results['fail']}")
    if failures:
        print("  فشلت:")
        for message in failures:
            print(f"    - {message}")
        sys.exit(1)


if __name__ == "__main__":
    main()
