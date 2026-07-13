#!/usr/bin/env python3
"""
مولّد صور مكتبة المحتوى لتطبيق "براعم" — نسخة Hugging Face Inference API
(موديل FLUX.1-schnell من black-forest-labs)، سكربت مستقل تمامًا عن
tools/generate_content_images.py (Pollinations) و tools/generate_content_images_gemini.py
(Gemini — متوقف حاليًا لأن موديل الصور يحتاج تفعيل فوترة على المشروع).

يقرأ assets/content/content.json ويولّد لكل (مجموعة/عنصر/مثال) صورة عبر
Hugging Face Inference API ويحفظها في:
    assets/content/<category_id>/<item_id>/<n>.jpg

يستخدم مفتاح "stylesGemini" بالـ JSON (نفس الستايلات المتنوّعة بالإضاءة
والتصوير يلي عملناها لـ Gemini) — مش "styles" الأصلي.

خصائص:
- Idempotent: بيتخطّى الصور الموجودة (إلا مع --force).
- بذور ثابتة (seed): FLUX.1-schnell بيدعم seed حقيقي بالـ API، فنفس التعريف
  = نفس الصورة عند إعادة التشغيل (--salt بيغيّر الـ seed لإعادة توليد صورة
  معيبة بشكل مختلف).
- متوازي: عدة طلبات بنفس الوقت (بحد أدنى افتراضيًا لأن الطبقة المجانية من
  HF محدودة الطلبات).

الإعداد:
    1. حساب مجاني على https://huggingface.co ثم Access Token من
       https://huggingface.co/settings/tokens (يكفي صلاحية القراءة
       "Inference Providers").
    2. ثبّتي Pillow (لتحويل الصورة المُرجَعة PNG إلى JPEG حقيقي يطابق باقي
       الملفات): pip install pillow
    3. ضعي التوكن بمتغيّر بيئة HF_TOKEN، أو بملف .env بالجذر بالشكل:
           HF_TOKEN = your-token-here

الاستخدام:
    python3 tools/generate_content_images_hf.py            # ولّد الناقص
    python3 tools/generate_content_images_hf.py --force     # أعد توليد الكل
    python3 tools/generate_content_images_hf.py --workers 2 # تحكّم بالتوازي
"""

import argparse
import io
import json
import os
import sys
import threading
import time
import urllib.error
import urllib.request
import zlib
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
MODEL = "black-forest-labs/FLUX.1-schnell"
API_URL = f"https://router.huggingface.co/hf-inference/models/{MODEL}"
NUM_INFERENCE_STEPS = 4  # الموديل "schnell" مقطّر لعدد خطوات قليل جداً
MIN_VALID_BYTES = 2000
MAX_RETRIES = 6

# بوابة مباعدة: الطبقة المجانية من HF محدودة الطلبات بشكل صارم،
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


def load_api_token():
    token = os.environ.get("HF_TOKEN")
    if token:
        return token.strip()
    if ENV_FILE.exists():
        for line in ENV_FILE.read_text(encoding="utf-8").splitlines():
            if "=" not in line:
                continue
            name, _, value = line.partition("=")
            if name.strip().upper() in ("HF_TOKEN", "HUGGINGFACE_TOKEN", "HF_API_KEY"):
                return value.strip()
    sys.exit(
        "لم يُعثر على توكن Hugging Face. عرّفي HF_TOKEN كمتغيّر بيئة، "
        "أو ضعيه بملف .env بالجذر بالشكل: HF_TOKEN = your-token-here\n"
        "(توكن مجاني من https://huggingface.co/settings/tokens)"
    )


def build_jobs(spec, salt=0):
    """يحوّل التعريف إلى قائمة مهام توليد مفردة (يقرأ stylesGemini)."""
    styles = spec["stylesGemini"]
    common = spec.get("common", "")
    section_common = spec.get("sectionCommon", common)
    size = spec.get("imageSize", 768)
    jobs = []

    def add_job(category, item, index, subject, style, constraint):
        parts = [subject, style["prompt"]]
        if constraint:
            parts.append(constraint)
        prompt = ", ".join(parts)
        out_path = CONTENT_DIR / category["id"] / item["id"] / f'{index}.jpg'
        jobs.append({
            "label": f'{category["id"]}/{item["id"]}/{index} ({style["id"]}, {item["label"]}: {subject})',
            "prompt": prompt,
            "seed": (zlib.crc32(prompt.encode("utf-8")) + salt) % 100000,
            "size": size,
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


def fetch_image(prompt, seed, size, token, delay):
    """يطلب صورة من Hugging Face ويرجع بايتات JPEG (يرمي استثناء عند الفشل)."""
    from PIL import Image  # استيراد مؤجَّل: يعطي رسالة واضحة لو Pillow غير مثبّتة

    payload = {
        "inputs": prompt,
        "parameters": {
            "width": size,
            "height": size,
            "seed": seed,
            "num_inference_steps": NUM_INFERENCE_STEPS,
        },
    }
    request = urllib.request.Request(
        API_URL,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {token}",
        },
        method="POST",
    )
    pace(delay)
    with urllib.request.urlopen(request, timeout=180) as response:
        content_type = response.headers.get("Content-Type", "")
        body = response.read()

    if content_type.startswith("application/json"):
        info = json.loads(body)
        raise ValueError(info.get("error", f"استجابة غير متوقعة: {info}"))

    if len(body) < MIN_VALID_BYTES:
        raise ValueError(f"استجابة صغيرة جداً ({len(body)} بايت)")

    image = Image.open(io.BytesIO(body)).convert("RGB")
    buffer = io.BytesIO()
    image.save(buffer, format="JPEG", quality=92)
    return buffer.getvalue()


def run_job(job, force, token, delay):
    out_path = job["out_path"]
    if out_path.exists() and not force:
        return ("skip", job["label"])
    out_path.parent.mkdir(parents=True, exist_ok=True)
    last_error = None
    for attempt in range(1, MAX_RETRIES + 1):
        try:
            data = fetch_image(job["prompt"], job["seed"], job["size"], token, delay)
            out_path.write_bytes(data)
            return ("ok", job["label"])
        except urllib.error.HTTPError as error:
            last_error = error
            # 429 = تجاوز الحد، 503 = الموديل قيد التحميل؛ تراجع أطول تدريجياً.
            backoff = (delay * 2 * attempt) if error.code in (429, 503) else (2 * attempt)
            time.sleep(backoff)
        except Exception as error:  # noqa: BLE001 - نريد المتابعة على أي فشل شبكي
            last_error = error
            time.sleep(2 * attempt)
    return ("fail", f'{job["label"]} :: {last_error}')


def main():
    parser = argparse.ArgumentParser(description="توليد صور مكتبة محتوى براعم عبر Hugging Face")
    parser.add_argument("--force", action="store_true", help="أعد توليد الصور الموجودة")
    parser.add_argument("--workers", type=int, default=1, help="عدد الطلبات المتوازية")
    parser.add_argument("--delay", type=float, default=5.0, help="أدنى فاصل زمني (ثوانٍ) بين الطلبات")
    parser.add_argument("--only", default=None, help="فلترة حسب معرّف المجموعة (مثل clothes)")
    parser.add_argument("--item", default=None, help="فلترة حسب معرّفات عناصر مفصولة بفواصل (مثل shirt,pants)")
    parser.add_argument("--salt", type=int, default=0, help="إزاحة الـseed لإعادة توليد صورة معيبة بشكل مختلف")
    args = parser.parse_args()

    if not CONTENT_JSON.exists():
        sys.exit(f"لم يُعثر على {CONTENT_JSON}")

    token = load_api_token()

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
        futures = {pool.submit(run_job, job, args.force, token, args.delay): job for job in jobs}
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
