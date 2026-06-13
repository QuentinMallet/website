# Open Questions

## ralplan-zola-website - 2026-04-05 (Iteration 2)

**Resolved in Iteration 2:**
- [x] ~~What is the base_url for the site?~~ -- Resolved: default to `https://QuentinMallet.github.io/website/` based on git remote `git@github.com:QuentinMallet/website.git`. Config includes comment for custom domain override.
- [x] ~~Font choice: Helvetica is not a web font.~~ -- Resolved: use system font stack `'Helvetica Neue', Helvetica, Arial, sans-serif` for headings/body. Motto uses `'TeX Gyre Chorus', 'Apple Chancery', 'URW Chancery L', cursive`. Web font loading deferred as a follow-up.

**Still open:**
- [ ] Should `picture.jpg` (currently at repo root, LFS-tracked) be used as a profile/hero image on the site? -- Affects template layout and content structure. If yes, the real image must be placed in `static/` (not the LFS pointer from root).
- [ ] Is the site content language exclusively French, or should there be an English variant? -- Zola supports i18n but it needs to be configured upfront.
- [ ] Should the CV PDFs be downloadable from the site (linked in the Zola build output)? -- Would require a post-build step or static file copy in the Nix build.
- [ ] Does the GitHub repo have GitHub Pages enabled, and is it public? -- GitHub Pages free tier requires a public repo (or GitHub Pro for private repos). The repo owner must manually enable Pages with "GitHub Actions" source in settings before the first deploy.
- [ ] Should `nix flake update` be run before building? -- `flake.lock` is from November 2024. Likely fine but may need updating if Zola build issues arise.

## ralplan-css-fix - 2026-04-06

- [ ] Should `static/CNAME` be deleted or renamed to `.disabled`? -- Deleting is cleaner but loses the reference; renaming preserves intent for when DNS is configured.
- [ ] How much CV detail to include on the site? Full timeline (all 15+ entries) or curated highlights (last 5 roles)? -- Affects page length and readability.
- [ ] Should Centres d'Interets (aviation, martial arts, cello) be included on the professional consulting site? -- CV includes them; may be appropriate for personal branding.
- [ ] The logo file `generation_carte_visite/logo_shield_only.png` is only 131 bytes (likely an LFS pointer, not the real image). Need `git lfs pull` before copying to `static/`. -- Executor must verify.
- [ ] When will DNS A records for `mstratsec.biz` be configured to point to GitHub Pages? -- Determines when to switch `base_url` back to `https://mstratsec.biz/`.
