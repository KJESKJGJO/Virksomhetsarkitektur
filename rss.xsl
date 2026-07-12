<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:atom="http://www.w3.org/2005/Atom">
  <xsl:output method="html" encoding="UTF-8" indent="yes"
              doctype-system="about:legacy-compat"/>

  <xsl:template match="/">
    <html lang="no">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><xsl:value-of select="rss/channel/title"/></title>
        <meta name="description"><xsl:attribute name="content"><xsl:value-of select="rss/channel/description"/></xsl:attribute></meta>
        <link rel="preconnect" href="https://fonts.googleapis.com"/>
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
        <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,400;9..144,600;9..144,700&amp;family=Inter:wght@400;500;600&amp;display=swap" rel="stylesheet"/>
        <style>
          :root {
            --bg: #0b0b0c;
            --bg-soft: #131316;
            --panel: #17171b;
            --line: #2a2a31;
            --line-soft: #1f1f25;
            --text: #ececef;
            --muted: #8a8a93;
            --gold: #c9a85a;
            --gold-soft: #a78a47;
            --high: #d97757;
            --medium: #c9a85a;
            --low: #6f9c8e;
          }
          * { box-sizing: border-box; margin: 0; padding: 0; }
          html { background: var(--bg); }
          body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            color: var(--text);
            background: var(--bg);
            line-height: 1.6;
            -webkit-font-smoothing: antialiased;
            min-height: 100vh;
            background-image:
              linear-gradient(to right, rgba(201,168,90,0.025) 1px, transparent 1px),
              linear-gradient(to bottom, rgba(201,168,90,0.025) 1px, transparent 1px);
            background-size: 48px 48px;
          }
          a { color: var(--gold); text-decoration: none; }
          a:hover { color: #e6c477; text-decoration: underline; }
          .wrap { max-width: 880px; margin: 0 auto; padding: 56px 24px 96px; }
          .notice {
            background: var(--panel);
            border: 1px solid var(--line);
            border-left: 3px solid var(--gold);
            padding: 18px 22px;
            margin-bottom: 40px;
            font-size: 14px;
            color: var(--muted);
          }
          .notice strong { color: var(--text); font-weight: 600; }
          .notice code {
            background: var(--bg-soft);
            border: 1px solid var(--line);
            padding: 2px 8px;
            font-family: 'JetBrains Mono', ui-monospace, monospace;
            font-size: 13px;
            color: var(--gold);
            user-select: all;
          }
          .notice .readers {
            margin-top: 10px;
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            font-size: 13px;
          }
          .notice .readers a {
            border: 1px solid var(--line);
            padding: 5px 11px;
            color: var(--text);
          }
          .notice .readers a:hover {
            border-color: var(--gold);
            text-decoration: none;
          }
          header.head {
            border-bottom: 1px solid var(--line);
            padding-bottom: 28px;
            margin-bottom: 40px;
          }
          .eyebrow {
            font-size: 11px;
            letter-spacing: 0.22em;
            text-transform: uppercase;
            color: var(--gold);
            margin-bottom: 14px;
          }
          h1 {
            font-family: 'Fraunces', Georgia, serif;
            font-weight: 600;
            font-size: clamp(32px, 5vw, 44px);
            letter-spacing: -0.015em;
            line-height: 1.1;
            color: var(--text);
            margin-bottom: 14px;
          }
          .lede {
            color: var(--muted);
            max-width: 64ch;
            font-size: 15px;
          }
          .meta {
            margin-top: 18px;
            font-size: 12px;
            color: var(--muted);
            letter-spacing: 0.02em;
          }
          .meta span + span::before { content: " · "; margin: 0 6px; color: var(--line); }
          .item {
            border: 1px solid var(--line);
            background: var(--panel);
            padding: 24px 26px 22px;
            margin-bottom: 18px;
            position: relative;
          }
          .item__cat {
            display: inline-block;
            font-size: 10px;
            letter-spacing: 0.2em;
            text-transform: uppercase;
            color: var(--gold);
            border: 1px solid var(--line);
            padding: 3px 9px;
            margin-bottom: 12px;
          }
          .item__title {
            font-family: 'Fraunces', Georgia, serif;
            font-weight: 600;
            font-size: 20px;
            line-height: 1.3;
            letter-spacing: -0.005em;
            margin-bottom: 12px;
          }
          .item__title a { color: var(--text); }
          .item__title a:hover { color: var(--gold); text-decoration: none; }
          .item__date {
            font-size: 12px;
            color: var(--muted);
            letter-spacing: 0.02em;
            margin-bottom: 14px;
          }
          .item__desc { font-size: 14.5px; color: #c6c6cd; }
          .item__desc p { margin: 0 0 10px; }
          .item__desc p:last-child { margin-bottom: 0; }
          .item__desc em { color: var(--muted); font-style: italic; }
          .item__desc strong { color: var(--text); font-weight: 600; }
          .impact {
            position: absolute;
            top: 24px;
            right: 26px;
            font-size: 10px;
            letter-spacing: 0.2em;
            text-transform: uppercase;
            padding: 4px 10px;
            border: 1px solid var(--line);
            color: var(--muted);
            background: var(--bg-soft);
          }
          .impact[data-impact="high"] { color: var(--high); border-color: var(--high); }
          .impact[data-impact="medium"] { color: var(--medium); border-color: var(--gold-soft); }
          .impact[data-impact="low"] { color: var(--low); border-color: var(--low); }
          footer.foot {
            margin-top: 56px;
            padding-top: 28px;
            border-top: 1px solid var(--line);
            font-size: 13px;
            color: var(--muted);
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
          }
          @media (max-width: 640px) {
            .wrap { padding: 36px 18px 72px; }
            .impact { position: static; display: inline-block; margin-bottom: 12px; }
            .item { padding: 20px 18px; }
          }
        </style>
      </head>
      <body>
        <div class="wrap">

          <div class="notice">
            <strong>Dette er en RSS-feed.</strong> Du ser den nå formatert i nettleseren, men feeden er først og fremst laget for å leses i en RSS-leser som henter nye signaler automatisk. Kopier denne lenken inn i leseren din:
            <div style="margin-top: 10px;"><code>https://skjolas.no/rss.xml</code></div>
            <div class="readers">
              <a href="https://feedly.com/i/subscription/feed/https://skjolas.no/rss.xml" target="_blank" rel="noopener">Abonner i Feedly</a>
              <a href="https://netnewswire.com" target="_blank" rel="noopener">NetNewsWire</a>
              <a href="https://reederapp.com" target="_blank" rel="noopener">Reeder</a>
              <a href="https://skjolas.no/#follow">Tilbake til Følg</a>
            </div>
          </div>

          <header class="head">
            <div class="eyebrow">Live signalfeed</div>
            <h1><xsl:value-of select="rss/channel/title"/></h1>
            <p class="lede"><xsl:value-of select="rss/channel/description"/></p>
            <div class="meta">
              <span>Sist oppdatert: <xsl:value-of select="rss/channel/lastBuildDate"/></span>
              <span><xsl:value-of select="count(rss/channel/item)"/> signaler</span>
            </div>
          </header>

          <xsl:for-each select="rss/channel/item">
            <article class="item">
              <span class="impact">
                <xsl:variable name="raw" select="substring-after(description, 'Impact:&lt;/strong&gt; ')"/>
                <xsl:variable name="impact" select="normalize-space(substring-before(concat($raw, '&lt;'), '&lt;'))"/>
                <xsl:attribute name="data-impact"><xsl:value-of select="$impact"/></xsl:attribute>
                <xsl:choose>
                  <xsl:when test="$impact = 'high'">Høy</xsl:when>
                  <xsl:when test="$impact = 'medium'">Middels</xsl:when>
                  <xsl:when test="$impact = 'low'">Lav</xsl:when>
                  <xsl:otherwise>—</xsl:otherwise>
                </xsl:choose>
              </span>
              <xsl:if test="category">
                <span class="item__cat"><xsl:value-of select="category"/></span>
              </xsl:if>
              <h2 class="item__title">
                <a target="_blank" rel="noopener">
                  <xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute>
                  <xsl:variable name="full" select="title"/>
                  <xsl:variable name="after_bracket">
                    <xsl:choose>
                      <xsl:when test="contains($full, '] ')"><xsl:value-of select="substring-after($full, '] ')"/></xsl:when>
                      <xsl:otherwise><xsl:value-of select="$full"/></xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <xsl:choose>
                    <xsl:when test="contains($after_bracket, ' / ')">
                      <xsl:value-of select="substring-before($after_bracket, ' / ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$after_bracket"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </a>
              </h2>
              <div class="item__date"><xsl:value-of select="pubDate"/></div>
              <div class="item__desc">
                <xsl:value-of select="description" disable-output-escaping="yes"/>
              </div>
            </article>
          </xsl:for-each>

          <footer class="foot">
            <div>Skjølås Enterprise Architecture</div>
            <div><a href="https://skjolas.no">skjolas.no</a> · <a href="https://skjolas.no/#follow">Følg</a></div>
          </footer>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
