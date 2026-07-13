#!/usr/bin/env python3
"""
مولّد صور مكتبة المحتوى لتطبيق "براعم".

يقرأ assets/content/content.json ويولّد لكل (مجموعة/عنصر/مثال) صورة عبر
Pollinations.ai (مجاني، بدون مفتاح API) ويحفظها في:
    assets/content/<category_id>/<item_id>/<n>.jpg

خصائص:
- Idempotent: بيتخطّى الصور الموجودة (إلا مع --force) — فبتضيف عناصر جديدة
  للـ JSON وتشغّله فيولّد الناقص فقط.
- متوازي: عدة تنزيلات بنفس الوقت لتسريع التوليد.
- بذور ثابتة (seed): نفس التعريف = نفس الصور عند إعادة التشغيل.

الاستخدام:
    python3 tools/generate_content_images.py            # ولّد الناقص
    python3 tools/generate_content_images.py --force     # أعد توليد الكل
    python3 tools/generate_content_images.py --workers 5 # تحكّم بالتوازي
"""

import argparse
import json
import sys
import threading
import time
import urllib.error
import urllib.parse
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

CONTENT_DIR = Path(__file__).resolve().parent.parent / "assets" / "content"
CONTENT_JSON = CONTENT_DIR / "content.json"
BASE_URL = "https://image.pollinations.ai/prompt/"
MIN_VALID_BYTES = 2000
MAX_RETRIES = 6

# بوابة مباعدة: الطبقة المجانية من Pollinations ترفض الطلبات السريعة/المتوازية (429)،
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


def build_jobs(spec, salt=0):
    """يحوّل التعريف إلى قائمة مهام توليد مفردة.

    كل عنصر يُولَّد بكل ستايل من spec["styles"]؛ الستايل رقم i يُقرَن بالجسم
    subjects[i] (بتدوير إن كانت القائمة أقصر) فيتنوّع الجسم والخلفية واللون
    والزاوية والإضاءة معاً. الملف يُسمّى {i}.jpg.

    إضافةً لذلك، إن كان للعنصر قائمة "sections" (صور «الجزء»: الفاكهة/الخضار
    مقطوعة تُظهر الداخل مع بقاء الملامح واضحة) تُولَّد صورة لكل عنصر منها بعد
    الصور العادية، مرقّمة {len(styles)+j}.jpg، مقرونةً بالستايلات بالتناوب
    ومستخدمةً قيد spec["sectionCommon"] بدل "common". يجب أن يطابق هذا الترقيم
    مضاهيه في content_seeder.dart (الأجزاء تبدأ بعد عدد الستايلات).

    الـseed مشتق من البرومبت (فالنتيجة ثابتة)؛ يضيف salt لتغيير النتيجة عند
    إعادة توليد صورة معيبة (نفس البرومبت + salt مختلف = صورة مختلفة).
    """
    styles = spec["styles"]
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

            # صور «الجزء» (اختيارية): تبدأ أرقامها بعد الصور العادية مباشرةً.
            for offset, section in enumerate(item.get("sections", [])):
                index = len(styles) + offset + 1
                style = styles[offset % len(styles)]
                add_job(category, item, index, section, style, section_common)
    return jobs


def fetch_image(prompt, seed, size, delay):
    """يطلب صورة من Pollinations ويرجع البايتات (يرمي استثناء عند الفشل)."""
    query = urllib.parse.urlencode({
        "width": size,
        "height": size,
        "nologo": "true",
        "model": "flux",
        "seed": seed,
    })
    url = BASE_URL + urllib.parse.quote(prompt) + "?" + query
    request = urllib.request.Request(url, headers={"User-Agent": "baraem-content-gen"})
    pace(delay)
    with urllib.request.urlopen(request, timeout=180) as response:
        data = response.read()
    if len(data) < MIN_VALID_BYTES:
        raise ValueError(f"استجابة صغيرة جداً ({len(data)} بايت)")
    return data


def run_job(job, force, delay):
    out_path = job["out_path"]
    if out_path.exists() and not force:
        return ("skip", job["label"])
    out_path.parent.mkdir(parents=True, exist_ok=True)
    last_error = None
    for attempt in range(1, MAX_RETRIES + 1):
        try:
            data = fetch_image(job["prompt"], job["seed"], job["size"], delay)
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
    parser = argparse.ArgumentParser(description="توليد صور مكتبة محتوى براعم")
    parser.add_argument("--force", action="store_true", help="أعد توليد الصور الموجودة")
    parser.add_argument("--workers", type=int, default=2, help="عدد التنزيلات المتوازية")
    parser.add_argument("--delay", type=float, default=6.0, help="أدنى فاصل زمني (ثوانٍ) بين الطلبات")
    parser.add_argument("--only", default=None, help="فلترة حسب معرّف المجموعة (مثل animals)")
    parser.add_argument("--item", default=None, help="فلترة حسب معرّفات عناصر مفصولة بفواصل (مثل spoon,fork)")
    parser.add_argument("--salt", type=int, default=0, help="إزاحة الـseed لإعادة توليد صورة معيبة بشكل مختلف")
    args = parser.parse_args()

    if not CONTENT_JSON.exists():
        sys.exit(f"لم يُعثر على {CONTENT_JSON}")

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
        futures = {pool.submit(run_job, job, args.force, args.delay): job for job in jobs}
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
