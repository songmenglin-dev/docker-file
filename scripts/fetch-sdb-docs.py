#!/usr/bin/env python3
"""Fetch all SequoiaDB documentation pages from the index URL and persist as
markdown + raw HTML under a per-cat_id directory structure."""
import concurrent.futures as cf
import hashlib
import html2text
import json
import sys
import time
from pathlib import Path
from urllib.parse import urlparse, unquote

import requests
from bs4 import BeautifulSoup

INDEX_URL = "https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1558957223-edition_id-0"
# Default: write next to this script under ./sequoiadb-docs/. Override with -o.
OUT_ROOT = Path(__file__).resolve().parent / "sequoiadb-docs"
MAX_WORKERS = 16
TIMEOUT = 30
UA = "Mozilla/5.0 (compatible; doc-fetch/1.0; +internal)"


def cat_id_from_url(url):
    """Extract the cat_id (or full slugs) so we can name local files."""
    p = urlparse(url)
    last = unquote(p.path.rstrip("/").split("/")[-1])
    return last.replace("/", "_")


def fetch(url):
    """Return (url, raw_html) or None on failure."""
    try:
        r = requests.get(url, timeout=TIMEOUT, headers={"User-Agent": UA})
        r.raise_for_status()
        r.encoding = r.apparent_encoding
        return (url, r.text)
    except Exception as e:
        print("[FAIL] %s: %s" % (url, e), file=sys.stderr)
        return None


def extract_main(html):
    """Return (title, body_html) — the article body stripped of nav/header/footer."""
    soup = BeautifulSoup(html, "html.parser")
    title_el = soup.select_one("h1, title")
    title = title_el.get_text(strip=True) if title_el else ""
    # SequoiaDB docs put content in <div class="detail-content"> or article/main
    for sel in [".detail-content", "article", "main", ".content", "#content", "body"]:
        body = soup.select_one(sel)
        if body:
            break
    else:
        body = soup.body or soup
    # Strip nav/header/footer/script/style
    for tag in body.select("nav, header, footer, script, style, .sidebar, .nav, .footer"):
        tag.decompose()
    return title, str(body)


def html_to_md(title, body_html, src_url):
    h = html2text.HTML2Text()
    h.ignore_links = False
    h.ignore_images = False
    h.body_width = 0
    md = h.handle(body_html).strip()
    return "# %s\n\n_Source: %s_\n\n%s\n" % (title, src_url, md)


def discover_urls(html):
    soup = BeautifulSoup(html, "html.parser")
    out = set()
    for a in soup.select("a[href]"):
        href = a.get("href", "")
        if "/cn/sequoiadb-cat_id-" in href and "-edition_id-" in href:
            if href.startswith("/"):
                href = "https://doc.sequoiadb.com" + href
            elif href.startswith("http"):
                pass
            else:
                continue
            out.add(href.split("#", 1)[0])
    return sorted(out)


def main():
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("-o", "--output", default=str(OUT_ROOT), help="output directory")
    ap.add_argument("-u", "--url", default=INDEX_URL, help="index URL to crawl")
    ap.add_argument("-w", "--workers", type=int, default=MAX_WORKERS)
    args = ap.parse_args()

    out_root = Path(args.output)
    out_root.mkdir(parents=True, exist_ok=True)
    print("[init] output: %s" % out_root)
    print("[init] fetching index: %s" % args.url)
    idx = fetch(args.url)
    if idx is None:
        sys.exit(1)
    _, idx_html = idx
    urls = discover_urls(idx_html)
    urls.insert(0, args.url)
    urls = list(dict.fromkeys(urls))
    print("[init] discovered %d unique doc URLs" % len(urls))

    meta = {"index": args.url, "pages": []}
    failures = []

    def worker(url):
        cat = cat_id_from_url(url)
        target_dir = out_root / cat
        target_dir.mkdir(exist_ok=True)
        md_path = target_dir / "index.md"
        if md_path.exists() and md_path.stat().st_size > 100:
            return ("SKIP", url, cat, None, 0)
        result = fetch(url)
        if result is None:
            return ("FAIL", url, cat, None, None)
        _, html = result
        title, body = extract_main(html)
        md = html_to_md(title, body, url)
        (target_dir / "index.html").write_text(html, encoding="utf-8")
        (target_dir / "index.md").write_text(md, encoding="utf-8")
        return ("OK", url, cat, title, len(html))

    t0 = time.time()
    skipped = 0
    with cf.ThreadPoolExecutor(max_workers=args.workers) as ex:
        for status, url, cat, title, size in ex.map(worker, urls):
            if status == "OK":
                meta["pages"].append({"url": url, "cat_id": cat, "title": title, "bytes": size})
                print("[ok]  %s  %s  (%dKB)" % (cat, (title or "")[:60], size // 1024))
            elif status == "SKIP":
                skipped += 1
            else:
                failures.append({"url": url, "cat_id": cat})
                print("[FAIL] %s" % url, file=sys.stderr)

    (out_root / "manifest.json").write_text(json.dumps(meta, ensure_ascii=False, indent=2))
    elapsed = time.time() - t0
    ok = len(meta["pages"])
    print("\n[summary] fetched=%d  skipped=%d  failed=%d  elapsed=%.1fs  workers=%d" %
          (ok, skipped, len(failures), elapsed, args.workers))
    if failures:
        (out_root / "failures.json").write_text(json.dumps(failures, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()