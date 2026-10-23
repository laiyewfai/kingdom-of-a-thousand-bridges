#!/bin/bash
# Build index.html from README.md so the prose lives in exactly one place.
# Requires: pandoc (brew install pandoc)
set -eu
cd "$(dirname "$0")"

BODY="$(pandoc README.md \
  --from markdown+smart \
  --to html5 \
  --syntax-highlighting=none)"

cat > index.html <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>The Kingdom of a Thousand Bridges — A Fable About Knowledge, Judgment, and Truth</title>
<meta name="description" content="A fable about knowledge, judgment, and truth — and the graduate-level concepts behind it: epistemic reasoning, knowledge provenance, and the open-world assumption in knowledge graphs.">
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
body{
  margin:0; background:var(--paper); color:var(--ink);
  font-family:ui-serif,Georgia,"Iowan Old Style","Palatino Linotype",Palatino,serif;
  font-size:1.0625rem; line-height:1.72; text-rendering:optimizeLegibility;
  -webkit-font-smoothing:antialiased;
}
main{max-width:40rem; margin:0 auto; padding:5rem 1.5rem 7rem}
h1{
  font-size:clamp(1.9rem,5vw,2.9rem); line-height:1.15; font-weight:600;
  letter-spacing:-.02em; margin:0 0 .6rem; text-align:center;
}
h1 + h3{
  font-size:1.02rem; font-weight:400; font-style:italic; color:var(--muted);
  text-align:center; margin:0 0 3.5rem; letter-spacing:.01em;
}
h2{
  font-size:.82rem; font-weight:600; text-transform:uppercase;
  letter-spacing:.16em; color:var(--accent); text-align:center;
  margin:4.5rem 0 2.2rem; padding-top:2.2rem; border-top:1px solid var(--rule);
}
h3{font-size:1.12rem; font-weight:600; margin:2.8rem 0 .8rem; letter-spacing:-.01em}
p{margin:0 0 1.25rem}
hr{border:0; border-top:1px solid var(--rule); margin:4rem 0}
/* the fable opens with a drop cap; scripts and long words stay inside the measure */
main > p:first-of-type::first-letter{
  float:left; font-size:3.6rem; line-height:.82; padding:.1rem .55rem 0 0;
  font-weight:600; color:var(--accent);
}
blockquote{
  margin:1.8rem 0; padding:1rem 1.3rem; background:var(--quote);
  border-left:3px solid var(--accent); border-radius:0 4px 4px 0;
  font-style:italic; color:var(--ink);
}
blockquote p{margin:0}
blockquote p + p{margin-top:.8rem}
strong{font-weight:600}
ul,ol{margin:0 0 1.25rem; padding-left:1.4rem}
li{margin:.35rem 0}
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
  main{padding:3rem 1.2rem 4rem}
  table{display:block; overflow-x:auto; white-space:nowrap}
  th,td{white-space:normal; min-width:11rem}
}
@media print{
  :root{--paper:#fff; --ink:#000; --muted:#555; --accent:#333; --quote:#f5f5f5}
  main{padding:0; max-width:none}
  h2{page-break-after:avoid}
}
</style>
</head>
<body>
<main>
${BODY}
</main>
<footer>
  <p>The Kingdom of a Thousand Bridges — a fable about knowledge, judgment, and truth.</p>
  <p><a href="https://github.com/laiyewfai/kingdom-of-a-thousand-bridges">Source on GitHub</a></p>
</footer>
</body>
</html>
HTML

echo "built index.html ($(wc -c < index.html | tr -d ' ') bytes)"
