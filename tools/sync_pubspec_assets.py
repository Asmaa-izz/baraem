#!/usr/bin/env python3
"""
مزامنة قائمة الأصول في pubspec.yaml مع محتوى content.json.

Flutter لا يضمّ المجلدات الفرعية تلقائياً، فكل مجموعة/عنصر (ومجلد صوته) يجب أن
يُذكر صراحةً. هذا السكربت يعيد توليد كتلة `assets:` من content.json، فتُقرأ أي
مجموعة/عنصر جديد تضيفه — بعد توليد الصور/الصوت — دون تحرير pubspec يدوياً.

سير العمل عند إضافة محتوى جديد:
    1) عدّل assets/content/content.json (أضف مجموعة/عناصر).
    2) python3 tools/generate_content_images.py   # الصور
    3) python3 tools/generate_content_audio.py    # الصوت + التشجيع
    4) python3 tools/sync_pubspec_assets.py        # هذا السكربت
    5) أوقف التطبيق ثم: flutter run                # إعادة تشغيل كاملة (لا hot reload)
       (الـ seeder يعيد قراءة content.json تلقائياً عند كل تشغيل.)
"""

import json
import sys
from pathlib import Path

# على ويندوز الطرفية الافتراضية cp1252 فتفشل طباعة العربية؛ نفرض UTF-8.
for _stream in (sys.stdout, sys.stderr):
    try:
        _stream.reconfigure(encoding="utf-8")
    except (AttributeError, ValueError):
        pass

ROOT = Path(__file__).resolve().parent.parent
CONTENT_JSON = ROOT / "assets" / "content" / "content.json"
PUBSPEC = ROOT / "pubspec.yaml"


def build_asset_lines(spec):
    """يُدرج فقط المجلدات الموجودة على القرص — لأن Flutter يفشل عند إعلان مجلد
    غير موجود. العناصر التي في content.json لكن لم تُولَّد صورها بعد تُتخطّى."""
    content_dir = ROOT / "assets" / "content"
    lines = ["    - assets/content/content.json"]
    if (content_dir / "praise").is_dir():
        lines.append("    - assets/content/praise/")
    skipped = []
    for category in spec["categories"]:
        cid = category["id"]
        for item in category["items"]:
            iid = item["id"]
            item_dir = content_dir / cid / iid
            if not item_dir.is_dir():
                skipped.append(f"{cid}/{iid}")
                continue
            lines.append(f"    - assets/content/{cid}/{iid}/")
            if (item_dir / "audio").is_dir():
                lines.append(f"    - assets/content/{cid}/{iid}/audio/")
    return lines, skipped


def main():
    spec = json.loads(CONTENT_JSON.read_text(encoding="utf-8"))
    pubspec_lines = PUBSPEC.read_text(encoding="utf-8").splitlines()

    # Find the `  assets:` key and the next 2-space key (e.g. `  fonts:`).
    try:
        start = next(i for i, l in enumerate(pubspec_lines) if l.rstrip() == "  assets:")
    except StopIteration:
        sys.exit("لم يُعثر على '  assets:' تحت قسم flutter في pubspec.yaml")

    end = len(pubspec_lines)
    for i in range(start + 1, len(pubspec_lines)):
        line = pubspec_lines[i]
        # نهاية الكتلة = أول سطر بمسافة بادئة = مفتاحين (مثل '  fonts:').
        if line and not line[0].isspace():
            end = i
            break
        if line.startswith("  ") and not line.startswith("    ") and line.strip():
            end = i
            break

    asset_lines, skipped = build_asset_lines(spec)
    new_block = ["  assets:"] + asset_lines
    updated = pubspec_lines[:start] + new_block + pubspec_lines[end:]
    PUBSPEC.write_text("\n".join(updated) + "\n", encoding="utf-8")

    item_count = sum(len(c["items"]) for c in spec["categories"])
    print(f"✓ حُدّثت pubspec: {len(spec['categories'])} مجموعات، {item_count} عناصر "
          f"({len(asset_lines)} مدخل أصول).")
    if skipped:
        print(f"⚠ تُخطّيت {len(skipped)} عناصر بلا مجلد صور بعد (ولّد صورها ثم أعد التشغيل):")
        print("   " + "، ".join(skipped))
    print("  التالي: أوقف التطبيق ثم شغّل  flutter run  (إعادة تشغيل كاملة).")


if __name__ == "__main__":
    main()
