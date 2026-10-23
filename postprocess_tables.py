#!/usr/bin/env python3
"""Add data-label attributes to table cells so CSS can stack tables on phones.

A 3-column comparison table cannot fit a 390px viewport without either hiding a
column (horizontal scroll) or crushing the text. Both were tested and rejected.
Stacking is the readable option, and it needs each cell to carry the name of the
column it came from — markdown tables do not emit that, so it is added here.

Input: HTML on stdin. Output: HTML on stdout.
Only <table> blocks are touched; everything else passes through unchanged.
"""
import re
import sys
from html import unescape

TABLE_RE = re.compile(r"<table>(.*?)</table>", re.S)
TH_RE = re.compile(r"<th\b[^>]*>(.*?)</th>", re.S)
TD_OPEN_RE = re.compile(r"<td\b")


def cells(html: str) -> list[str]:
    """Text of each <th> in order, tags stripped."""
    out = []
    for raw in TH_RE.findall(html):
        text = re.sub(r"<[^>]+>", "", raw)
        out.append(unescape(text).strip())
    return out


def label_row(row_html: str, labels: list[str]) -> str:
    """Walk the <td> tags in one row and add data-label from the header order."""
    idx = 0
    pieces = []
    pos = 0
    for m in TD_OPEN_RE.finditer(row_html):
        pieces.append(row_html[pos:m.start()])
        label = labels[idx] if idx < len(labels) else ""
        idx += 1
        safe = label.replace('"', "&quot;")
        pieces.append(f'<td data-label="{safe}"')
        pos = m.start() + len("<td")
    pieces.append(row_html[pos:])
    return "".join(pieces)


def process_table(inner: str) -> str:
    labels = cells(inner)
    if not labels:
        return inner
    head_split = inner.split("</thead>", 1)
    if len(head_split) == 1:
        return inner
    head, rest = head_split
    body_rows = re.split(r"(?=<tr)", rest)
    rebuilt = []
    for chunk in body_rows:
        rebuilt.append(label_row(chunk, labels) if "<td" in chunk else chunk)
    return head + "</thead>" + "".join(rebuilt)


def main() -> None:
    src = sys.stdin.read()
    out = TABLE_RE.sub(lambda m: "<table>" + process_table(m.group(1)) + "</table>", src)
    sys.stdout.write(out)


if __name__ == "__main__":
    main()
