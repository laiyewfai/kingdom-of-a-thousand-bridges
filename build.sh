#!/bin/bash
# Build index.html from README.md (English) + README.zh.md (Chinese).
# Each language lives in exactly one file; this script only assembles them.
# Requires: pandoc (brew install pandoc)
set -eu
cd "$(dirname "$0")"

render() { # render <markdown file>
  pandoc "$1" \
    --from markdown+smart \
    --to html5 \
    --syntax-highlighting=none | python3 postprocess_tables.py
}

BODY_EN="$(render README.md)"
BODY_ZH="$(render README.zh.md)"

cat > index.html <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>The Kingdom of a Thousand Bridges — A Fable About Knowledge, Judgment, and Truth</title>
<meta name="description" content="A fable about knowledge, judgment, and truth — and the graduate-level concepts behind it: epistemic reasoning, knowledge provenance, and the open-world assumption in knowledge graphs. Available in English and Chinese.">
<meta property="og:title" content="The Kingdom of a Thousand Bridges">
<meta property="og:description" content="A fable about knowledge, judgment, and truth — and the knowledge-graph concepts behind it.">
<meta property="og:type" content="article">
<link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🌉</text></svg>">
<style>
:root{
  --paper:#faf7f1; --ink:#211f1b; --muted:#6b655c; --rule:#ddd5c7;
  --accent:#8a6a3f; --quote:#f2ede3; --code:#efe9dd;
}
@media (prefers-color-scheme: dark){
  :root{
    --paper:#15140f; --ink:#e9e4d9; --muted:#9c9486; --rule:#332f26;
    --accent:#c8a06a; --quote:#1d1b15; --code:#221f18;
  }
}
*{box-sizing:border-box}
html{-webkit-text-size-adjust:100%}
/* language switching — mirrors the Tao De Jing almanac: one class per language */
html[lang="zh"] .len{display:none}
html[lang="en"] .lzh{display:none}
body{
  margin:0; background:var(--paper); color:var(--ink);
  font-family:ui-serif,Georgia,"Iowan Old Style","Palatino Linotype",Palatino,serif;
  font-size:1.0625rem; line-height:1.72; text-rendering:optimizeLegibility;
  -webkit-font-smoothing:antialiased;
}
.lzh{
  font-family:"Songti SC","Noto Serif SC","Source Han Serif SC","STSong",
              ui-serif,Georgia,serif;
  line-height:1.95;
}
main{max-width:40rem; margin:0 auto; padding:2.5rem 1.5rem 7rem}
.topbar{
  display:flex; justify-content:flex-end; align-items:center;
  margin:0 0 1.6rem;
}
.lang-switch{
  display:inline-flex; border:1px solid var(--accent); border-radius:22px;
  overflow:hidden; background:var(--quote);
}
.lang-switch button{
  font-family:ui-sans-serif,-apple-system,"Segoe UI",Helvetica,Arial,sans-serif;
  font-size:.78rem; letter-spacing:.06em; color:var(--muted);
  background:transparent; border:none; padding:0 1.1rem; cursor:pointer;
  /* 44px minimum tap target; a 30px pill failed that on mobile */
  display:inline-flex; align-items:center; justify-content:center;
  min-height:44px;
  transition:background .2s, color .2s;
}
.lang-switch button + button{border-left:1px solid var(--rule)}
.lang-switch button.active{background:var(--accent); color:var(--paper)}
.lang-switch button:not(.active):hover{color:var(--accent)}
.lang-switch button:focus-visible{outline:2px solid var(--accent); outline-offset:2px}
h1{
  font-size:clamp(1.9rem,5vw,2.9rem); line-height:1.15; font-weight:600;
  letter-spacing:-.02em; margin:0 0 .6rem; text-align:center; text-wrap:balance;
}
.lzh h1{letter-spacing:.04em}
/* The subtitle sits under the title. It used to be an <h3>, which skipped a
   heading level (h1 → h3) and broke the document outline for screen readers.
   Semantics fixed here; the look is unchanged. */
.subtitle p{
  font-size:1.02rem; font-weight:400; font-style:italic; color:var(--muted);
  text-align:center; margin:0 0 3.5rem; letter-spacing:.01em; text-wrap:pretty;
}
.lzh .subtitle p{font-style:normal; letter-spacing:.12em}
h2{
  font-size:.82rem; font-weight:600; text-transform:uppercase;
  letter-spacing:.16em; color:var(--accent); text-align:center;
  margin:4.5rem 0 2.2rem; padding-top:2.2rem; border-top:1px solid var(--rule);
  text-wrap:balance;
}
.lzh h2{letter-spacing:.18em; font-size:.92rem}
h3{font-size:1.12rem; font-weight:600; margin:2.8rem 0 .8rem; letter-spacing:-.01em}
/* pretty breaks pull a single word back up, so body copy stops ending on a
   one-word last line. Chrome and Safari honour it; older engines ignore it. */
p{margin:0 0 1.25rem; text-wrap:pretty}
hr{border:0; border-top:1px solid var(--rule); margin:4rem 0}
/* the English fable opens with a drop cap; CJK has no drop-cap tradition */
.len > p:first-of-type::first-letter{
  float:left; font-size:3.6rem; line-height:.82; padding:.1rem .55rem 0 0;
  font-weight:600; color:var(--accent);
}
blockquote{
  margin:1.8rem 0; padding:1rem 1.3rem; background:var(--quote);
  border-left:3px solid var(--accent); border-radius:0 4px 4px 0;
  font-style:italic; color:var(--ink);
}
.lzh blockquote{font-style:normal}   /* synthetic oblique ruins CJK glyphs */
blockquote p{margin:0}
blockquote p + p{margin-top:.8rem}
strong{font-weight:600}
ul,ol{margin:0 0 1.25rem; padding-left:1.4rem}
li{margin:.35rem 0; text-wrap:pretty}
li::marker{color:var(--accent)}
table{
  border-collapse:collapse; width:100%; margin:2rem 0; font-size:.94rem;
  font-family:ui-sans-serif,-apple-system,"Segoe UI",Helvetica,Arial,sans-serif;
}
th,td{text-align:left; padding:.7rem .8rem; border-bottom:1px solid var(--rule); vertical-align:top}
th{font-weight:600; font-size:.82rem; text-transform:uppercase; letter-spacing:.08em; color:var(--muted)}
tbody tr:last-child td{border-bottom:0}
code{font-family:ui-monospace,SFMono-Regular,Menlo,monospace; font-size:.88em; background:var(--code); padding:.12em .35em; border-radius:3px}
a{color:var(--accent); text-underline-offset:2px}
a:hover{text-decoration-thickness:2px}
footer{
  max-width:40rem; margin:0 auto; padding:0 1.5rem 5rem;
  border-top:1px solid var(--rule); padding-top:1.5rem;
  font-family:ui-sans-serif,-apple-system,"Segoe UI",Helvetica,Arial,sans-serif;
  font-size:.82rem; color:var(--muted);
}
@media (max-width:34rem){
  main{padding:1.6rem 1.2rem 4rem}
  /* Stack each table row into a labelled card. Horizontal scroll hid the OWA
     column; fixed-width compression crushed it to ~5/10 readability. Stacking
     keeps every value visible at full text size. data-label comes from
     postprocess_tables.py — markdown tables cannot emit it themselves. */
  table{display:block; width:100%; margin:1.6rem 0}
  thead{display:none}
  tbody,tbody tr,tbody td{display:block; width:auto}
  tbody tr{
    border:1px solid var(--rule); border-radius:6px;
    margin:0 0 .9rem; padding:.55rem .8rem .6rem; background:var(--quote);
  }
  tbody td{border:0; padding:.3rem 0 .35rem; font-size:.95rem}
  tbody td::before{
    content:attr(data-label); display:block; margin-bottom:.1rem;
    font-size:.66rem; font-weight:600; letter-spacing:.09em;
    text-transform:uppercase; color:var(--accent);
    font-family:ui-sans-serif,-apple-system,"Segoe UI",Helvetica,Arial,sans-serif;
  }
  /* first cell is the row's name — it heads the card, so no label above it */
  tbody td:first-child{padding-top:0; font-weight:600; font-size:1rem}
  tbody td:first-child::before{content:none}
}
@media print{
  :root{--paper:#fff; --ink:#000; --muted:#555; --accent:#333; --quote:#f5f5f5}
  main{padding:0; max-width:none}
  h2{page-break-after:avoid}
  .topbar{display:none}
}
</style>
</head>
<body>
<main>
<div class="topbar">
  <div class="lang-switch" role="group" aria-label="Language / 语言">
    <button type="button" data-lang="en" aria-label="English">EN</button>
    <button type="button" data-lang="zh" aria-label="中文">中</button>
  </div>
</div>

<div class="len" lang="en">
${BODY_EN}
</div>

<div class="lzh" lang="zh-Hans">
${BODY_ZH}
</div>
</main>
<footer>
  <p class="len">The Kingdom of a Thousand Bridges — a fable about knowledge, judgment, and truth.</p>
  <p class="lzh">千桥之国 —— 一则关于知识、判断与真相的寓言。</p>
  <p class="len">© 2026 Lai Yew Fai · <a href="https://creativecommons.org/licenses/by-nc/4.0/">CC BY-NC 4.0</a> · <a href="https://github.com/laiyewfai/kingdom-of-a-thousand-bridges">Source on GitHub</a></p>
  <p class="lzh">© 2026 Lai Yew Fai · <a href="https://creativecommons.org/licenses/by-nc/4.0/">CC BY-NC 4.0</a> · <a href="https://github.com/laiyewfai/kingdom-of-a-thousand-bridges">GitHub 源码</a></p>
</footer>
<script>
  var root = document.documentElement;
  var buttons = document.querySelectorAll('.lang-switch button');
  var TITLES = {
    en: 'The Kingdom of a Thousand Bridges — A Fable About Knowledge, Judgment, and Truth',
    zh: '千桥之国 —— 一则关于知识、判断与真相的寓言'
  };
  function applyLang(lang) {
    root.lang = lang;
    document.title = TITLES[lang] || TITLES.en;
    buttons.forEach(function (b) {
      b.classList.toggle('active', b.getAttribute('data-lang') === lang);
    });
  }
  var saved = null;
  try { saved = localStorage.getItem('kingdom-lang'); } catch (e) {}
  applyLang(saved === 'zh' ? 'zh' : 'en');
  buttons.forEach(function (b) {
    b.addEventListener('click', function () {
      applyLang(b.getAttribute('data-lang'));
      try { localStorage.setItem('kingdom-lang', root.lang); } catch (e) {}
    });
  });
</script>
</body>
</html>
HTML

echo "built index.html ($(wc -c < index.html | tr -d ' ') bytes)"
