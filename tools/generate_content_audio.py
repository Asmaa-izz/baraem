#!/usr/bin/env python3
"""
مولّد الصوت العربي لمكتبة محتوى "براعم".

يقرأ assets/content/content.json ويولّد لكل (عنصر × صوت) مقطعاً صوتياً لاسم
العنصر عبر edge-tts (مايكروسوفت، مجاني، بدون مفتاح API)، ويحفظه في:
    assets/content/<category_id>/<item_id>/audio/<voice_id>.mp3

النص المنطوق = item["speech"] إن وُجد، وإلا item["label"]. أضف حقل "speech"
لأي عنصر تريد ضبط نطقه (تشكيل/صياغة). الأصوات معرّفة في spec["voices"].

Idempotent: يتخطّى الموجود (إلا مع --force). يستخدم بايثون البيئة الافتراضية
.venv الذي ثُبّت فيه edge-tts.

الاستخدام:
    python3 tools/generate_content_audio.py
    python3 tools/generate_content_audio.py --item cat,dog --force
"""

import argparse
import json
import subprocess
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CONTENT_DIR = ROOT / "assets" / "content"
CONTENT_JSON = CONTENT_DIR / "content.json"
VENV_PYTHON = ROOT / ".venv" / "bin" / "python"
MAX_RETRIES = 3
MIN_VALID_BYTES = 500


def build_jobs(spec):
    voices = spec["voices"]
    jobs = []
    for category in spec["categories"]:
        for item in category["items"]:
            speech = item.get("speech", item["label"])
            for voice in voices:
                out_path = CONTENT_DIR / category["id"] / item["id"] / "audio" / f'{voice["id"]}.mp3'
                jobs.append({
                    "label": f'{category["id"]}/{item["id"]}/{voice["id"]} ("{speech}")',
                    "text": speech,
                    "voice": voice["voice"],
                    "out_path": out_path,
                })
    return jobs


def build_praise_jobs(spec):
    """كلمات تشجيع تُنطق عند الإجابة الصحيحة، بالصوت الافتراضي (أول صوت)."""
    praises = spec.get("praises", [])
    if not praises:
        return []
    default_voice = spec["voices"][0]["voice"]
    jobs = []
    for praise in praises:
        speech = praise.get("speech", praise["label"])
        out_path = CONTENT_DIR / "praise" / f'{praise["id"]}.mp3'
        jobs.append({
            "label": f'praise/{praise["id"]} ("{speech}")',
            "text": speech,
            "voice": default_voice,
            "out_path": out_path,
        })
    return jobs


def run_job(job, force):
    out_path = job["out_path"]
    if out_path.exists() and not force:
        return ("skip", job["label"])
    out_path.parent.mkdir(parents=True, exist_ok=True)
    last_error = None
    for attempt in range(1, MAX_RETRIES + 1):
        try:
            subprocess.run(
                [str(VENV_PYTHON), "-m", "edge_tts",
                 "--voice", job["voice"], "--text", job["text"],
                 "--write-media", str(out_path)],
                check=True, capture_output=True, timeout=90,
            )
            if out_path.exists() and out_path.stat().st_size > MIN_VALID_BYTES:
                return ("ok", job["label"])
            raise RuntimeError("ملف صوتي صغير/فارغ")
        except Exception as error:  # noqa: BLE001 - نتابع على أي فشل
            last_error = error
            time.sleep(2 * attempt)
    return ("fail", f'{job["label"]} :: {last_error}')


def main():
    parser = argparse.ArgumentParser(description="توليد صوت مكتبة محتوى براعم")
    parser.add_argument("--force", action="store_true", help="أعد توليد المقاطع الموجودة")
    parser.add_argument("--workers", type=int, default=3, help="عدد المهام المتوازية")
    parser.add_argument("--only", default=None, help="فلترة حسب معرّف المجموعة")
    parser.add_argument("--item", default=None, help="فلترة حسب معرّفات عناصر مفصولة بفواصل")
    args = parser.parse_args()

    if not VENV_PYTHON.exists():
        sys.exit(f"لم يُعثر على بايثون البيئة الافتراضية: {VENV_PYTHON}\n"
                 "أنشئها ثم ثبّت edge-tts: python3 -m venv .venv && .venv/bin/pip install edge-tts")

    spec = json.loads(CONTENT_JSON.read_text(encoding="utf-8"))
    if not spec.get("voices"):
        sys.exit('لا توجد أصوات معرّفة في content.json ضمن المفتاح "voices".')
    if args.only:
        spec["categories"] = [c for c in spec["categories"] if c["id"] == args.only]
    if args.item:
        wanted = {name.strip() for name in args.item.split(",")}
        for category in spec["categories"]:
            category["items"] = [it for it in category["items"] if it["id"] in wanted]
        spec["categories"] = [c for c in spec["categories"] if c["items"]]

    jobs = build_jobs(spec)
    # كلمات التشجيع تُولَّد فقط عند غياب فلاتر العناصر/المجموعات.
    if not args.only and not args.item:
        jobs += build_praise_jobs(spec)
    print(f"مهام صوتية: {len(jobs)}  |  الأصوات: {', '.join(v['id'] for v in spec['voices'])}")

    results = {"ok": 0, "skip": 0, "fail": 0}
    failures = []
    with ThreadPoolExecutor(max_workers=args.workers) as pool:
        futures = {pool.submit(run_job, job, args.force): job for job in jobs}
        for future in as_completed(futures):
            status, message = future.result()
            results[status] += 1
            icon = {"ok": "✓", "skip": "○", "fail": "✗"}[status]
            print(f"  {icon} {message}")
            if status == "fail":
                failures.append(message)

    print(f"\n— الملخّص —  مولّدة: {results['ok']}   متخطّاة: {results['skip']}   فاشلة: {results['fail']}")
    if failures:
        for message in failures:
            print(f"   - {message}")
        sys.exit(1)


if __name__ == "__main__":
    main()
