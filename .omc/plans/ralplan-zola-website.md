# RALPLAN: Migrate Website from Hugo to Zola with GitHub Actions Deployment

**Date:** 2026-04-05
**Iteration:** 3 (revised per user feedback: custom domain mstratsec.biz)
**Status:** DRAFT - Awaiting confirmation
**Complexity:** MEDIUM
**Mode:** CONSENSUS (SHORT)

**Revision notes (Iteration 3):**
- Step 2: Updated `config.toml` to use `base_url = "https://mstratsec.biz/"` (user already owns this domain). GitHub Pages URL noted as fallback during initial setup.
- Step 4: Added instructions for configuring the custom domain in GitHub Pages settings and DNS CNAME record setup.
- Step 5: Updated CLAUDE.md contents to mention the custom domain and its configuration.
- ADR updated: noted that the custom domain `mstratsec.biz` is already owned by the user.

**Revision notes (Iteration 2):**
- Step 1: Added Nix source filtering (`lib.fileset.toSource` or `lib.cleanSourceWith`) to exclude `.git/`, `cv/`, `generation_carte_visite/`, LFS pointers. Added note about `nix flake update`. Added rationale for changing `packages.default`.
- Step 2: Resolved `base_url` -- set to `https://mstratsec.biz/` (custom domain owned by user).
- Step 3: Resolved font stack -- concrete `font-family` declarations replacing vague "Helvetica" reference. Added TeX Gyre Chorus fallback for motto.
- Step 4: Made Git LFS checkout unconditional (`lfs: true`). Added LFS validation acceptance criterion.
- Step 6: Added note that `nix flake check` works without explicit `checks` attribute. Added GitHub Pages prerequisite note.
- Updated open questions: removed resolved items (#1 base_url, #6 font stack).
- ADR updated with font stack consequence.

---

## RALPLAN-DR Summary

### Principles

1. **Nix-first reproducibility** -- All build tooling lives in `flake.nix`; no implicit system dependencies. Source filtering ensures hermetic builds.
2. **Brand consistency** -- The business card graphic chart (dark theme, gold/silver accents, Helvetica-family typography) is the single source of truth for visual identity.
3. **Minimal viable site** -- Ship a working single-page professional site before adding blog features. Avoid over-engineering.
4. **Separation of concerns** -- LaTeX document builds (CV, cv_en) remain independent packages; the website build is its own package with its own filtered source tree.
5. **Automated deployment** -- Push to `master` triggers build and deploy. No manual steps after merge (beyond one-time GitHub Pages and DNS setup).

### Decision Drivers (Top 3)

1. **Zola is in nixpkgs** -- `pkgs.zola` is available, making the flake migration straightforward (drop Hugo, add Zola).
2. **GitHub Actions is the standard** -- GitHub Pages + Actions is well-documented, free, and avoids committing build artifacts to the repo.
3. **Business card already defines the brand** -- Colors (`#1a1a1a`, `#D4A017`, `#A0A0A0`, `#F5F5F5`), typography hierarchy, and layout structure are already codified in `business_card_vec.py`.
4. **Cross-platform font fidelity** -- Helvetica is proprietary and absent on Linux. The font stack must degrade gracefully via `'Helvetica Neue', Helvetica, Arial, sans-serif` to match the brand on all platforms.

### Viable Options

#### Option A: Zola with custom theme (RECOMMENDED)

Build a minimal custom Zola theme that directly implements the business card graphic chart. No third-party theme dependency.

- **Pros:** Full brand control, no upstream theme breakage, lightweight, easy to maintain.
- **Cons:** More upfront CSS work (~150 lines), no pre-built responsive components.

#### Option B: Zola with existing dark theme + overrides

Use an existing Zola dark theme (e.g., `terminimal`, `tabi`) and override colors/fonts to match the brand.

- **Pros:** Faster initial setup, responsive out of the box.
- **Cons:** Theme upstream changes may break overrides, fighting the theme's opinions, heavier dependency, brand match will be approximate.

**Decision:** Option A. The site is a professional/consulting landing page, not a complex blog. A custom theme of ~150-200 lines of CSS is trivial and gives exact brand fidelity. Option B's maintenance burden (tracking upstream theme changes) outweighs the small time savings.

---

## Context

### Current State

- **Repo:** `/home/urist/website` on branch `master`
- **Git remote:** `git@github.com:QuentinMallet/website.git`
- **`flake.nix`:** Defines a `blog` package using Hugo + pandoc (never actually built -- no Hugo content exists), plus `cv`, `cv_en`, and `lettre` LaTeX packages. `devShells.default` provides only Hugo. `packages.default` currently points to `cv`.
- **`flake.lock`:** Pinned to nixpkgs from November 2024 (`lastModified: 1731890469`). May need updating to get latest `zola` version.
- **No site content:** No `config.toml`, no `content/`, no `themes/` directory. This is a greenfield site build.
- **Business card:** `generation_carte_visite/business_card_vec.py` defines the full graphic chart:
  - Background: `#1a1a1a` (near-black)
  - Gold accent: `#D4A017`
  - Silver/secondary text: `#A0A0A0`
  - Near-white text: `#F5F5F5`
  - Separator gray: `#444444`
  - Typography: Helvetica (bold for headings, normal for body), TeX Gyre Chorus for motto
  - Company: "MALLET -- STRATEGIE & SECURITE"
  - Taglines: "Expert Cybersecurite", "Consultant Informatique"
  - Contact: Quentin Mallet, quentin.mallet@mstratsec.biz, (+33) 6 83 58 00 19
  - Motto (verso): "Dictum Meum Solidus Meus"
- **Custom domain:** User already owns `mstratsec.biz`.
- **Git LFS:** `.gitattributes` tracks `*.png`, `picture.jpg`, `*.pdf`. Files at repo root (`picture.jpg` 130 bytes, `cv.pdf` 131 bytes, `cv_en.pdf` 131 bytes) are LFS pointer stubs, NOT the real files. Real content is in LFS storage.
- **No `lettre/` directory** exists despite `flake.nix` referencing it (dead code).
- **`picture.jpg`** exists at repo root (LFS pointer, likely a photo for the site).

### Target State

- Zola-based static site with the business card brand applied, served at `https://mstratsec.biz/`.
- `flake.nix` updated: Zola replaces Hugo, `blog` package builds the site via `nix build` with a filtered source tree (no `.git/`, `cv/`, `generation_carte_visite/`, or LFS pointer stubs).
- GitHub Actions workflow: push to `master` builds with Nix and deploys to GitHub Pages, with LFS checkout to get real images.
- Custom domain `mstratsec.biz` configured in GitHub Pages settings with proper DNS records.
- `CLAUDE.md` documents project conventions for AI-assisted development.

---

## Work Objectives

1. Update `flake.nix` to use Zola instead of Hugo, with proper source filtering, and clean up dead `lettre` package.
2. Create Zola site structure with custom theme matching the business card graphic chart, using cross-platform font stacks, configured for `mstratsec.biz`.
3. Add GitHub Actions workflow for automated Nix-based build and GitHub Pages deployment with Git LFS support.
4. Add `CLAUDE.md` with project conventions including custom domain documentation.

---

## Guardrails

### Must Have

- Site builds successfully with `nix build .#blog`.
- Blog derivation source tree does NOT include `.git/`, `cv/`, `generation_carte_visite/`, or LFS pointer stubs.
- `zola serve` works from devShell for local development.
- GitHub Actions workflow triggers on push to `master` and deploys to GitHub Pages.
- GitHub Actions checkout uses `lfs: true` unconditionally.
- Color palette matches business card exactly (`#1a1a1a`, `#D4A017`, `#A0A0A0`, `#F5F5F5`).
- Font stack degrades gracefully: `'Helvetica Neue', Helvetica, Arial, sans-serif`.
- CV/cv_en LaTeX packages remain functional and unchanged.
- Site is responsive (mobile-friendly).
- `config.toml` uses `base_url = "https://mstratsec.biz/"`.

### Must NOT Have

- No third-party Zola theme dependency.
- No JavaScript unless strictly necessary (this is a static professional site).
- No changes to existing CV `.tex` files.
- No secrets or API keys committed.
- No removal of Git LFS configuration.

---

## Task Flow

```
[Step 1: flake.nix + source filtering] --> [Step 2: Zola site structure] --> [Step 3: Custom theme + content]
                                                                                     |
                                                                                     v
                                                                       [Step 4: GitHub Actions + custom domain]
                                                                                     |
                                                                                     v
                                                                       [Step 5: CLAUDE.md + cleanup]
                                                                                     |
                                                                                     v
                                                                       [Step 6: Verification]
```

---

## Detailed Steps

### Step 1: Update `flake.nix` with Source Filtering

**Objective:** Replace Hugo with Zola, add source filtering to the `blog` package, remove dead `lettre` package, update devShell.

**Changes to `/home/urist/website/flake.nix`:**

- **Source filtering for `packages.blog`:** Replace `src = ./.;` with a filtered source using `lib.fileset.toSource` (or `lib.cleanSourceWith` as a fallback). The filter must include ONLY Zola-relevant files:
  - `config.toml`
  - `content/` directory
  - `templates/` directory
  - `sass/` directory
  - `static/` directory
  - `themes/` (if used, but not expected for custom theme)

  It must EXCLUDE:
  - `.git/` directory
  - `cv/` directory
  - `generation_carte_visite/` directory
  - `*.pdf` files at root (LFS pointers)
  - `picture.jpg` at root (LFS pointer -- if the image is needed on the site, it should be placed in `static/` and referenced there, NOT from the LFS pointer at root)
  - `flake.nix`, `flake.lock` (not needed in build)
  - `.gitattributes`, `.gitignore`

  Example pattern using `lib.fileset.toSource`:
  ```nix
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./config.toml
      ./content
      ./templates
      ./sass
      ./static
    ];
  };
  ```

- **`packages.blog` build phase:** Replace `hugo` and `pandoc` with `zola` in `nativeBuildInputs`. Set proper build phase:
  ```nix
  buildPhase = ''
    zola build -o $out
  '';
  dontInstall = true;
  ```

- **`devShells.default`:** Replace `hugo` with `zola`.

- **Remove `packages.lettre`:** No `lettre/` directory exists; this is dead code.

- **Change `packages.default` to `blog`:** Currently points to `cv`. Rationale: the primary purpose of this repo is the website. CV packages remain accessible via `nix build .#cv` and `nix build .#cv_en`. Changing default makes `nix build` (without fragment) build the website, which is the most common operation.

- **Keep `packages.cv` and `packages.cv_en`** exactly as they are.

- **Consider running `nix flake update`:** The `flake.lock` is pinned to nixpkgs from November 2024. This is likely fine for Zola, but if the executor encounters build issues, updating the lock file (`nix flake update`) may resolve them. This is not mandatory but should be noted.

**Acceptance Criteria:**
- [ ] `nix develop` drops into a shell with `zola` available.
- [ ] `nix build .#cv` and `nix build .#cv_en` still succeed.
- [ ] `lettre` package is removed from `flake.nix`.
- [ ] `packages.default` points to `blog`.
- [ ] Blog derivation source tree does NOT include `.git/`, `cv/`, `generation_carte_visite/`, or LFS pointer stubs. Verify by inspecting the Nix store path or checking that `nix build .#blog` does not copy those directories.
- [ ] Source filter uses `lib.fileset.toSource` or `lib.cleanSourceWith` (not bare `src = ./.;`).

### Step 2: Create Zola Site Structure

**Objective:** Initialize the Zola directory structure at the repo root, configured for the custom domain `mstratsec.biz`.

**Files to create:**

- **`config.toml`** -- Zola configuration:
  ```toml
  # Custom domain owned by the user. GitHub Pages serves the site at this URL.
  # During initial setup (before DNS propagates), the site is also accessible at
  # https://QuentinMallet.github.io/website/ as a fallback.
  base_url = "https://mstratsec.biz/"
  title = "MALLET - Strategie & Securite"
  description = "Expert Cybersecurite - Consultant Informatique"
  default_language = "fr"
  compile_sass = true
  build_search_index = false
  generate_feeds = false

  [markdown]
  highlight_code = false
  ```

- **`static/CNAME`** -- Required by GitHub Pages for custom domain configuration. This file must contain only the custom domain, no trailing newline or protocol:
  ```
  mstratsec.biz
  ```

- **`content/_index.md`** -- Landing page content with front matter.

- **`templates/base.html`** -- Base HTML template with meta tags, font loading, structure.

- **`templates/index.html`** -- Homepage template extending base.

- **`static/`** -- Directory for static assets. If `picture.jpg` is needed on the site, copy the actual image file (not the LFS pointer) into `static/picture.jpg` and add it to LFS tracking there, or reference it appropriately.

- **`sass/style.scss`** -- Main stylesheet implementing the graphic chart.

**Acceptance Criteria:**
- [ ] `zola build` succeeds from repo root.
- [ ] `zola serve` starts a local dev server.
- [ ] Generated site has valid HTML structure.
- [ ] `config.toml` has `base_url = "https://mstratsec.biz/"` with a comment noting the custom domain and GitHub Pages fallback URL.
- [ ] `static/CNAME` file exists containing `mstratsec.biz`.

### Step 3: Implement Custom Theme with Business Card Graphic Chart

**Objective:** CSS/SASS and templates that faithfully reproduce the business card's visual identity with cross-platform font support.

**Design tokens (from `business_card_vec.py`):**

```scss
// Colors
$bg-primary: #1a1a1a;
$accent-gold: #D4A017;
$text-secondary: #A0A0A0;
$text-primary: #F5F5F5;
$separator: #444444;

// Typography - cross-platform font stacks
// Helvetica is proprietary and unavailable on Linux.
// This stack degrades: Helvetica Neue (macOS) -> Helvetica (macOS/some systems) -> Arial (Windows/Linux) -> system sans-serif.
$font-heading: 'Helvetica Neue', Helvetica, Arial, sans-serif;
$font-body: 'Helvetica Neue', Helvetica, Arial, sans-serif;

// For the motto "Dictum Meum Solidus Meus" which uses TeX Gyre Chorus (calligraphic) on the card.
// TeX Gyre Chorus is not a web font. Use a cursive system font stack as fallback.
// If exact match is needed later, a web font (e.g., Google Fonts "Dancing Script") can be added.
$font-motto: 'TeX Gyre Chorus', 'Apple Chancery', 'URW Chancery L', cursive;
```

**Layout structure:**
- Dark background (`$bg-primary`) full-page
- Gold horizontal rule accents (top/bottom of content area, mirroring the card's gold lines)
- Company name "MALLET" in large near-white bold text, using `$font-heading`
- "STRATEGIE & SECURITE" in gold bold below, using `$font-heading`
- Taglines "Expert Cybersecurite / Consultant Informatique" in silver, using `$font-body`
- Contact section with name, email, phone in the card's typography hierarchy
- Optional: motto "Dictum Meum Solidus Meus" as a footer accent in italic using `$font-motto`

**Content for `content/_index.md`:**
- Hero section: company name, tagline
- About/services section (placeholder text, user can fill in later)
- Contact section with the business card details

**Acceptance Criteria:**
- [ ] Background color is `#1a1a1a`.
- [ ] Gold accents use `#D4A017` exactly.
- [ ] Text colors match the hierarchy: headings in `#F5F5F5`, subheadings in `#D4A017`, body in `#A0A0A0`.
- [ ] Horizontal gold rules appear as decorative elements.
- [ ] `font-family` for headings and body is `'Helvetica Neue', Helvetica, Arial, sans-serif` (not bare `Helvetica`).
- [ ] Motto element uses `$font-motto` stack with cursive fallback.
- [ ] Site is responsive: readable on mobile (min-width 320px) and desktop.
- [ ] No external JavaScript loaded.
- [ ] No web font downloads required for the base experience (all system font stack).

### Step 4: GitHub Actions Workflow with LFS Support and Custom Domain Configuration

**Objective:** Automated build and deploy on push to `master`, with Git LFS checkout for real image/PDF content, and custom domain setup instructions.

**File:** `.github/workflows/deploy.yml`

**Prerequisite (manual, one-time) -- GitHub Pages and custom domain setup:**

1. **Enable GitHub Pages:**
   - Go to `https://github.com/QuentinMallet/website/settings/pages`
   - Under "Build and deployment" > "Source", select "GitHub Actions"

2. **Configure custom domain in GitHub Pages:**
   - On the same Settings > Pages page, under "Custom domain", enter `mstratsec.biz`
   - Check "Enforce HTTPS" (GitHub provisions a TLS certificate automatically via Let's Encrypt)

3. **Configure DNS records** at the domain registrar for `mstratsec.biz`:

   For an **apex domain** (`mstratsec.biz` without `www`), create **A records** pointing to GitHub Pages' IP addresses:
   ```
   A    @    185.199.108.153
   A    @    185.199.109.153
   A    @    185.199.110.153
   A    @    185.199.111.153
   ```

   Optionally, add a **CNAME record** for the `www` subdomain:
   ```
   CNAME    www    QuentinMallet.github.io.
   ```

   Note: DNS propagation may take up to 24-48 hours. During this period, the site remains accessible at `https://QuentinMallet.github.io/website/` if GitHub Pages was previously working with the default URL.

4. **Verify domain (recommended):** In GitHub account settings (not repo settings), go to "Pages" and verify `mstratsec.biz` to prevent others from claiming it on GitHub Pages.

**Workflow design:**
- **Trigger:** `push` to `master` branch.
- **Permissions:** `pages: write`, `id-token: write`, `contents: read` for the Pages deployment method.
- **Concurrency:** `group: "pages"`, `cancel-in-progress: false` to avoid partial deployments.
- **Job:** Single job `build-and-deploy`.
- **Steps:**
  1. **`actions/checkout@v4` with `lfs: true`** -- UNCONDITIONAL. The `.gitattributes` file tracks `*.png`, `picture.jpg`, and `*.pdf` via LFS. Without `lfs: true`, checkout gets 130-byte pointer files instead of actual images/PDFs, breaking any image on the deployed site.
  2. **Install Nix** via `cachix/install-nix-action` (or `DeterminateSystems/nix-installer-action`).
  3. **Run `nix build .#blog`** to produce the site.
  4. **Upload artifact** via `actions/upload-pages-artifact@v3` pointing to `./result/`.
  5. **Deploy** via `actions/deploy-pages@v4`.

Note: The `static/CNAME` file created in Step 2 will be included in the Zola build output automatically. GitHub Pages reads this file to know which custom domain to serve. This means the custom domain configuration persists across deployments without needing to re-set it in the GitHub UI each time.

**Acceptance Criteria:**
- [ ] Workflow file is valid YAML.
- [ ] `actions/checkout@v4` has `lfs: true` set unconditionally (not behind a conditional or comment).
- [ ] Workflow uses Nix to build (not a bare `zola build`), ensuring reproducibility.
- [ ] GitHub Pages deployment uses the modern `actions/deploy-pages` approach (upload-pages-artifact + deploy-pages).
- [ ] Workflow only triggers on `master` branch pushes.
- [ ] Workflow has correct permissions block: `pages: write`, `id-token: write`, `contents: read`.
- [ ] After checkout with LFS, `picture.jpg` would be a valid JPEG (not a 130-byte pointer). Note: this can only be verified in CI, but the workflow config must be correct.
- [ ] `static/CNAME` is included in the Zola source filter (Step 1) so it appears in the built output.

### Step 5: CLAUDE.md and Cleanup

**Objective:** Document project conventions, including custom domain setup, and clean up minor issues.

**File:** `/home/urist/website/CLAUDE.md`

**Contents:**
- Project description: Professional website for MALLET Strategie & Securite consulting.
- Tech stack: Zola (static site generator), Nix flakes (build system), GitHub Actions (CI/CD).
- **Deployment URL:** `https://mstratsec.biz/` (custom domain). GitHub Pages fallback: `https://QuentinMallet.github.io/website/`.
- Build commands: `nix build` (default, builds website), `nix build .#blog` (explicit), `nix build .#cv`, `nix build .#cv_en`.
- Dev commands: `nix develop` then `zola serve`.
- Directory structure overview.
- Graphic chart reference: color palette, font stacks, source file (`generation_carte_visite/business_card_vec.py`).
- Git LFS note: `*.png`, `picture.jpg`, `*.pdf` tracked via LFS. Checkout requires `git lfs pull` for real files.
- Language: site content is in French.
- **Custom domain setup:** `mstratsec.biz` is configured via `static/CNAME` file, GitHub Pages settings (Settings > Pages > Custom domain), and DNS A records pointing to GitHub's IPs (`185.199.108-111.153`). If DNS or domain configuration needs to change, update both `static/CNAME` and `config.toml`'s `base_url`.
- Note: GitHub Pages must be configured to use "GitHub Actions" as the source in repo settings.

**Cleanup:**
- Update `.gitignore` to add `public/` (Zola's default output directory, for local builds).

**Acceptance Criteria:**
- [ ] `CLAUDE.md` exists at repo root with accurate build/dev instructions.
- [ ] `CLAUDE.md` documents the custom domain `mstratsec.biz` and how it is configured.
- [ ] `CLAUDE.md` mentions both the custom domain URL and the GitHub Pages fallback URL.
- [ ] `.gitignore` includes `public/`.

### Step 6: Verification

**Objective:** End-to-end validation that everything works.

**Checks:**
1. `nix flake check` passes without errors. Note: this works even without an explicit `checks` attribute in the flake -- it validates the flake structure, evaluates packages, and checks formatting.
2. `nix build .#blog` produces a `result/` directory with `index.html`.
3. Verify the blog derivation source tree is filtered: inspect `nix build .#blog --print-out-paths` output or check that the Nix store path does NOT contain `.git/`, `cv/`, or `generation_carte_visite/` directories.
4. `nix build .#cv` still works (regression check).
5. `nix develop -c zola serve` starts local server; site renders correctly.
6. Visual spot-check: gold accents, dark background, correct text hierarchy, font stack in computed styles.
7. `.github/workflows/deploy.yml` is syntactically valid YAML.
8. Verify font-family in the generated CSS output contains the full stack (`'Helvetica Neue', Helvetica, Arial, sans-serif`), not bare `Helvetica`.
9. Verify `static/CNAME` contains `mstratsec.biz` and is present in the built output (`result/CNAME`).
10. Verify `config.toml` has `base_url = "https://mstratsec.biz/"`.

**Acceptance Criteria:**
- [ ] All 10 checks pass.
- [ ] No regressions to existing CV build packages.
- [ ] Source filtering is verifiable (no `.git/`, `cv/`, etc. in blog build source).

---

## ADR: Static Site Generator Migration

- **Decision:** Migrate from Hugo to Zola with custom theme, filtered Nix source, cross-platform font stacks, and GitHub Actions deployment with LFS support. Deploy to custom domain `mstratsec.biz` (already owned by the user).
- **Drivers:** Zola available in nixpkgs, simpler configuration (single binary, built-in SASS), no Hugo content exists (zero migration cost), font stack must work on all platforms, user already owns `mstratsec.biz` domain making custom domain deployment straightforward.
- **Alternatives considered:**
  - Hugo (current, but no content built; Zola is simpler for a small site).
  - Zola + third-party theme (rejected: maintenance burden exceeds setup savings for a small custom site).
  - Manual deployment to `docs/` (rejected: requires manual rebuilds, clutters repo with build artifacts).
  - Web font loading for Helvetica alternative (e.g., Inter from Google Fonts) -- deferred. System font stack is lighter and sufficient. Can be revisited if brand fidelity demands exact font matching on Linux.
  - Default GitHub Pages URL (`QuentinMallet.github.io/website/`) instead of custom domain -- rejected. User already owns `mstratsec.biz`, which matches the business identity and email domain (`quentin.mallet@mstratsec.biz`). A custom domain is more professional and consistent with the brand.
- **Why chosen:** Zola is lighter, has native SASS support, and `flake.nix` already follows the pattern needed. GitHub Actions is the modern standard and avoids committing build outputs. Source filtering ensures hermetic, reproducible builds without bloat. System font stack avoids external font dependencies while degrading gracefully. Custom domain `mstratsec.biz` aligns with the existing business identity.
- **Consequences:** Must maintain ~150-200 lines of custom SCSS. No theme update path (but also no theme breakage risk). On Linux, Arial will render instead of Helvetica (acceptable -- both are neutral sans-serif fonts). Motto will use system cursive font instead of TeX Gyre Chorus on most browsers. DNS configuration is a one-time manual step; GitHub handles TLS certificate provisioning automatically.
- **Follow-ups:** Once deployed, the user can add blog content under `content/blog/` with minimal template additions. CV PDFs could later be served from the site by copying build outputs. A web font for exact Helvetica match could be added later if needed. GitHub Pages must be manually enabled in repo settings before the first deploy. DNS records must be configured at the domain registrar before the custom domain is live. Consider adding `www.mstratsec.biz` as an additional domain if needed.

---

## Success Criteria

1. `nix build .#blog` produces a complete static site from a filtered source tree (no `.git/`, `cv/`, etc.).
2. `nix develop -c zola serve` works for local development.
3. Site visually matches the business card graphic chart (colors, typography with fallback stack, layout mood).
4. GitHub Actions workflow is ready for deployment on push to `master`, with `lfs: true` for real image checkout.
5. Existing CV LaTeX builds are unaffected.
6. `CLAUDE.md` accurately documents the project including custom domain configuration.
7. Font stacks degrade gracefully on all platforms (macOS, Windows, Linux).
8. `config.toml` uses `base_url = "https://mstratsec.biz/"` and `static/CNAME` contains `mstratsec.biz`.

---

## Estimated Scope

- **Files created:** ~9 (config.toml, CNAME, 2 templates, 1 scss, 1 content file, 1 workflow, CLAUDE.md)
- **Files modified:** 2 (flake.nix, .gitignore)
- **Files deleted:** 0
- **Estimated complexity:** MEDIUM
