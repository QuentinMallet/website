# RALPLAN: Fix CSS Deployment and Populate Site with CV Content

**Date:** 2026-04-06
**Status:** Draft - Awaiting Confirmation
**Complexity:** MEDIUM
**Scope:** 5 tasks across ~6 files

---

## RALPLAN-DR Summary

### Principles

1. **Fix what is broken first** -- CSS must load before content work begins; a styled site is prerequisite for content validation.
2. **Minimal-change DNS strategy** -- Prefer solutions that do not require waiting on DNS propagation (up to 48h) to validate results.
3. **Content fidelity** -- French CV content must be faithfully transposed, not translated or reinterpreted.
4. **Single source of truth** -- Brand assets (logo, colors) come from `generation_carte_visite/`; do not duplicate or diverge.
5. **Incremental deployment** -- Each step should produce a deployable, verifiable state.

### Decision Drivers

1. **Immediate verifiability** -- The user needs to see the site working now, not after DNS propagation.
2. **Custom domain readiness** -- The site must work at `mstratsec.biz` once DNS is pointed correctly, without further code changes.
3. **Content completeness** -- The site should present the owner's professional profile, not a placeholder.

### Viable Options

#### Option A: Dual-mode base_url (Recommended)

Temporarily set `base_url` to the GitHub Pages URL (`https://QuentinMallet.github.io/website/`) so the site works immediately. Document the one-line change needed when DNS is configured for `mstratsec.biz`.

| Pros | Cons |
|------|------|
| Site works immediately after deploy | Requires a config change when DNS is ready |
| No DNS dependency for validation | CNAME file is misleading while using .github.io URL |
| Can verify CSS, logo, content right away | Two-step process (now + later) |

#### Option B: Fix DNS first, keep current base_url

Keep `base_url = "https://mstratsec.biz/"` and configure DNS A records to point to GitHub Pages (185.199.108-111.153). Wait for propagation.

| Pros | Cons |
|------|------|
| No code changes needed for URL | 24-48h wait before site is verifiable |
| Clean single-step solution | Cannot validate CSS fix until DNS propagates |
| Custom domain works immediately once DNS is set | Requires access to domain registrar (out of scope for code plan) |

### Decision

**Option A: Dual-mode base_url.** Rationale: The CSS fix must be verifiable immediately. DNS configuration is a manual registrar step outside the codebase and may take 48h. Option A lets us fix, deploy, verify, and populate content now. The switch to custom domain is a single-line change documented in CLAUDE.md.

### ADR

- **Decision:** Use GitHub Pages URL as base_url temporarily; document custom domain switch.
- **Drivers:** Immediate verifiability, no DNS dependency.
- **Alternatives considered:** Fix DNS first (Option B) -- rejected because it blocks all verification for up to 48h and requires registrar access.
- **Why chosen:** Allows immediate end-to-end validation of CSS, logo, and content.
- **Consequences:** CNAME file should be removed temporarily (or kept for when DNS is configured). Config comment documents the switch.
- **Follow-ups:** When DNS A records are configured, change base_url back to `https://mstratsec.biz/` and restore CNAME.

---

## Root Cause Analysis

### Why CSS is not loading

The site deploys correctly to GitHub Pages at `https://QuentinMallet.github.io/website/`. The Nix build produces a valid `style.css` in the output. However:

1. **`config.toml` sets `base_url = "https://mstratsec.biz/"`**
2. **`base.html` uses `{{ get_url(path='style.css') }}`** which generates an absolute URL: `https://mstratsec.biz/style.css`
3. **The domain `mstratsec.biz` currently points to Squarespace**, not GitHub Pages. Squarespace serves its own "Coming Soon" page.
4. **Result:** The browser loads the HTML from GitHub Pages, but the CSS link points to Squarespace, which returns an HTML page instead of CSS.

Even the `style.css` file is correctly built and present at `https://QuentinMallet.github.io/website/style.css` -- the HTML just does not reference it.

### Secondary issue

The GitHub Pages site is served at subpath `/website/` (repo name). If `base_url` pointed to `https://QuentinMallet.github.io/website/`, Zola would generate correct paths. The current config generates root-relative paths for `mstratsec.biz` which do not match the `/website/` subpath.

---

## Context

- **Repository:** `git@github.com:QuentinMallet/website.git`
- **Tech stack:** Zola + Nix flakes + GitHub Actions + GitHub Pages
- **Current state:** Site builds and deploys. HTML renders unstyled because CSS link points to wrong domain.
- **Logo source:** `/home/urist/website/generation_carte_visite/logo_shield_only.png` (131 bytes, LFS-tracked)
- **CV source:** `/home/urist/website/cv/cv.tex` (French, 217 lines)

---

## Work Objectives

1. Fix CSS loading so the site renders with full styling
2. Add the shield logo to the site
3. Populate site content from French CV (professional experience, certifications, skills)
4. Update CLAUDE.md with ralplan/beads tracking note
5. Verify end-to-end: local build produces styled site with all content

---

## Guardrails

### Must Have
- CSS loads and site renders with dark background (#1a1a1a), gold accents (#D4A017), correct typography
- Logo displays on the page
- French CV content is present and accurate
- Site builds successfully via `nix build .#blog`
- CLAUDE.md updated

### Must NOT Have
- No English content (site is French only per existing convention)
- No JavaScript dependencies
- No third-party CSS frameworks
- No changes to flake.nix build structure
- No modification to CV LaTeX source files

---

## Task Flow

```
[Step 1: Fix base_url] --> [Step 2: Add logo] --> [Step 3: Populate content] --> [Step 4: Update CLAUDE.md] --> [Step 5: Verify]
     |                          |                        |
     v                          v                        v
  config.toml               static/logo.png          content/_index.md
  static/CNAME              templates/index.html     templates/index.html
                             templates/base.html      templates/base.html
                                                      sass/style.scss
```

---

## Detailed TODOs

### Step 1: Fix base_url and CNAME for GitHub Pages

**Files:** `config.toml`, `static/CNAME`

**Actions:**
1. In `config.toml`, change `base_url` from `"https://mstratsec.biz/"` to `"https://QuentinMallet.github.io/website/"`.
2. Add a comment above the base_url line documenting the custom domain switch:
   ```toml
   # When DNS for mstratsec.biz is configured with GitHub Pages A records,
   # change base_url to "https://mstratsec.biz/" and restore static/CNAME.
   base_url = "https://QuentinMallet.github.io/website/"
   ```
3. Either remove `static/CNAME` or comment-out its content. A CNAME file pointing to `mstratsec.biz` while DNS is not configured causes GitHub Pages to attempt serving from the wrong domain. Safest: rename to `static/CNAME.disabled` so it is not lost.

**Acceptance criteria:**
- `nix build .#blog` produces `result/index.html` with `<link rel="stylesheet" href="https://QuentinMallet.github.io/website/style.css">`
- No `CNAME` file in `result/`
- Local `zola serve` renders the styled page

---

### Step 2: Add logo to the site

**Files:** `static/` (new file), `templates/base.html` or `templates/index.html`, `sass/style.scss`

**Actions:**
1. Copy `generation_carte_visite/logo_shield_only.png` to `static/logo_shield_only.png` so Zola includes it in the build output.
2. Add an `<img>` tag in the hero section of `templates/index.html`, above the company name:
   ```html
   <img src="{{ get_url(path='logo_shield_only.png') }}" alt="MALLET Shield" class="hero-logo">
   ```
3. Add `.hero-logo` styles in `sass/style.scss`:
   - Centered, max-width ~80px, margin-bottom to space from company name.
   - Consider a subtle gold-tinted filter or leave as-is depending on the PNG content.

**Acceptance criteria:**
- Logo appears centered above "MALLET" heading
- Logo is present in `result/logo_shield_only.png` after build
- Image loads correctly via `zola serve`

---

### Step 3: Populate content from French CV

**Files:** `content/_index.md`, `templates/index.html`, `templates/base.html`, `sass/style.scss`

**Actions:**
1. Expand `templates/index.html` to include new sections beyond the current business-card layout:
   - **Formation / Certifications** section: ISO27001, PMP, Master CRYPTIS, etc.
   - **Experience professionnelle** section: Key roles (Expert Independant 2025+, RSSI Silae 2022-2025, Majorel 2020-2022, Alten/MAIF 2019-2020, Vientech 2018-2019)
   - **Competences** section: summarized skills (SIEM, audit, ISO27001, programming languages, cloud/containers)
   - **Langues** section: Anglais bilingue, Espagnol lu
   - Keep the existing contact and motto sections at the bottom.
2. Update `content/_index.md` with structured frontmatter or body content that templates can consume (Zola `page.content` or `page.extra` fields).
3. Add corresponding SCSS styles for the new sections:
   - Section headers with gold accent styling
   - Timeline/list styling for experience entries
   - Maintain the dark theme and card-based aesthetic
   - Responsive layout for the additional content (the page will now scroll beyond viewport)
4. Update `templates/base.html` if needed (e.g., add a favicon link for the logo).

**Content extraction from CV (key data):**

| Section | Content from cv.tex |
|---------|-------------------|
| Formation | 2026: Auditeur ISO27001 AFNOR, 2025: Expert Independant, 2025: ISO27001 Auditor, 2022: PMP, 2022: IR(A), 2021: ISO27001 Lead Implementer, 2016-2018: Master CRYPTIS Limoges, 2013-2016: Licence Informatique Poitiers |
| Experience | 2025-Present: Expert Cyber Independant (audit, R&D, admin), 2022-2025: RSSI Silae Group (1M clients, ISO27001 cert), 2020-2022: DRI Majorel (threat hunting, SIEM, incident response), 2019-2020: Analyste MAIF/Alten (SIEM ELK/Splunk, RGPD), 2018-2019: Expert Secu Vientech (SmartGrids, microservices) |
| Langues | Anglais bilingue, Espagnol lu |

**Acceptance criteria:**
- All CV sections visible on the page with proper styling
- French content is accurate (no translation, no reinterpretation)
- Page scrolls smoothly with consistent dark theme
- Responsive: readable on mobile (320px+) and desktop
- Gold accent rules separate sections

---

### Step 4: Update CLAUDE.md

**Files:** `CLAUDE.md`

**Actions:**
1. Add a note in the "Beads" section (or a new section) stating that all ralplan session outputs must be tracked in beads:
   ```markdown
   ## Ralplan Sessions

   All ralplan session outputs (plans, decisions, open questions) are stored in
   `.omc/plans/` and must be tracked as beads for traceability.
   ```
2. Update the "Deployment URLs" section to reflect that the site currently uses the GitHub Pages URL, with a note about the custom domain switch.

**Acceptance criteria:**
- CLAUDE.md contains the ralplan/beads tracking note
- Deployment URL section reflects current state

---

### Step 5: Build verification and local test

**Actions:**
1. Run `nix build .#blog` and verify:
   - `result/index.html` links to correct CSS URL
   - `result/style.css` exists and contains expected styles
   - `result/logo_shield_only.png` exists
   - No `result/CNAME` file (or correct CNAME if DNS is ready)
2. Run `nix develop -c zola serve` and verify in browser:
   - Page loads with dark background, gold accents, correct fonts
   - Logo displays in hero section
   - All CV sections render with content
   - Mobile responsive (resize to 320px)
   - All links work (mailto, tel)
3. Verify no build warnings or errors from Zola.

**Acceptance criteria:**
- Clean build with no warnings
- Visual confirmation: dark theme, gold accents, logo, all content sections
- CSS link resolves correctly (no 404, no Squarespace redirect)
- Mobile layout works

---

## Success Criteria

1. Site at `https://QuentinMallet.github.io/website/` renders with full styling (dark bg, gold accents, typography)
2. Shield logo visible in hero section
3. French CV content (formation, experience, competences, langues) displayed with proper formatting
4. Page is responsive (320px to desktop)
5. `nix build .#blog` succeeds without warnings
6. CLAUDE.md updated with ralplan/beads tracking note

---

## Open Questions

- [ ] Should the `static/CNAME` be deleted or renamed to `.disabled`? -- Deleting is cleaner but loses the reference; renaming preserves intent.
- [ ] How much CV detail to include? Full timeline (all 15+ entries) or curated highlights (last 5 roles)? -- Plan assumes curated highlights for readability; executor can include more if layout permits.
- [ ] Should Centres d'Interets (aviation, martial arts, cello) be included on the professional site? -- CV includes them; may be appropriate for a personal consulting site. Deferred to executor judgment.
- [ ] The logo file is only 131 bytes (likely an LFS pointer, not the real image). Need to verify `git lfs pull` has been run, or the logo may not render. -- Executor must check and pull if needed.
