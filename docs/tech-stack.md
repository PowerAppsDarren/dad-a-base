# The Bauss Stack — Concise Reference (v3.1)

> Canonical tech stack for AI-first, self-hosted, solo-developer projects.  
> Updated April 2026. Coolify removed — deployment is now SSH + Docker Compose + Forgejo Actions.

---

## 1. Language & Runtime

### TypeScript (strict mode)
- Statically typed superset of JavaScript — the single language across frontend, backend, and tooling.
- Catches AI-generated hallucinations at compile time; strict mode is non-negotiable.
- Enables end-to-end type sharing across SvelteKit, Drizzle, Better Auth, and Hono.

### Bun 1.1+
- All-in-one JS runtime, bundler, test runner, and package manager.
- Dramatically faster installs and cold starts vs Node; drop-in compatible.
- Runs SvelteKit dev server, Vitest, and build scripts natively.

---

## 2. Frontend

### SvelteKit 5 (Svelte 5 runes)
- Full-stack meta-framework with SSR, API routes, and file-based routing.
- 35% faster rendering and 60–80% smaller bundles than React/Next.js.
- Doubles as the backend via API routes — no separate server needed for most projects.

### Tailwind CSS
- Utility-first CSS framework — no custom CSS files to maintain.
- AI generates Tailwind classes extremely reliably with minimal hallucination.
- Pairs with shadcn-svelte for pre-built, accessible component primitives.

### shadcn-svelte
- Copy-paste UI component library built on Tailwind — lives in your codebase, not node_modules.
- Fully customizable and ownership-friendly; not a traditional dependency.
- Integrates with SvelteKit and Tailwind with zero config friction.

---

## 3. Backend / API

### SvelteKit API routes (default)
- Server-side endpoints co-located with frontend via `+server.ts` files.
- Default backend for 90%+ projects; eliminates a separate API server entirely.
- Shares TypeScript types, auth middleware, and Drizzle queries with the frontend.

### Hono (extraction path)
- Lightweight, ultra-fast TypeScript API framework.
- Used only when the API must serve multiple clients (mobile apps, third-party consumers, microservices).
- Runs standalone or inside SvelteKit; shares Drizzle schemas and Zod validators.

---

## 4. Database & ORM

### PostgreSQL 16
- Battle-tested relational database with native pgvector extension.
- One database handles relational data AND vector/embedding search — no separate vector DB needed.
- Shared by SvelteKit, Directus, Better Auth, and Metabase through connection pooling.

### pgvector
- PostgreSQL extension for vector similarity search (embeddings, RAG, semantic search).
- 11x higher throughput than standalone Qdrant in recent benchmarks.
- Accessed through Drizzle ORM — no separate vector database to operate or maintain.

### Drizzle ORM
- TypeScript-first ORM with native pgvector support and zero runtime overhead.
- Chosen over Prisma for lighter footprint and first-class vector column types.
- Generates migrations, shares schemas across SvelteKit routes, and fully types query results.

---

## 5. Authentication

### Better Auth (app-level)
- App-level auth for end users — TypeScript-first, Lucia Auth's successor (Lucia deprecated March 2025).
- Works natively with Drizzle and PostgreSQL; supports OAuth, magic links, and sessions.
- Handles per-app user auth; delegates infrastructure SSO to Authentik.

### Authentik (infrastructure SSO)
- Self-hosted enterprise SSO/IdP for infrastructure services (Forgejo, Plane, Grafana, etc.).
- Single sign-on across all self-hosted tools via OIDC/SAML/LDAP.
- Runs as a Docker container on the VPS alongside everything else.

---

## 6. AI / LLM

### OpenRouter (primary gateway)
- Unified API gateway to 200+ LLM models from all major providers.
- Eliminates vendor lock-in — switch models with a config change, not a rewrite.
- Called from SvelteKit server routes via Vercel AI SDK; API keys never touch the client.

### Ollama (local inference)
- Runs open-source LLMs locally for embeddings, generation, and private inference.
- Keeps sensitive data on-premises; generates embeddings for pgvector without external API calls.
- Runs on the KVM8 VPS or local dev machine; compatible with OpenAI-format API.

### Vercel AI SDK
- TypeScript SDK for streaming LLM responses with structured output parsing.
- Provider-agnostic — wraps OpenRouter, Ollama, or direct provider calls uniformly.
- Integrates with SvelteKit server routes for streaming chat UIs and tool use.

---

## 7. Deployment & Infrastructure

### Hostinger KVM8 VPS
- 8 vCPU, 32GB RAM, 400GB NVMe running Ubuntu Server 24.04 LTS — ~$25/month.
- Replaces $150–300/month in SaaS subscriptions (GitHub, Auth0, Heroku, etc.).
- All services containerized via Docker; managed through SSH.

### SSH + Docker Compose
- Direct SSH access for deployment — no PaaS abstraction layer needed.
- Docker Compose defines the full infrastructure as code; version-controlled in Forgejo.
- Loosely coupled stacks can be modified, replaced, or scaled independently.

### Caddy (reverse proxy)
- The only reverse proxy — automatic HTTPS with zero-config SSL certificate management.
- Routes traffic to SvelteKit, Forgejo, Plane, and all other services by subdomain.
- Simpler config than Nginx; handles TLS termination and HTTP/2 out of the box.

### Docker + Docker Compose
- Container runtime — every service runs in isolated, reproducible containers.
- `restart: unless-stopped` policies and health checks replace any need for a PaaS restart UI.
- Compose files are the single source of truth for service configuration.

---

## 8. Version Control & CI/CD

### Forgejo
- Self-hosted Git forge with nonprofit governance — no for-profit rug-pull risk.
- Chosen over Gitea (governance risk) and GitLab (4–8GB RAM, overkill for solo dev).
- Integrates with Authentik for SSO; serves as the central code repository.

### Forgejo Actions
- CI/CD pipeline runner — GitHub Actions-compatible workflow syntax.
- Handles build, test, lint, and deploy-via-SSH on push/PR events.
- Replaces Coolify's deploy automation; runs entirely self-hosted alongside the git repos.

---

## 9. Project Management

### Plane
- Open-source project management — issues, sprints, roadmaps, and cycles.
- Modern Linear-like UX; chosen over Jira (bloated) and OpenProject (dated UI).
- Self-hosted via Docker Compose; Authentik SSO; lightweight for solo developer workflows.

---

## 10. Desktop & Mobile

### Tauri 2.x (desktop)
- Rust-based desktop app framework — 90% smaller bundles, 70% less RAM than Electron.
- Wraps the SvelteKit frontend; shares the same codebase and components.
- Used for ~35% of projects that need native desktop features.

### Capacitor 7 (mobile)
- Wraps SvelteKit web apps for iOS and Android with native API access.
- Simpler web-first path than React Native; no different component model to learn.
- Used for ~25% of projects that need App Store / Google Play distribution.

---

## 11. Testing & Quality

### Vitest
- Unit and integration test runner — Vite-native, TypeScript-first.
- Faster than Jest for SvelteKit/Vite projects; compatible API for easy migration.
- Runs via Bun; shares tsconfig and path aliases with the SvelteKit app.

### Playwright
- End-to-end browser testing across Chromium, Firefox, and WebKit.
- Faster and more TypeScript-native than Cypress; better CI integration.
- Tests full SvelteKit flows including auth, API routes, and AI features.

### Biome 2.0+
- Linter and formatter — replaces ESLint + Prettier in a single fast Rust binary.
- Zero-config for TypeScript/Svelte; enforces consistent code style.
- Runs in CI via Forgejo Actions as a quality gate before merge.

---

## 12. Observability & Monitoring

### Grafana + Loki
- Centralized log aggregation and visualization dashboard.
- Lighter than ELK stack; handles container logs from all Docker services.
- Also serves as the frontend for Prometheus metrics and business-level dashboards.

### Prometheus
- Time-series metrics collection with alerting rules.
- Scrapes metrics from SvelteKit, PostgreSQL, Docker, and infrastructure endpoints.
- Feeds into Grafana dashboards for system health and server-side business metrics.

### Uptime Kuma
- Self-hosted uptime monitor with status pages and alert notifications.
- Monitors all public-facing services and APIs; sends alerts on downtime.
- Lightweight single Docker container; complements Prometheus/Grafana for external checks.

### GlitchTip
- Self-hosted error tracking — open-source Sentry alternative.
- Captures frontend and backend exceptions with stack traces and context.
- Integrates with SvelteKit via SDK; stores error data in local PostgreSQL.

---

## 13. Analytics & Reporting (optional)

### Umami
- Privacy-focused, self-hosted web analytics — no cookies, GDPR-compliant.
- Replaces Google Analytics for user-facing page views and event tracking.
- Complemented by server-side event tracking via SvelteKit → Prometheus → Grafana for business metrics.

### Metabase
- Open-source business intelligence — SQL dashboards, charts, and ad-hoc reporting.
- Connects directly to PostgreSQL for data exploration without custom code.
- Chosen over Tableau/Power BI for open-source, self-hosted, zero license cost.

---

## 14. Content Management & Automation (optional)

### Directus
- Database-first headless CMS — wraps existing PostgreSQL tables with an admin UI.
- Doesn't own your schema (unlike Strapi); works alongside Drizzle on the same DB.
- Used when clients or non-developers need a content editing interface.

### n8n
- Self-hosted visual workflow automation — open-source Zapier/Make alternative.
- Builds AI pipelines, webhook handlers, and cross-service integrations visually.
- Runs as a Docker container; connects to PostgreSQL, OpenRouter, email, and external APIs.

---

## 15. Static Sites, CLI & TUI (alternate paths)

### Astro + Tailwind → Cloudflare Pages
- Static site generator for content-heavy, low-interactivity sites (marketing, docs, blogs).
- Deploys to Cloudflare Pages for global CDN edge delivery.
- Used when SvelteKit's full-stack features aren't needed.

### Rust + Clap (performance CLI)
- CLI framework for performance-critical tools and distributable binaries.
- Used for projects like EpsteinVault where speed and binary distribution matter.
- Compile-once, run-anywhere; no runtime dependency.

### Python Typer + Rich (rapid CLI)
- CLI framework for rapid prototyping with beautiful terminal output.
- Gets the best AI code generation quality of any CLI approach.
- Used for developer tooling, scripts, and utilities where speed-to-build matters more than binary size.

### Textual (Python TUI)
- Terminal User Interface framework built on Rich — web-like apps that run entirely in the terminal.
- CSS-like styling system (TCSS) with selectors, layout properties, and theming — no browser needed.
- Widgets include buttons, tables, inputs, dropdowns, trees, and tabs out of the box.
- Used for interactive terminal dashboards, admin tools, and CLI apps that need more than plain text output.

---

## Version Requirements

| Tool         | Minimum |
|--------------|---------|
| Bun          | 1.1+    |
| Node.js      | 22+     |
| Python       | 3.12+   |
| PostgreSQL   | 16+     |
| TypeScript   | 5.5+    |
| Biome        | 2.0+    |
| Textual      | 1.0+    |
| SvelteKit    | 2.0+    |
| Svelte       | 5.0+    |

---

*This document is final. Stop researching. Start building.*
