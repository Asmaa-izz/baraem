#!/usr/bin/env python3
"""
يبني صفحة HTML محلية واحدة تعرض كل صور assets/content (مضمَّنة base64، لا
تعتمد على مسارات نسبية) مع إمكانية "تعليم" الصور غير المستساغة بالنقر عليها،
ثم زر لنسخ أوامر جاهزة (حذف + إعادة توليد) للصور المعلَّمة فقط.

الاستخدام:
    python3 tools/build_image_review.py
    python3 tools/build_image_review.py --out custom/path.html
"""

import argparse
import base64
import json
import re
import sys
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
CATEGORIES = ["household", "animals", "birds", "vegetables", "fruits", "clothes", "home"]


def build_caption(item, index, style_count, styles):
    subjects = item.get("subjects", [])
    sections = item.get("sections", [])
    if index <= style_count:
        style = styles[index - 1]["id"] if index - 1 < len(styles) else "?"
        subject = subjects[(index - 1) % len(subjects)] if subjects else ""
        return f"{style}: {subject}"
    section_i = index - style_count - 1
    text = sections[section_i] if section_i < len(sections) else ""
    return f"قطع (الجزء) {section_i + 1}: {text}"


def numeric_key(path):
    m = re.match(r"(\d+)\.jpg$", path.name)
    return int(m.group(1)) if m else 999


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--out",
        default=str(REPO_ROOT / "tools" / "image_review.html"),
        help="مسار ملف الإخراج",
    )
    parser.add_argument(
        "--only",
        default=None,
        help="فلترة حسب معرّف مجموعة واحدة (مثل clothes) لصفحة أخف وأسرع",
    )
    args = parser.parse_args()

    spec = json.loads(CONTENT_JSON.read_text(encoding="utf-8"))
    styles = spec.get("styles", [])
    style_count = len(styles)
    categories_to_render = [args.only] if args.only else CATEGORIES
    cat_specs = {c["id"]: c for c in spec["categories"]}

    sections_html = []
    total_images = 0

    for cat_id in categories_to_render:
        cat_dir = CONTENT_DIR / cat_id
        if not cat_dir.is_dir():
            continue
        cat_spec = cat_specs.get(cat_id, {})
        cat_name = cat_spec.get("name", cat_id)
        item_specs = {it["id"]: it for it in cat_spec.get("items", [])}

        item_blocks = []
        for item_dir in sorted(cat_dir.iterdir()):
            if not item_dir.is_dir():
                continue
            item_id = item_dir.name
            item_spec = item_specs.get(item_id, {})
            item_label = item_spec.get("label", item_id)
            jpgs = sorted(item_dir.glob("*.jpg"), key=numeric_key)
            if not jpgs:
                continue

            cards = []
            for jpg in jpgs:
                m = re.match(r"(\d+)\.jpg$", jpg.name)
                if not m:
                    continue
                index = int(m.group(1))
                caption = build_caption(item_spec, index, style_count, styles) if item_spec else jpg.name
                b64 = base64.b64encode(jpg.read_bytes()).decode("ascii")
                key = f"{cat_id}/{item_id}/{index}"
                rel_path = f"assets/content/{cat_id}/{item_id}/{index}.jpg"
                cards.append(
                    f'''<figure class="card" data-key="{key}" data-cat="{cat_id}"
                        data-item="{item_id}" data-path="{rel_path}" onclick="toggleFlag(this)">
                      <img src="data:image/jpeg;base64,{b64}" loading="lazy" alt="{key}">
                      <span class="badge">✕</span>
                      <figcaption>{index}.jpg — {caption}</figcaption>
                    </figure>'''
                )
                total_images += 1

            item_blocks.append(
                f'''<div class="item-row">
                  <h3>{item_label} <span class="muted">({item_id})</span></h3>
                  <div class="cards">{''.join(cards)}</div>
                </div>'''
            )

        sections_html.append(
            f'''<section class="category" data-cat="{cat_id}" id="cat-{cat_id}">
              <h2>{cat_spec.get('icon', '')} {cat_name} <span class="muted">({cat_id})</span></h2>
              {''.join(item_blocks)}
            </section>'''
        )

    cat_tabs = "".join(
        f'<button class="tab" data-cat="{c}" onclick="filterCat(\'{c}\')">{cat_specs.get(c, {}).get("name", c)}</button>'
        for c in categories_to_render
        if (CONTENT_DIR / c).is_dir()
    )

    html = f'''<!doctype html>
<html lang="ar" dir="rtl">
<head>
<meta charset="utf-8">
<title>مراجعة صور المحتوى — براعم</title>
<style>
  :root {{ color-scheme: light dark; }}
  * {{ box-sizing: border-box; }}
  body {{
    font-family: "Segoe UI", Tahoma, sans-serif;
    margin: 0;
    background: #f4f5f7;
    color: #1c1e21;
  }}
  @media (prefers-color-scheme: dark) {{
    body {{ background: #16171a; color: #e7e9ec; }}
    .card {{ background: #24262b !important; border-color: #333 !important; }}
    .toolbar {{ background: #1c1e21ee !important; border-color: #333 !important; }}
    textarea {{ background: #111 !important; color: #ddd !important; border-color: #444 !important; }}
    .tab {{ background: #24262b !important; color: #ddd !important; border-color: #444 !important; }}
  }}
  .toolbar {{
    position: sticky; top: 0; z-index: 10;
    background: #ffffffee; backdrop-filter: blur(6px);
    border-bottom: 1px solid #ddd;
    padding: 10px 16px;
    display: flex; flex-wrap: wrap; gap: 8px; align-items: center;
  }}
  .toolbar .count {{ font-weight: 700; color: #c0392b; }}
  .toolbar button {{
    border: 1px solid #ccc; background: #fff; border-radius: 8px;
    padding: 6px 12px; cursor: pointer; font-size: 13px;
  }}
  .toolbar button.primary {{ background: #2d6cdf; color: #fff; border-color: #2d6cdf; font-weight: 700; }}
  .tab {{
    border: 1px solid #ccc; background: #fff; border-radius: 999px;
    padding: 5px 14px; cursor: pointer; font-size: 13px;
  }}
  .tab.active {{ background: #1c1e21; color: #fff; }}
  main {{ padding: 16px; }}
  .category {{ margin-bottom: 32px; }}
  .category h2 {{ margin: 0 0 12px; }}
  .muted {{ color: #888; font-weight: 400; font-size: 0.75em; }}
  .item-row {{ margin-bottom: 18px; }}
  .item-row h3 {{ margin: 0 0 8px; font-size: 15px; }}
  .cards {{ display: flex; flex-wrap: wrap; gap: 10px; }}
  .card {{
    position: relative; width: 150px; background: #fff; border: 2px solid transparent;
    border-radius: 10px; overflow: hidden; cursor: pointer; box-shadow: 0 1px 3px rgba(0,0,0,.12);
    transition: border-color .15s, opacity .15s;
  }}
  .card img {{ width: 100%; height: 150px; object-fit: cover; display: block; }}
  .card figcaption {{
    font-size: 10.5px; padding: 5px 6px; line-height: 1.3; color: #555; min-height: 34px;
  }}
  .card .badge {{
    position: absolute; top: 4px; left: 4px; width: 22px; height: 22px; border-radius: 50%;
    background: #e74c3c; color: #fff; display: none; align-items: center; justify-content: center;
    font-size: 13px; font-weight: 700;
  }}
  .card.flagged {{ border-color: #e74c3c; }}
  .card.flagged .badge {{ display: flex; }}
  .card.flagged img {{ opacity: .55; }}
  .category.hidden {{ display: none; }}
  #copyBox {{
    position: fixed; inset: 0; background: #000000aa; display: none;
    align-items: center; justify-content: center; z-index: 50; padding: 20px;
  }}
  #copyBox.open {{ display: flex; }}
  #copyBox .panel {{
    background: #fff; border-radius: 12px; padding: 18px; max-width: 720px; width: 100%;
    max-height: 80vh; display: flex; flex-direction: column; gap: 10px;
  }}
  textarea {{
    width: 100%; height: 260px; font-family: Consolas, monospace; font-size: 12.5px;
    direction: ltr; text-align: left; padding: 10px; border-radius: 8px; border: 1px solid #ccc;
  }}
  #toast {{
    position: fixed; bottom: 20px; right: 20px; background: #1c1e21; color: #fff;
    padding: 10px 16px; border-radius: 8px; opacity: 0; transition: opacity .2s; z-index: 60;
  }}
  #toast.show {{ opacity: 1; }}
</style>
</head>
<body>

<div class="toolbar">
  <span>المعلَّمة: <span class="count" id="flagCount">0</span> / {total_images}</span>
  <button class="primary" onclick="openCopyBox()">نسخ أوامر إعادة التوليد</button>
  <button onclick="clearFlags()">مسح التحديد</button>
  <span style="width:1px;height:20px;background:#ccc;margin:0 4px"></span>
  <button class="tab active" data-cat="all" onclick="filterCat('all')">الكل</button>
  {cat_tabs}
</div>

<main>
  {''.join(sections_html)}
</main>

<div id="copyBox">
  <div class="panel">
    <h3 style="margin:0">أوامر الحذف + إعادة التوليد للصور المعلَّمة</h3>
    <p style="margin:0;font-size:13px;color:#666">
      نفّذي هذا في نافذة أوامر داخل مجلد المشروع (bash). كل مجموعة سطرين: حذف الملفات
      المعلَّمة ثم إعادة توليدها بـ seed مختلف (salt عشوائي) حتى لا تخرج نفس الصورة.
    </p>
    <textarea id="cmdText" readonly onclick="this.select()"></textarea>
    <div style="display:flex;gap:8px;justify-content:flex-end">
      <button onclick="closeCopyBox()">إغلاق</button>
      <button class="primary" onclick="copyCmd()">نسخ للحافظة</button>
    </div>
  </div>
</div>

<div id="toast"></div>

<script>
const STORAGE_KEY = 'baraem_image_review_flags_v1';
let flags = new Set(JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]'));

function persist() {{
  localStorage.setItem(STORAGE_KEY, JSON.stringify([...flags]));
}}

function refreshUI() {{
  document.getElementById('flagCount').textContent = flags.size;
  document.querySelectorAll('.card').forEach(c => {{
    c.classList.toggle('flagged', flags.has(c.dataset.key));
  }});
}}

function toggleFlag(el) {{
  const key = el.dataset.key;
  if (flags.has(key)) flags.delete(key); else flags.add(key);
  persist();
  refreshUI();
}}

function clearFlags() {{
  flags.clear();
  persist();
  refreshUI();
}}

function filterCat(cat) {{
  document.querySelectorAll('.tab').forEach(t => t.classList.toggle('active', t.dataset.cat === cat));
  document.querySelectorAll('.category').forEach(sec => {{
    sec.classList.toggle('hidden', cat !== 'all' && sec.dataset.cat !== cat);
  }});
}}

function buildCommands() {{
  const byCat = {{}};
  document.querySelectorAll('.card.flagged').forEach(c => {{
    const cat = c.dataset.cat;
    (byCat[cat] ??= {{ paths: [], items: new Set() }});
    byCat[cat].paths.push(c.dataset.path);
    byCat[cat].items.add(c.dataset.item);
  }});
  const lines = [];
  for (const [cat, {{ paths, items }}] of Object.entries(byCat)) {{
    const salt = Math.floor(Math.random() * 100000);
    lines.push(`# ${{cat}}: ${{[...items].join(', ')}}`);
    lines.push(`rm -f ${{paths.join(' ')}}`);
    lines.push(`python3 tools/generate_content_images.py --only ${{cat}} --item ${{[...items].join(',')}} --salt ${{salt}} --workers 1 --delay 8`);
    lines.push('');
  }}
  if (!lines.length) return '# لا صور معلَّمة بعد — انقري على الصور غير المستساغة أولاً.';
  lines.push('# بعد التنفيذ: python3 tools/build_image_review.py  # لتحديث هذه الصفحة');
  return lines.join('\\n');
}}

function openCopyBox() {{
  document.getElementById('cmdText').value = buildCommands();
  document.getElementById('copyBox').classList.add('open');
}}
function closeCopyBox() {{
  document.getElementById('copyBox').classList.remove('open');
}}
function copyCmd() {{
  const ta = document.getElementById('cmdText');
  ta.select();
  navigator.clipboard?.writeText(ta.value).then(showToast).catch(() => document.execCommand('copy'));
}}
function showToast() {{
  const t = document.getElementById('toast');
  t.textContent = 'تم النسخ ✓';
  t.classList.add('show');
  setTimeout(() => t.classList.remove('show'), 1500);
}}

refreshUI();
</script>
</body>
</html>
'''

    out_path = Path(args.out)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(html, encoding="utf-8")
    print(f"كُتبت الصفحة: {out_path}  ({total_images} صورة، {out_path.stat().st_size / 1_000_000:.1f} MB)")


if __name__ == "__main__":
    main()
