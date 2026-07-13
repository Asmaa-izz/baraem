#!/usr/bin/env python3
"""
مولّد صفحة معاينة لكل صور مكتبة المحتوى.

يقرأ assets/content/content.json ويولّد ملف HTML مستقلاً يعرض كل الصور مقسّمة
حسب المجموعة، وتحت كل صورة معرّفها بصيغة "category/item/n" قابل للنسخ بنقرة —
لتسهيل الإشارة إلى أي صورة تريد تغييرها.

الصفحة تشير إلى الصور بمسارات نسبية (لا تنسخها)، فافتحها من جذر المشروع.

الاستخدام:
    python3 tools/build_preview_gallery.py           # ينشئ gallery.html في جذر المشروع
    python3 tools/build_preview_gallery.py out.html  # مسار مخصّص
"""

import html
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CONTENT_DIR = ROOT / "assets" / "content"
CONTENT_JSON = CONTENT_DIR / "content.json"


def main():
    out_path = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "gallery.html"
    if not out_path.is_absolute():
        out_path = ROOT / out_path

    spec = json.loads(CONTENT_JSON.read_text(encoding="utf-8"))
    styles = [s["id"] for s in spec.get("styles", [])]
    categories = sorted(spec["categories"], key=lambda c: c.get("order", 0))

    total_imgs = 0
    total_missing = 0
    sections = []
    for cat in categories:
        cells = []
        for item in cat["items"]:
            for n in range(1, len(styles) + 1):
                rel = f'assets/content/{cat["id"]}/{item["id"]}/{n}.jpg'
                ident = f'{cat["id"]}/{item["id"]}/{n}'
                exists = (ROOT / rel).exists()
                style_name = styles[n - 1] if n - 1 < len(styles) else str(n)
                sub = html.escape(f'{item["label"]} · {style_name}')
                if exists:
                    total_imgs += 1
                    img_html = f'<img loading="lazy" src="{rel}" alt="{ident}">'
                else:
                    total_missing += 1
                    img_html = '<div class="missing">صورة مفقودة</div>'
                cells.append(
                    f'<figure>{img_html}'
                    f'<button class="id" data-id="{ident}" title="انقر للنسخ">{ident}</button>'
                    f'<figcaption>{sub}</figcaption></figure>'
                )
        sections.append(
            f'<section><h2>{html.escape(cat.get("icon",""))} '
            f'{html.escape(cat["name"])} <span class="count">({len(cat["items"])} عناصر)</span></h2>'
            f'<div class="grid">{"".join(cells)}</div></section>'
        )

    page = f"""<!doctype html>
<html lang="ar" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>معاينة صور براعم</title>
<style>
  :root {{ color-scheme: light dark; }}
  * {{ box-sizing: border-box; }}
  body {{ font-family: system-ui, "Segoe UI", Tahoma, sans-serif; margin: 0; padding: 1.25rem;
         background: #f5f5f7; color: #1d1d1f; }}
  @media (prefers-color-scheme: dark) {{ body {{ background:#111; color:#eee; }} }}
  header {{ position: sticky; top: 0; z-index: 5; background: inherit; padding: .5rem 0 1rem;
           border-bottom: 1px solid #8883; margin-bottom: 1rem; }}
  h1 {{ font-size: 1.4rem; margin: 0 0 .25rem; }}
  .meta {{ opacity: .7; font-size: .9rem; }}
  input[type=search] {{ width: 100%; max-width: 420px; margin-top: .6rem; padding: .5rem .75rem;
           border-radius: 8px; border: 1px solid #8886; background: #fff2; color: inherit; font-size: 1rem; }}
  h2 {{ font-size: 1.15rem; margin: 1.5rem 0 .75rem; }}
  .count {{ opacity: .55; font-weight: 400; font-size: .85rem; }}
  .grid {{ display: grid; grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: .9rem; }}
  figure {{ margin: 0; background: #fff3; border: 1px solid #8882; border-radius: 12px;
           overflow: hidden; display: flex; flex-direction: column; }}
  @media (prefers-color-scheme: dark) {{ figure {{ background:#1c1c1e; }} }}
  figure img {{ width: 100%; aspect-ratio: 1; object-fit: cover; display: block; background:#8881; }}
  .missing {{ width:100%; aspect-ratio:1; display:flex; align-items:center; justify-content:center;
             color:#c33; background:#c331; font-size:.85rem; }}
  button.id {{ font-family: ui-monospace, "Cascadia Code", Consolas, monospace; font-size: .8rem;
             direction: ltr; text-align: center; padding: .4rem .3rem; border: 0; cursor: pointer;
             background: transparent; color: inherit; border-top: 1px solid #8882; }}
  button.id:hover {{ background: #4a90d922; }}
  button.id.copied {{ background: #34c759; color: #fff; }}
  figcaption {{ font-size: .78rem; text-align: center; padding: .15rem .3rem .5rem; opacity: .65; }}
  figure.hidden {{ display: none; }}
</style>
</head>
<body>
<header>
  <h1>معاينة صور مكتبة براعم</h1>
  <div class="meta">{total_imgs} صورة{f' · {total_missing} مفقودة' if total_missing else ''}
    · انقر على المعرّف تحت أي صورة لنسخه</div>
  <input type="search" placeholder="بحث بالمعرّف أو الاسم… مثال: apple أو تفاحة">
</header>
{"".join(sections)}
<script>
  document.addEventListener('click', async (e) => {{
    const btn = e.target.closest('button.id');
    if (!btn) return;
    try {{ await navigator.clipboard.writeText(btn.dataset.id); }} catch (_) {{}}
    const old = btn.textContent;
    btn.textContent = '✓ نُسخ'; btn.classList.add('copied');
    setTimeout(() => {{ btn.textContent = old; btn.classList.remove('copied'); }}, 900);
  }});
  const search = document.querySelector('input[type=search]');
  search.addEventListener('input', () => {{
    const q = search.value.trim().toLowerCase();
    document.querySelectorAll('figure').forEach(f => {{
      const hay = (f.querySelector('.id').dataset.id + ' ' + f.querySelector('figcaption').textContent).toLowerCase();
      f.classList.toggle('hidden', q && !hay.includes(q));
    }});
    document.querySelectorAll('section').forEach(s => {{
      const any = [...s.querySelectorAll('figure')].some(f => !f.classList.contains('hidden'));
      s.style.display = any ? '' : 'none';
    }});
  }});
</script>
</body>
</html>"""

    out_path.write_text(page, encoding="utf-8")
    print(f"✓ أُنشئت صفحة المعاينة: {out_path}")
    print(f"  {total_imgs} صورة" + (f" · {total_missing} مفقودة" if total_missing else "") +
          f" · {len(categories)} مجموعات")
    print(f"  افتحها في المتصفّح: file:///{out_path.as_posix()}")


if __name__ == "__main__":
    main()
