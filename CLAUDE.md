# MALLET Strategie & Securite - Website

Professional website for MALLET Strategie & Securite consulting.

## Tech Stack

- **Static site generator:** [Zola](https://www.getzola.org/) — single binary, built-in SASS compilation, no JavaScript required.
- **Build system:** [Nix flakes](https://nixos.wiki/wiki/Flakes) — reproducible builds, all tooling declared in `flake.nix`.
- **CI/CD:** GitHub Actions — push to `master` triggers an automatic Nix build and GitHub Pages deployment.

## Deployment URLs

- **Production:** `https://mstratsec.biz/` (custom domain, already owned by the user)
- **GitHub Pages fallback:** `https://QuentinMallet.github.io/website/` (accessible during DNS propagation or if custom domain is not yet configured)

## Build Commands

```bash
nix build            # build the website (default package = blog)
nix build .#blog     # explicit: build the website
nix build .#cv       # build CV (French, LaTeX → PDF)
nix build .#cv_en    # build CV (English, LaTeX → PDF)
```

Build output is placed in `./result/` (a Nix store symlink).

## Dev Commands

```bash
nix develop          # enter dev shell with zola available
zola serve           # start local dev server at http://127.0.0.1:1111
```

Or combined:

```bash
nix develop -c zola serve
```

## Directory Structure

```
website/
├── config.toml                  # Zola configuration (base_url, title, etc.)
├── content/
│   └── _index.md                # Landing page content (French)
├── templates/
│   ├── base.html                # Base HTML template
│   └── index.html               # Homepage template
├── sass/
│   └── style.scss               # Main stylesheet (graphic chart implementation)
├── static/
│   └── CNAME                    # Custom domain declaration for GitHub Pages
├── cv/                          # LaTeX source for CV packages
├── generation_carte_visite/     # Business card source (graphic chart reference)
│   └── business_card_vec.py     # Single source of truth for brand colors/fonts
├── .github/
│   └── workflows/
│       └── deploy.yml           # GitHub Actions CI/CD workflow
├── flake.nix                    # Nix flake: blog, cv, cv_en packages + devShell
└── CLAUDE.md                    # This file
```

## Graphic Chart

Source of truth: `generation_carte_visite/business_card_vec.py`

### Color Palette

| Role                | Hex       |
|---------------------|-----------|
| Background          | `#1a1a1a` |
| Gold accent         | `#D4A017` |
| Secondary text      | `#A0A0A0` |
| Primary text        | `#F5F5F5` |
| Separator           | `#444444` |

### Font Stacks

- **Headings & body:** `'Helvetica Neue', Helvetica, Arial, sans-serif`
  Helvetica is proprietary and unavailable on Linux; this stack degrades gracefully to Arial on Windows/Linux.
- **Motto ("Dictum Meum Solidus Meus"):** `'TeX Gyre Chorus', 'Apple Chancery', 'URW Chancery L', cursive`

## Custom Domain Setup

The domain `mstratsec.biz` is configured via three components:

1. **`static/CNAME`** — contains `mstratsec.biz` (included in Zola build output, tells GitHub Pages which domain to serve).
2. **`config.toml`** — `base_url = "https://mstratsec.biz/"`.
3. **DNS A records** at the domain registrar (one-time manual setup):
   ```
   A    @    185.199.108.153
   A    @    185.199.109.153
   A    @    185.199.110.153
   A    @    185.199.111.153
   ```
   Optional CNAME for `www`:
   ```
   CNAME    www    QuentinMallet.github.io.
   ```

If the domain or DNS configuration changes, update both `static/CNAME` and `config.toml`'s `base_url`.

GitHub handles TLS certificate provisioning automatically via Let's Encrypt once the DNS records propagate (up to 24-48 hours).

## GitHub Pages Setup (one-time, manual)

1. Go to `https://github.com/QuentinMallet/website/settings/pages`.
2. Under "Build and deployment" > "Source", select **GitHub Actions**.
3. Under "Custom domain", enter `mstratsec.biz` and click Save.
4. Check "Enforce HTTPS" once the certificate is provisioned.

## Git LFS

`*.png`, `picture.jpg`, and `*.pdf` are tracked via Git LFS (see `.gitattributes`). Files at the repo root (`picture.jpg`, `cv.pdf`, `cv_en.pdf`) are LFS pointer stubs — run `git lfs pull` to fetch the actual content.

The GitHub Actions workflow uses `lfs: true` in the checkout step to ensure real files (not pointer stubs) are present during the build.

## Beads (task tracking)

This project uses `br` (beads) for task tracking. To update task status:

```bash
br transition <bead-id> --status done
```

## Language

Site content is in French.
