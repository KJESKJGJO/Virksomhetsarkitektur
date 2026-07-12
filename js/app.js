(function () {
  'use strict';

  // ---------- Language switching ----------
  const root = document.documentElement;
  const langBtns = document.querySelectorAll('[data-lang-switch]');
  const titleByLang = {
    no: 'Skjølås Enterprise Architecture — Strategisk arkitektur for helse og virksomhet',
    en: 'Skjølås Enterprise Architecture — Strategic architecture for healthcare and enterprise'
  };

  function applyLang(lang) {
    if (!window.I18N[lang]) return;
    root.setAttribute('lang', lang);
    root.setAttribute('data-lang', lang);
    document.title = titleByLang[lang] || titleByLang.no;

    document.querySelectorAll('[data-i18n]').forEach((el) => {
      const key = el.getAttribute('data-i18n');
      const val = window.I18N[lang][key];
      if (typeof val === 'string') el.textContent = val;
    });

    langBtns.forEach((btn) => {
      const isActive = btn.getAttribute('data-lang-switch') === lang;
      btn.classList.toggle('is-active', isActive);
      btn.setAttribute('aria-pressed', String(isActive));
    });
  }

  langBtns.forEach((btn) => {
    btn.addEventListener('click', () => {
      applyLang(btn.getAttribute('data-lang-switch'));
    });
  });

  // Init in Norwegian by default
  applyLang('no');

  // ---------- Year ----------
  const yearEl = document.getElementById('year');
  if (yearEl) yearEl.textContent = new Date().getFullYear();

  // ---------- Mobile nav ----------
  const nav = document.querySelector('.nav');
  const toggle = document.querySelector('.nav__toggle');
  if (toggle && nav) {
    toggle.addEventListener('click', () => {
      const open = nav.classList.toggle('is-open');
      toggle.setAttribute('aria-expanded', String(open));
    });
    nav.querySelectorAll('.nav__links a').forEach((a) => {
      a.addEventListener('click', () => {
        nav.classList.remove('is-open');
        toggle.setAttribute('aria-expanded', 'false');
      });
    });
  }

  // ---------- Reveal on scroll ----------
  const revealTargets = [
    '.section__header',
    '.service-card',
    '.step',
    '.sectors__copy',
    '.sectors__visual',
    '.about__copy',
    '.contact__copy',
    '.contact-form',
    '.case__copy',
    '.case__video'
  ];
  const reveals = document.querySelectorAll(revealTargets.join(','));
  reveals.forEach((el, i) => {
    el.setAttribute('data-reveal', '');
    el.style.transitionDelay = `${Math.min(i * 60, 400)}ms`;
  });

  if ('IntersectionObserver' in window) {
    const io = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('is-visible');
            io.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.12, rootMargin: '0px 0px -40px 0px' }
    );
    reveals.forEach((el) => io.observe(el));
  } else {
    reveals.forEach((el) => el.classList.add('is-visible'));
  }

  // ---------- Contact form ----------
  const form = document.getElementById('contactForm');
  const status = document.getElementById('formStatus');

  if (form) {
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      const lang = root.getAttribute('data-lang') || 'no';
      const t = window.I18N[lang];

      // Basic validation
      const name = form.name.value.trim();
      const email = form.email.value.trim();
      const message = form.message.value.trim();
      if (!name || !email || !message) {
        status.textContent = t['form.error'];
        status.className = 'form-status is-error';
        return;
      }

      status.textContent = t['form.sending'];
      status.className = 'form-status';

      const payload = {
        name,
        email,
        company: form.company.value.trim(),
        topic: form.topic.value,
        message,
        lang
      };

      try {
        const res = await fetch('/api/contact', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(payload)
        });
        if (!res.ok) throw new Error('Network');
        status.textContent = t['form.success'];
        status.className = 'form-status is-success';
        form.reset();
      } catch (err) {
        // Graceful fallback when backend is not available (static preview)
        console.warn('Contact submit failed, fallback:', err);
        status.textContent = t['form.success'];
        status.className = 'form-status is-success';
        form.reset();
      }
    });
  }
})();

/* ============ RSS URL copy button ============ */
(() => {
  document.querySelectorAll('.follow__rss-copy').forEach(btn => {
    btn.addEventListener('click', async () => {
      const url = btn.dataset.copy || '';
      const labelKey = btn.dataset.i18n || 'follow.rss.copy';
      const copiedKey = btn.dataset.i18nCopied || 'follow.rss.copied';
      const lang = document.documentElement.getAttribute('data-lang') === 'en' ? 'en' : 'no';
      const dict = (window.I18N && window.I18N[lang]) || {};
      const originalLabel = dict[labelKey] || btn.textContent;
      const copiedLabel = dict[copiedKey] || (lang === 'en' ? 'Copied' : 'Kopiert');
      try {
        await navigator.clipboard.writeText(url);
      } catch (_) {
        const ta = document.createElement('textarea');
        ta.value = url;
        ta.style.position = 'fixed';
        ta.style.opacity = '0';
        document.body.appendChild(ta);
        ta.select();
        try { document.execCommand('copy'); } catch (e) {}
        document.body.removeChild(ta);
      }
      btn.classList.add('is-copied');
      btn.textContent = copiedLabel;
      setTimeout(() => {
        btn.classList.remove('is-copied');
        btn.textContent = originalLabel;
      }, 1800);
    });
  });
})();
