#!/usr/bin/env python3
"""
Generates rss.xml at the site root from feed/*.json files.
Run after updating any feed JSON. Output: /rss.xml served by Vercel.
"""
import json
import html
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent
SITE_URL = "https://skjolas.no"
FEEDS = [
    {
        "path": ROOT / "feed" / "helse40.json",
        "category": {"no": "Helse 4.0", "en": "Health 4.0"},
        "anchor": "#tjenester",
    },
    {
        "path": ROOT / "feed" / "mjossykehuset.json",
        "category": {"no": "Mjøssykehuset", "en": "Mjøssykehuset"},
        "anchor": "#case",
    },
]


def rfc822(date_str: str) -> str:
    """Accept YYYY-MM-DD or ISO 8601, return RFC-822 for RSS."""
    if not date_str:
        return ""
    for fmt in ("%Y-%m-%dT%H:%M:%SZ", "%Y-%m-%dT%H:%M:%S%z", "%Y-%m-%d"):
        try:
            dt = datetime.strptime(date_str, fmt)
            if dt.tzinfo is None:
                dt = dt.replace(tzinfo=timezone.utc)
            return dt.strftime("%a, %d %b %Y %H:%M:%S +0000")
        except ValueError:
            continue
    return ""


def pick(field, lang="no"):
    if isinstance(field, str):
        return field
    if isinstance(field, dict):
        return field.get(lang) or field.get("no") or field.get("en") or ""
    return ""


def build_items():
    items = []
    for f in FEEDS:
        if not f["path"].exists():
            continue
        data = json.loads(f["path"].read_text(encoding="utf-8"))
        category_no = pick(f["category"], "no")
        for it in data.get("items", []):
            title_no = pick(it.get("title"), "no")
            title_en = pick(it.get("title"), "en")
            summary_no = pick(it.get("summary"), "no")
            summary_en = pick(it.get("summary"), "en")
            source = it.get("source", "")
            url = it.get("url", SITE_URL + f["anchor"])
            date = it.get("date", "")
            impact = it.get("impact", "")

            # Full bilingual description
            desc_parts = []
            if summary_no:
                desc_parts.append(f"<p>{html.escape(summary_no)}</p>")
            if summary_en and summary_en != summary_no:
                desc_parts.append(f"<p><em>{html.escape(summary_en)}</em></p>")
            if source:
                desc_parts.append(f"<p><strong>Kilde / Source:</strong> {html.escape(source)}</p>")
            if impact:
                desc_parts.append(f"<p><strong>Impact:</strong> {html.escape(impact)}</p>")
            desc = "".join(desc_parts)

            title = f"[{category_no}] {title_no}"
            if title_en and title_en != title_no:
                title += f" / {title_en}"

            # Unique guid combining url + date so re-runs don't duplicate
            guid = f"{url}#{date}" if date else url

            items.append({
                "title": title,
                "link": url,
                "guid": guid,
                "pub_date": rfc822(date),
                "description": desc,
                "category": category_no,
                "date_key": date or "1970-01-01",
            })
    # Sort newest first
    items.sort(key=lambda x: x["date_key"], reverse=True)
    return items


def render(items):
    now_rfc = datetime.now(timezone.utc).strftime("%a, %d %b %Y %H:%M:%S +0000")
    item_xml = []
    for it in items:
        block = [
            "    <item>",
            f"      <title>{html.escape(it['title'])}</title>",
            f"      <link>{html.escape(it['link'])}</link>",
            f"      <guid isPermaLink=\"false\">{html.escape(it['guid'])}</guid>",
        ]
        if it["pub_date"]:
            block.append(f"      <pubDate>{it['pub_date']}</pubDate>")
        if it["category"]:
            block.append(f"      <category>{html.escape(it['category'])}</category>")
        block.append(f"      <description><![CDATA[{it['description']}]]></description>")
        block.append("    </item>")
        item_xml.append("\n".join(block))
    items_str = "\n".join(item_xml)

    xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="/rss.xsl"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title>Skjølås Enterprise Architecture — Signaler</title>
    <link>{SITE_URL}</link>
    <atom:link href="{SITE_URL}/rss.xml" rel="self" type="application/rss+xml" />
    <description>Ukentlige signaler innen helse-EA, kodeverk, FHIR, digitale tvillinger og Mjøssykehuset. Oppdateres hver mandag morgen.</description>
    <language>no</language>
    <lastBuildDate>{now_rfc}</lastBuildDate>
    <ttl>60</ttl>
{items_str}
  </channel>
</rss>
"""
    return xml


def main():
    items = build_items()
    xml = render(items)
    out = ROOT / "rss.xml"
    out.write_text(xml, encoding="utf-8")
    print(f"Wrote {out} ({len(items)} items)")


if __name__ == "__main__":
    main()
