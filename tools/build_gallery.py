#!/usr/bin/env python3
"""
يبني صفحة HTML مستقلّة لمعاينة كل صور مكتبة المحتوى (contact sheet)،
مجمّعة حسب المجموعة ثم العنصر ثم الستايل. الصور مصغّرة ومضمّنة كـ data URI
(بدون اعتماد على ملفات خارجية) ليسهل نشرها كـ Artifact أو فتحها محلياً.

الاستخدام:
    python3 tools/build_gallery.py [مسار_الإخراج.html]
"""

import base64
import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path

CONTENT_DIR = Path(__file__).resolve().parent.parent / "assets" / "content"
CONTENT_JSON = CONTENT_DIR / "content.json"
DEFAULT_OUT = CONTENT_DIR / "_gallery.html"
THUMB_MAX = 420

STYLE_AR = {
    "photo": "صورة واقعية",
    "render3d": "ثلاثية الأبعاد",
    "vector": "فيكتور مسطّح",
    "cartoon": "كرتون",
    "watercolor": "ألوان مائية",
}


def thumb_data_uri(path):
    """يصغّر الصورة إلى THUMB_MAX عبر sips ويعيدها كـ data URI."""
    handle = tempfile.NamedTemporaryFile(suffix=".jpg", delete=False)
    handle.close()
    try:
        subprocess.run(
            ["sips", "-Z", str(THUMB_MAX), str(path), "--out", handle.name],
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True,
        )
        data = Path(handle.name).read_bytes()
    finally:
        os.unlink(handle.name)
    return "data:image/jpeg;base64," + base64.b64encode(data).decode("ascii")


def audio_data_uri(path):
    """يضمّن ملف mp3 كـ data URI (بدون تعديل)."""
    return "data:audio/mpeg;base64," + base64.b64encode(path.read_bytes()).decode("ascii")


CSS = """
<style>
  :root{
    --ground:#FAF8F2; --surface:#FFFFFF; --ink:#26302A; --muted:#6E7A6E;
    --line:#E7E2D5; --sprout:#5E9A3E; --peach:#E0966A; --sky:#7FA9C9;
    --radius:14px; --shadow:0 1px 2px rgba(38,48,42,.06),0 6px 18px rgba(38,48,42,.05);
  }
  @media (prefers-color-scheme:dark){
    :root{
      --ground:#161B17; --surface:#1E241E; --ink:#E9EDE4; --muted:#9BA79B;
      --line:#2B332B; --sprout:#8FC169; --peach:#E0966A; --sky:#8FB8D8;
      --shadow:0 1px 2px rgba(0,0,0,.3),0 6px 18px rgba(0,0,0,.25);
    }
  }
  :root[data-theme="light"]{
    --ground:#FAF8F2; --surface:#FFFFFF; --ink:#26302A; --muted:#6E7A6E;
    --line:#E7E2D5; --sprout:#5E9A3E; --peach:#E0966A; --sky:#7FA9C9;
    --shadow:0 1px 2px rgba(38,48,42,.06),0 6px 18px rgba(38,48,42,.05);
  }
  :root[data-theme="dark"]{
    --ground:#161B17; --surface:#1E241E; --ink:#E9EDE4; --muted:#9BA79B;
    --line:#2B332B; --sprout:#8FC169; --peach:#E0966A; --sky:#8FB8D8;
    --shadow:0 1px 2px rgba(0,0,0,.3),0 6px 18px rgba(0,0,0,.25);
  }
  *{box-sizing:border-box}
  .wrap{
    background:var(--ground); color:var(--ink); min-height:100vh;
    font-family:"SF Arabic","Geeza Pro","Noto Sans Arabic",system-ui,-apple-system,"Segoe UI",Tahoma,sans-serif;
    padding:clamp(20px,4vw,48px); line-height:1.5;
  }
  .mono{font-family:ui-monospace,"SF Mono",Menlo,Consolas,monospace;font-variant-numeric:tabular-nums}
  header{max-width:1080px;margin:0 auto 28px}
  h1{font-size:clamp(1.7rem,4vw,2.5rem);margin:0 0 6px;letter-spacing:-.01em;text-wrap:balance}
  .lede{color:var(--muted);font-size:1.02rem;margin:0 0 18px;max-width:60ch}
  .stats{display:flex;flex-wrap:wrap;gap:10px}
  .stat{
    background:var(--surface);border:1px solid var(--line);border-radius:999px;
    padding:7px 14px;font-size:.9rem;box-shadow:var(--shadow);
  }
  .stat b{color:var(--sprout)}
  .legend{
    max-width:1080px;margin:0 auto 30px;display:flex;flex-wrap:wrap;gap:8px;
    padding-top:16px;border-top:1px solid var(--line);
  }
  .chip{
    font-size:.78rem;padding:4px 11px;border-radius:8px;border:1px solid var(--line);
    background:var(--surface);color:var(--muted);
  }
  .chip .k{color:var(--ink);font-weight:600}
  section.cat{max-width:1080px;margin:0 auto 12px}
  .cat-h{display:flex;align-items:center;gap:10px;margin:34px 0 4px}
  .cat-h .ic{font-size:1.5rem}
  .cat-h h2{font-size:1.35rem;margin:0}
  .cat-h .n{color:var(--muted);font-size:.9rem;margin-inline-start:2px}
  .item{
    background:var(--surface);border:1px solid var(--line);border-radius:var(--radius);
    box-shadow:var(--shadow);padding:16px;margin-top:16px;
  }
  .item-h{display:flex;align-items:baseline;gap:10px;margin-bottom:12px}
  .item-h h3{font-size:1.15rem;margin:0}
  .item-h .id{color:var(--muted);font-size:.82rem}
  .grid{display:grid;grid-template-columns:repeat(5,1fr);gap:12px}
  @media (max-width:820px){.grid{grid-template-columns:repeat(3,1fr)}}
  @media (max-width:520px){.grid{grid-template-columns:repeat(2,1fr)}}
  figure{margin:0;display:flex;flex-direction:column;gap:7px}
  .frame{
    position:relative;aspect-ratio:1;border-radius:10px;overflow:hidden;
    background:var(--ground);border:1px solid var(--line);
  }
  .frame img{width:100%;height:100%;object-fit:cover;display:block}
  .frame .num{
    position:absolute;inset-block-start:6px;inset-inline-start:6px;
    font-size:.68rem;padding:1px 6px;border-radius:6px;
    background:rgba(0,0,0,.5);color:#fff;backdrop-filter:blur(2px);
  }
  figcaption{display:flex;flex-direction:column;gap:2px}
  .sname{font-size:.82rem;font-weight:600}
  .subj{font-size:.72rem;color:var(--muted);direction:ltr;text-align:start}
  footer{max-width:1080px;margin:36px auto 0;color:var(--muted);font-size:.82rem;
    border-top:1px solid var(--line);padding-top:16px}
  footer code{background:var(--surface);border:1px solid var(--line);border-radius:6px;padding:1px 6px;font-size:.78rem}
  .audio-row{display:flex;flex-wrap:wrap;gap:16px;margin:0 0 14px;padding:10px 12px;
    background:var(--ground);border:1px solid var(--line);border-radius:10px}
  .voice{display:flex;flex-direction:column;gap:4px}
  .vlabel{font-size:.75rem;color:var(--muted)}
  .voice audio{height:34px;max-width:230px}
</style>
"""


def build():
    spec = json.loads(CONTENT_JSON.read_text(encoding="utf-8"))
    styles = spec["styles"]
    voices = spec.get("voices", [])
    cats = spec["categories"]
    n_items = sum(len(c["items"]) for c in cats)
    n_images = n_items * len(styles)
    n_audio = n_items * len(voices)

    parts = ['<title>مكتبة براعم — معاينة المحتوى</title>', CSS, '<main class="wrap" dir="rtl" lang="ar">']

    parts.append('<header>')
    parts.append('<h1>مكتبة براعم — معاينة المحتوى</h1>')
    parts.append('<p class="lede">صور مكتبة النظام لتطبيق براعم. كل عنصر مُولَّد بخمسة ستايلات '
                 'مختلفة (خلفية ولون وزاوية وإضاءة متغيّرة) لدعم تعميم المفهوم عند الطفل.</p>')
    parts.append('<div class="stats">'
                 f'<span class="stat mono"><b>{n_images}</b> صورة</span>'
                 f'<span class="stat mono"><b>{n_items}</b> عنصر</span>'
                 f'<span class="stat mono"><b>{len(styles)}</b> ستايلات</span>'
                 f'<span class="stat mono"><b>{n_audio}</b> مقطع صوتي</span>'
                 f'<span class="stat mono"><b>{len(cats)}</b> مجموعات</span>'
                 '</div>')
    parts.append('</header>')

    parts.append('<div class="legend">')
    for i, st in enumerate(styles, start=1):
        ar = STYLE_AR.get(st["id"], st["id"])
        parts.append(f'<span class="chip mono">{i} · <span class="k">{ar}</span> · {st["id"]}</span>')
    parts.append('</div>')

    for cat in cats:
        parts.append('<section class="cat">')
        parts.append(f'<div class="cat-h"><span class="ic">{cat.get("icon","")}</span>'
                     f'<h2>{cat["name"]}</h2><span class="n mono">{len(cat["items"])} عناصر</span></div>')
        for item in cat["items"]:
            subjects = item["subjects"]
            parts.append('<div class="item">')
            parts.append(f'<div class="item-h"><h3>{item["label"]}</h3>'
                         f'<span class="id mono">{cat["id"]}/{item["id"]}</span></div>')
            audio_bits = []
            for voice in voices:
                apath = CONTENT_DIR / cat["id"] / item["id"] / "audio" / f'{voice["id"]}.mp3'
                if apath.exists():
                    audio_bits.append(
                        f'<span class="voice"><span class="vlabel">🔊 {voice["label"]}</span>'
                        f'<audio controls preload="none" src="{audio_data_uri(apath)}"></audio></span>'
                    )
            if audio_bits:
                parts.append('<div class="audio-row">' + "".join(audio_bits) + '</div>')
            parts.append('<div class="grid">')
            for idx, st in enumerate(styles, start=1):
                subject = subjects[(idx - 1) % len(subjects)]
                path = CONTENT_DIR / cat["id"] / item["id"] / f'{idx}.jpg'
                ar = STYLE_AR.get(st["id"], st["id"])
                uri = thumb_data_uri(path) if path.exists() else ""
                img = f'<img src="{uri}" alt="{item["label"]} - {ar}" loading="lazy">' if uri else '<div class="subj" style="padding:10px">مفقودة</div>'
                parts.append(
                    '<figure>'
                    f'<div class="frame">{img}<span class="num mono">{idx}</span></div>'
                    f'<figcaption><span class="sname">{ar}</span>'
                    f'<span class="subj mono">{subject}</span></figcaption>'
                    '</figure>'
                )
            parts.append('</div></div>')
        parts.append('</section>')

    parts.append('<footer>أُنشئت هذه المعاينة من <code>assets/content/content.json</code>. '
                 'لإعادة التوليد: <code>python3 tools/build_gallery.py</code>. '
                 'لإصلاح صورة: احذفها ثم <code>python3 tools/generate_content_images.py --item ID --salt N</code>. '
                 'لإعادة توليد الصوت: <code>python3 tools/generate_content_audio.py --item ID --force</code>.</footer>')
    parts.append('</main>')
    return "\n".join(parts)


def main():
    out = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_OUT
    html = build()
    out.write_text(html, encoding="utf-8")
    size_kb = len(html.encode("utf-8")) // 1024
    print(f"كُتب المعرض: {out}  ({size_kb} كيلوبايت)")


if __name__ == "__main__":
    main()
