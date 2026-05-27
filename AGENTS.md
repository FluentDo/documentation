# AGENTS.md

This file defines practical guidance for AI/code agents making changes in this documentation repo.

## Scope

- Repository type: MkDocs Material documentation site.
- Primary audience: maintainers updating product docs and generated docs metadata.

## Product Areas

The `docs/` directory currently contains three product documentation areas. Keep content and terminology aligned with the relevant product scope.

If content could fit two products, place it in the product that owns the operator workflow and link out from the other.

- `docs/agent/` (Telemetry Forge Agent): technical product documentation for installation, platform support, security posture, feature behaviour, and version mapping. Keep instructions runnable and operationally precise. When editing this product, avoid service-tier promises, hosted-platform positioning, or Fleet Manager UI workflow content.
- `docs/fully-managed-logs/` (Fully Managed Logs): customer-facing service documentation focused on managed log aggregation outcomes, hosting models (`hosted by Telemetry Forge` and `hosted on customer infrastructure`), service level agreement (SLA)/support expectations, and deployment responsibilities. When editing this product, avoid low-level agent plugin tuning, release mapping minutiae, or Fleet Manager control-plane procedures.
- `docs/fleet-manager/` (Fleet Manager): customer-facing fleet operations documentation for Fluent Bit agent fleet control, including grouping strategy, configuration rollout workflows, status/version reporting, and practical operational use cases. Hosted access is available at <https://manager.telemetryforge.io>. When editing this product, avoid broad managed-service packaging language and deep standalone agent build/security internals unless directly required for fleet operations.

## Key Files

- `mkdocs.yml`: nav, plugins, markdown extensions, validation rules.
- `overrides/main.html`: shared head overrides (favicon/manifest links) and top-of-site announcement banner.
- `docs/assets/stylesheets/brand.css`: shared documentation presentation styles (for example, product hero card sizing).
- `docs/assets/cards/`: canonical product card SVG artwork used across the site.
- `docs/assets/favicon/`: generated favicon and web app icon assets.
- `docs/agent/getting-started.md`: OS/container onboarding guide.
- `docs/agent/index.md`: Agent landing page and cross-links.
- `scripts/generate-offline.sh`: canonical containerized docs build flow.

## Update Workflow

1. Read `mkdocs.yml` and any target page before editing.
2. Keep changes minimal and scoped to the request.
3. If adding a new page under `docs/`, include it in `nav` unless intentionally excluded.
4. Validate with a containerized build before finishing.

## Product Page Structure

- For each product area, use a lightweight overview landing page at `docs/<product>/index.md`.
- Keep detailed guidance on focused sub-pages and link to them from the landing page.
- Avoid monolithic single-page product docs when the content includes multiple workflows or audiences.

## Validation Commands

Preferred local validation command:

```bash
docker run --rm -t \
  --volume /etc/passwd:/etc/passwd:ro \
  --volume /etc/group:/etc/group:ro \
  --user "$(id -u)":"$(id -g)" \
  -v "$PWD":/docs \
  squidfunk/mkdocs-material build
```

Canonical packaging flow:

```bash
./scripts/local-serve.sh
```

## Fleet Manager Docs Workflow

When updating pages under `docs/fleet-manager/`, use this workflow unless the task explicitly requests otherwise.

- Treat `https://manager.telemetryforge.io` as the default endpoint for user-facing instructions, links, and login screenshots.
- Use the production login experience (for example, GitHub/Google providers), not local dev-mode login.
- Avoid `http://localhost:4444` references in published docs unless a task explicitly asks for local-only instructions.
- If you need local UI validation/screenshot capture, the manager stack can be started from this repository with:

```bash
docker compose -f ../manager/compose.yaml up -d
```

- Reuse a still-running local stack when available; do not restart it unnecessarily.
- For GraphQL `createAgent` examples, use a valid `config` payload (JSON object string) that maps to the getting-started pipeline in `docs/agent/getting-started.md`.

## Navigation Warning Handling

MkDocs omitted-from-nav suppression should use `not_in_nav` in `mkdocs.yml` with .gitignore-style glob patterns (not regex).

Current generated-security ignore patterns are maintained there. Keep those patterns targeted to generated files/directories.

The `docs/agent/security/` tree is generated automatically by tooling. Do not manually edit files in this path.

## Content Conventions

- Keep "Getting Started" instructions simple and runnable.
- Prefer native platform install guidance first; alternatives can follow.
- Keep platform-specific steps separated (tabs are enabled via `pymdownx.tabbed`).
- Use clear relative links between docs pages where possible.
- Use UK English spelling in user-facing documentation (for example: "organisation", "behaviour", "optimisation", "licence" as a noun).
- Define acronyms at first use in each page, followed by the acronym in brackets (for example: "mobile device management (MDM)").
- Exception: `YAML` can be used without first-use expansion.
- If a page includes an acronym glossary, place it near the top of the page as a collapsed MkDocs admonition using `??? info "Acronyms used on this page"`.
- Ensure every Markdown file ends with a trailing newline.
- Do not edit generated `site/` content directly.

## Branding and Visual Consistency

- Reuse existing card artwork from `docs/assets/cards/` for product visuals instead of creating page-specific variants unless explicitly requested.
- Keep visual treatment consistent for product landing pages by using the shared hero image class: `![...](../assets/cards/<card>.svg){ .product-hero-image }`.
- Keep shared visual styles in `docs/assets/stylesheets/brand.css`; avoid introducing page-local inline CSS for reusable patterns.
- Keep favicon assets under `docs/assets/favicon/` and treat them as generated design assets.
- When favicon assets change, update both `theme.favicon` in `mkdocs.yml` and favicon/manifest links in `overrides/main.html` so desktop and mobile browsers stay aligned.

## Change Safety

- Avoid broad reformatting of unrelated docs.
- Preserve existing docs voice and page structure unless the request asks for redesign.
- When warnings remain after a change, report exactly which paths still warn.

