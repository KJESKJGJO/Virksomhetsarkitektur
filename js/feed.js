(function () {
  'use strict';

  const FEEDS = {
    helse40: 'feed/helse40.json',
    mjossykehuset: 'feed/mjossykehuset.json'
  };

  function currentLang() {
    return document.documentElement.getAttribute('data-lang') === 'en' ? 'en' : 'no';
  }

  function pickText(field, lang) {
    if (!field) return '';
    if (typeof field === 'string') return field;
    return field[lang] || field.no || field.en || '';
  }

  function formatDate(iso, lang) {
    if (!iso) return '';
    const d = new Date(iso);
    if (isNaN(d)) return '';
    try {
      return d.toLocaleDateString(lang === 'en' ? 'en-GB' : 'nb-NO', {
        year: 'numeric', month: 'short', day: 'numeric'
      });
    } catch (e) {
      return d.toISOString().slice(0, 10);
    }
  }

  function renderFeed(container, data) {
    const lang = currentLang();
    const list = container.querySelector('[data-feed-list]');
    const meta = container.querySelector('[data-feed-meta]');
    if (!list) return;

    const items = Array.isArray(data.items) ? data.items.slice(0, 3) : [];

    if (meta && data.updated) {
      const updatedLabel = lang === 'en' ? 'Updated' : 'Oppdatert';
      meta.textContent = updatedLabel + ' ' + formatDate(data.updated, lang);
    }

    if (items.length === 0) {
      const emptyText = lang === 'en'
        ? 'No new signals this week — Health 4.0 remains stable against the national agenda.'
        : 'Ingen nye signaler denne uken — Helse 4.0 ligger stabilt mot nasjonal agenda.';
      list.innerHTML = '<li class="card-feed__empty">' + emptyText + '</li>';
      return;
    }

    list.innerHTML = items.map(function (item) {
      const title = pickText(item.title, lang);
      const summary = pickText(item.summary, lang);
      const source = item.source || '';
      const url = item.url || '#';
      const date = formatDate(item.date, lang);
      const impact = item.impact || '';
      const impactLabels = {
        no: { high: 'Høy', medium: 'Middels', low: 'Lav' },
        en: { high: 'High', medium: 'Medium', low: 'Low' }
      };
      const impactLabel = impactLabels[lang][impact] || '';
      const impactBadge = impactLabel
        ? '<span class="card-feed__impact card-feed__impact--' + impact + '">' + impactLabel + '</span>'
        : '';

      return ''
        + '<li class="card-feed__item">'
        +   '<div class="card-feed__top">'
        +     '<a class="card-feed__title" href="' + url + '" target="_blank" rel="noopener">' + title + '</a>'
        +     impactBadge
        +   '</div>'
        +   '<p class="card-feed__summary">' + summary + '</p>'
        +   '<div class="card-feed__foot">'
        +     '<span class="card-feed__source">' + source + '</span>'
        +     (date ? '<span class="card-feed__date">' + date + '</span>' : '')
        +   '</div>'
        + '</li>';
    }).join('');
  }

  const cache = {};

  function loadAndRender(container) {
    const id = container.getAttribute('data-feed');
    const path = FEEDS[id];
    if (!path) return;

    if (cache[id]) {
      renderFeed(container, cache[id]);
      return;
    }

    fetch(path + '?t=' + Date.now(), { cache: 'no-store' })
      .then(function (res) { return res.ok ? res.json() : null; })
      .then(function (data) {
        if (!data) return;
        cache[id] = data;
        renderFeed(container, data);
      })
      .catch(function () { /* silent */ });
  }

  function initAll() {
    document.querySelectorAll('[data-feed]').forEach(loadAndRender);
  }

  function rerenderAll() {
    document.querySelectorAll('[data-feed]').forEach(function (c) {
      const id = c.getAttribute('data-feed');
      if (cache[id]) renderFeed(c, cache[id]);
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initAll);
  } else {
    initAll();
  }

  // Re-render on language change
  const obs = new MutationObserver(function (muts) {
    for (const m of muts) {
      if (m.attributeName === 'data-lang') { rerenderAll(); break; }
    }
  });
  obs.observe(document.documentElement, { attributes: true, attributeFilter: ['data-lang'] });
})();
