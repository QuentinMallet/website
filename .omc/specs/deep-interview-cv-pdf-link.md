# Deep Interview Spec: CV PDF Link

## Metadata
- Interview ID: cv-pdf-link-2026-05-29
- Rounds: 5 (3 initial + 2 scope corrections)
- Final Ambiguity Score: ~9%
- Type: brownfield
- Generated: 2026-05-29
- Threshold: 0.20
- Threshold Source: default
- Status: PASSED

## Clarity Breakdown
| Dimension | Score | Weight | Weighted |
|-----------|-------|--------|----------|
| Goal Clarity | 0.95 | 0.35 | 0.333 |
| Constraint Clarity | 0.90 | 0.25 | 0.225 |
| Success Criteria | 0.88 | 0.25 | 0.220 |
| Context Clarity | 0.88 | 0.15 | 0.132 |
| **Total Clarity** | | | **0.910** |
| **Ambiguity** | | | **9%** |

## Topology
| Component | Status | Description | Coverage |
|-----------|--------|-------------|----------|
| CV source migration | active | Copy cv/cv.tex + cv/cv_en.tex from blog repo into website/cv/ | blog repo is deprecated; this repo becomes the home for CV development |
| Flake CV packages | active | Add mk_cv, cv, cv_en, site packages to flake.nix; default → site | Port mk_cv from blog flake (lualatex); site = blog + cv.pdf + cv_en.pdf |
| Website link | active | Language-aware PDF download button in templates/cv.html | data-fr → /cv.pdf, data-en → /cv_en.pdf; btn--primary style |
| CLAUDE.md update | active | Update build docs: add cv/, cv, cv_en, site packages; remove LFS workflow note | Restore what was stale, reflect new structure |
| CI update | active | deploy.yml: nix build .#site; remove lfs: true from checkout | PDFs now built by Nix, not LFS |
| LFS cleanup | active | Remove *.pdf from .gitattributes; PDFs are now Nix build outputs | No PDFs committed to repo |

## Goal
Move CV LaTeX source (cv.tex, cv_en.tex) from the deprecated blog repo into this website repo. Add `cv`, `cv_en`, and `site` flake packages — where `site` assembles the blog output plus both PDFs. Update GitHub Actions to build and deploy `site`. Add a language-aware PDF download button to `templates/cv.html`. Clean up `.gitattributes` and update `CLAUDE.md` to reflect the new structure.

## Constraints
- LaTeX source: use `cv.tex` and `cv_en.tex` from blog repo (not `new_cv.tex` — different template)
- Nix build uses `lualatex` (from blog flake's `mk_cv`) — not `pdflatex` or `xelatex`
- `mk_cv` requires these texlive packages: babel-french, etoolbox, hyperref, koma-script, marginnote, marvosym, ragged2e, scheme-full, tools
- PDFs are no longer committed to the repo — built by Nix on every `nix build .#site`
- Language toggle pattern in templates: two separate elements with `data-fr`/`data-en` attributes (not inline spans for links with different hrefs)
- `default` flake package should become `site` (was `blog`)
- GitHub Actions must upload `./result` which will now be the `site` output

## Non-Goals
- Porting `new_cv.tex` (different template, deprecated)
- Porting `lettre` package from blog repo
- Changing cv.md web page content
- Changing nav or Références section links (they keep pointing to the web CV page)
- Replacing the HTML CV with a PDF-only experience

## Acceptance Criteria
- [ ] `website/cv/cv.tex` and `website/cv/cv_en.tex` exist (copied from blog repo)
- [ ] `nix build .#cv` produces `result/cv.pdf`
- [ ] `nix build .#cv_en` produces `result/cv_en.pdf`
- [ ] `nix build .#site` (and `nix build`) produces a directory containing the full Zola site plus `cv.pdf` and `cv_en.pdf` at the root
- [ ] `templates/cv.html` has a download button: FR active → links to `/cv.pdf`; EN active → links to `/cv_en.pdf`; button uses `btn btn--primary` class
- [ ] `.github/workflows/deploy.yml` builds `site` package and no longer uses `lfs: true`
- [ ] `.gitattributes` no longer tracks `*.pdf` via LFS
- [ ] `CLAUDE.md` build commands table lists `nix build .#cv`, `nix build .#cv_en`, `nix build .#site`; directory structure includes `cv/`
- [ ] `nix build .#blog` still works independently (site wraps it, doesn't replace it)

## Technical Context
- LaTeX source: `/home/urist/Documents/boulot/blog/cv/cv.tex` (FR), `cv_en.tex` (EN)
- Working `mk_cv` derivation: `/home/urist/Documents/boulot/blog/flake.nix` (lines 26-53)
- Website flake currently: `blog` + `default=blog` + `devShell` only
- deploy.yml currently: `nix build .#blog` → upload `./result`
- `site` package implementation:
  ```nix
  site = pkgs.runCommand "site" { } ''
    cp -r ${blog} $out
    chmod -R u+w $out
    cp ${cv}/cv.pdf $out/cv.pdf
    cp ${cv_en}/cv_en.pdf $out/cv_en.pdf
  '';
  ```
- Language toggle in templates/cv.html: two `<a>` elements, one `data-fr` pointing to `/cv.pdf`, one `data-en style="display:none"` pointing to `/cv_en.pdf`

## Interview Transcript (abbreviated)
- R0: Topology confirmed (3 → 6 components after scope corrections)
- R1: Keep web CV + add PDF download button on cv.md page
- R2: PDF in static/ via Git LFS → revised: Nix-built PDFs, blog repo deprecated
- R3: Both FR and EN PDFs
- R4: Site assembly: new `site` package wrapping blog + PDFs
- R5 (correction): Move cv source here, blog repo deprecated
