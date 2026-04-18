/* ============================================================
   mstratsec.biz — site script
   Handles: FR/EN toggle, reveal animations, tweaks panel.
   ============================================================ */

(function () {
  /* -------- LANGUAGE TOGGLE -------- */
  const LANG_KEY = 'mstratsec.lang';
  const getLang = () => localStorage.getItem(LANG_KEY) || 'fr';
  const setLang = (lang) => {
    localStorage.setItem(LANG_KEY, lang);
    document.documentElement.setAttribute('lang', lang);
    document.body.setAttribute('data-lang', lang);

    // Toggle [data-fr] / [data-en] blocks
    document.querySelectorAll('[data-fr]').forEach((el) => {
      el.style.display = lang === 'fr' ? '' : 'none';
    });
    document.querySelectorAll('[data-en]').forEach((el) => {
      el.style.display = lang === 'en' ? '' : 'none';
    });

    // Toggle button states
    document.querySelectorAll('.lang-toggle__btn').forEach((btn) => {
      btn.setAttribute('aria-pressed', btn.dataset.lang === lang ? 'true' : 'false');
    });
  };

  document.addEventListener('click', (e) => {
    const btn = e.target.closest('.lang-toggle__btn');
    if (!btn) return;
    setLang(btn.dataset.lang);
  });

  const initReveal = () => {
    setLang(getLang());

    const targets = document.querySelectorAll('[data-reveal], [data-rule]');
    // Fallback: reveal everything after 1500ms in case IO fails silently.
    const revealAll = () => targets.forEach((el) => el.classList.add('is-visible'));
    const fallback = setTimeout(revealAll, 1500);

    if (!('IntersectionObserver' in window)) {
      revealAll();
      return;
    }

    const io = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('is-visible');
            io.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.05, rootMargin: '0px 0px 0px 0px' }
    );
    targets.forEach((el) => {
      io.observe(el);
      // Force-check elements already visible in viewport on load.
      const rect = el.getBoundingClientRect();
      if (rect.top < window.innerHeight && rect.bottom > 0) {
        el.classList.add('is-visible');
        io.unobserve(el);
      }
    });
    // Once we've processed, we can clear the fallback.
    clearTimeout(fallback);
    // But still schedule a safety net.
    setTimeout(revealAll, 2000);
  };

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initReveal);
  } else {
    initReveal();
  }

  /* -------- TWEAKS (Claude edit-mode) -------- */
  let tweaksPanel = null;

  const applyTweak = (key, value) => {
    const root = document.documentElement;
    switch (key) {
      case 'goldHex':
        root.style.setProperty('--brand-gold', value);
        break;
      case 'density':
        root.style.setProperty('--tw-density', value);
        if (value === 'compact') {
          root.style.setProperty('--sp-8', '40px');
          root.style.setProperty('--sp-9', '64px');
        } else if (value === 'spacious') {
          root.style.setProperty('--sp-8', '80px');
          root.style.setProperty('--sp-9', '128px');
        } else {
          root.style.removeProperty('--sp-8');
          root.style.removeProperty('--sp-9');
        }
        break;
      case 'headingStyle':
        if (value === 'serif') {
          document.body.classList.add('tw-serif-headings');
        } else {
          document.body.classList.remove('tw-serif-headings');
        }
        break;
      case 'accent':
        // none / subtle / bold
        root.style.setProperty('--tw-accent', value);
        break;
    }
  };

  const buildPanel = () => {
    const d = window.__TWEAK_DEFAULTS || {};
    const panel = document.createElement('div');
    panel.className = 'tweaks';
    panel.innerHTML = `
      <h4>Tweaks</h4>
      <label>Gold
        <input type="color" data-key="goldHex" value="${d.goldHex || '#D7A216'}" />
      </label>
      <label>Density
        <select data-key="density">
          <option value="default" ${d.density === 'default' ? 'selected' : ''}>Default</option>
          <option value="compact" ${d.density === 'compact' ? 'selected' : ''}>Compact</option>
          <option value="spacious" ${d.density === 'spacious' ? 'selected' : ''}>Spacious</option>
        </select>
      </label>
      <label>Headings
        <select data-key="headingStyle">
          <option value="sans" ${d.headingStyle === 'sans' ? 'selected' : ''}>Sans (Inter)</option>
          <option value="serif" ${d.headingStyle === 'serif' ? 'selected' : ''}>Serif (Cormorant)</option>
        </select>
      </label>
    `;
    document.body.appendChild(panel);
    panel.addEventListener('input', (e) => {
      const el = e.target;
      const key = el.dataset.key;
      if (!key) return;
      applyTweak(key, el.value);
      window.parent.postMessage({ type: '__edit_mode_set_keys', edits: { [key]: el.value } }, '*');
    });
    return panel;
  };

  window.addEventListener('message', (e) => {
    const data = e.data || {};
    if (data.type === '__activate_edit_mode') {
      if (!tweaksPanel) tweaksPanel = buildPanel();
      tweaksPanel.classList.add('is-open');
    } else if (data.type === '__deactivate_edit_mode') {
      if (tweaksPanel) tweaksPanel.classList.remove('is-open');
    }
  });

  // Apply tweak defaults on load
  const initTweaks = () => {
    const d = window.__TWEAK_DEFAULTS || {};
    Object.entries(d).forEach(([k, v]) => applyTweak(k, v));
    window.parent.postMessage({ type: '__edit_mode_available' }, '*');
  };
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initTweaks);
  } else {
    initTweaks();
  }
})();
