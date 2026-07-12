# Skjølås Enterprise Architecture — skjolas.no

Kildekode for [skjolas.no](https://skjolas.no) — Skjølås EA sin nettside. Statisk site (HTML/CSS/JS) med to live nyhetsfeeder og RSS.

## Struktur

```
skjolas-ea/
├── index.html              # Hovedside (NO + EN via data-i18n)
├── rss.xml                 # Autogenerert RSS (build_rss.py)
├── rss.xsl                 # XSL-stilmal — rendrer RSS som lesbar side
├── build_rss.py            # Bygger rss.xml fra feed/*.json
├── vercel.json             # MIME-headers for XML/XSL/JSON
├── css/styles.css          # Mørkt premium design, ingen avrundede hjørner
├── js/
│   ├── i18n.js             # NO + EN oversettelser
│   ├── feed.js             # Laster feed/*.json og rendrer
│   └── app.js              # Nav, språkveksler, RSS-kopier
├── feed/
│   ├── helse40.json        # Helse 4.0-signaler (3 items)
│   └── mjossykehuset.json  # Mjøssykehuset-signaler (3 items)
└── img/                    # Hero, case, service-illustrasjoner
```

## Ukentlig oppdatering

Cron-jobb (Perplexity Computer, ID `4f520ea3`) kjører hver mandag 07:30 CEST og:

1. Skanner offisielle kilder (Helsedirektoratet, NHN, Regjeringen, Sykehuset Innlandet, Helse Sør-Øst, Sykehusbygg, Sykehusinnkjøp, Ringsaker, Doffin)
2. Velger 3 nye signaler per feed med impact-vurdering (high / medium / low)
3. Skriver `feed/helse40.json` og `feed/mjossykehuset.json`
4. Kjører `python build_rss.py` — regenererer `rss.xml`
5. Deployer til Vercel
6. Sender ukentlig e-postsamling til kjell@skjolas.no

## Lokal utvikling

Ingen build-steg — bare rediger og deploy:

```bash
python build_rss.py                              # regenerer rss.xml
npx vercel --prod --token "$VERCEL_TOKEN" --yes  # deploy til skjolas.no
```

## RSS

- Feed: [skjolas.no/rss.xml](https://skjolas.no/rss.xml)
- Åpnes i nettleser → rendres via `rss.xsl` som lesbar side
- Åpnes i RSS-leser → parses som `application/xml`
- Populære lesere: Feedly, NetNewsWire, Reeder, Inoreader

## Kontakt

Kjell Skjølås · [linkedin.com/in/kjellskjolas](https://linkedin.com/in/kjellskjolas/)
