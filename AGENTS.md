## Safety rules for Codex

- You may install npm dependencies when needed.
- You may edit files and run tests/builds inside this workspace.
- You may create local git commits only when explicitly asked.
- Never push to remote branches unless explicitly asked in the current conversation.
- Never create, merge, close, or approve pull requests unless explicitly asked in the current conversation.
- Never deploy to production, run release scripts, publish packages, or run Firebase/Supabase/Stripe production-changing commands unless explicitly asked in the current conversation.
- Prefer local/dev/staging environments.

## Workspace

- Work from `/home/dani/sjma/sjma_decidim`.
- The old `/home/dani/sjma/collab_texts` folder was removed after moving this project. Do not use old paths under `collab_texts`.
- This is a Decidim app for Societat Joventut Musical d'Albal, focused on one participatory text process for statutory amendments.

## Local app facts

- Decidim version: `0.29.7`.
- Ruby in `.ruby-version`: `3.2.2`.
- PostgreSQL is configured in `config/database.yml` with default port `5434`.
- Local development database: `sjma_decidim_development`.
- Previous local server port used: `3004`.
- Typical server command: `bin/rails server -b 0.0.0.0 -p 3004`.
- Admin login used locally: `admin@example.org` / `decidim123456789`.

## Current product scope

- Organization: `Societat Joventut Musical d'Albal`.
- Platform language is Catalan only (`ca`).
- Keep the app limited to `Modificació estatutària 2022-2026`.
- Unnecessary Decidim areas have been removed from the public UI: meetings, debates, budgets, accountability/follow-up, blog, surveys, sortitions, dummy pages/entities.
- The only relevant component is proposals as participatory text:
  - process slug: `modificacio-estatutaria-2022-2026`
  - component URL: `/processes/modificacio-estatutaria-2022-2026/f/7/proposals`

## Participatory text behavior

- The imported statutes are structured as `TÍTOL`, `CAPÍTOL`, `Secció`, and `Article`.
- Only `Article ...` entries should be amendable.
- `TÍTOL`, `CAPÍTOL`, and `Secció` are structural headings only. They should appear hierarchically and not have amendment links/buttons.
- Local overrides for this behavior are in:
  - `app/cells/decidim/proposals/participatory_text_proposal/show.erb`
  - `app/cells/decidim/proposals/participatory_text_proposal/buttons.erb`
  - `app/views/decidim/proposals/proposals/participatory_texts/_view_index.html.erb`
  - `config/initializers/sjma_article_amendments_only.rb`
  - `app/packs/stylesheets/decidim/decidim_application.scss`

## Branding/assets

- SJMA assets used by the app are versionable under `app/assets/images/sjma/`.
- The public header logo is in `public/sjma/logo-horizontal-marro.svg`.
- Reapply ActiveStorage branding assets with:
  - `bin/rails runner script/sjma/apply_branding_assets.rb`
- The current brand colors include secondary `#d6ae53`.

## Local ignored documents

- Source/legal working documents are intentionally local and gitignored under `local/source-documents/`.
- Current local files there:
  - `estatutos-working-source.docx`
  - `ESTATUTOS_CHANGELOG.md`

## Important scripts

- `script/sjma/apply_branding_assets.rb`: reapplies committed branding images into Decidim/ActiveStorage.
- `tmp/sjma-import/reimport_estatutos_articles.rb`: previous import script for statutes articles; note that `tmp/` is gitignored.
- `tmp/sjma-import/cleanup_sjma_demo_content.rb`: previous cleanup script for removing demo Decidim content; note that `tmp/` is gitignored.
