# Dad-a-Base - Session Resume

## 2026-04-13 — GSD Tech Stack Migration (In Progress)

**What happened:**
- Analyzed full tech stack against Bauss Stack — only PostgreSQL is compliant
- Decided on full rewrite (option A) to align with SvelteKit/Drizzle/Tailwind/Bun/TypeScript
- Started GSD `/gsd:new-project` workflow
- Brownfield detected, skipped codebase mapping (already analyzed)
- Entered questioning phase, gathered core requirements:
  - Community-driven dad joke platform
  - Browse, search, submit, vote, categories, favorites
  - Crowd-validated moderation: pending -> 2-3 validations -> public
- GSD init ran successfully, no planning files written yet

**GSD State:** Questioning phase (Step 3), mid-conversation

**Questions still open:**
- User accounts: browse freely vs sign up to interact?
- Anonymous vs account-tied voting?
- Category management: predefined or user-created?
- Search: full-text, tags, or both?
- Random joke feature?
- Public API for third parties?

**Next steps:**
1. Resume `/gsd:new-project` — finish questioning
2. Write PROJECT.md, config, research, requirements, roadmap
3. Start `/gsd:plan-phase 1`

---

## 2026-04-12 — UUID Migration + 124 New Jokes

**What happened:**
- Added 124 new dad jokes across all 15 categories (246 total) via parallel research agents
- Migrated ALL tables from SERIAL integer PKs to UUID primary keys
- Updated full stack: init.sql, models.py, schemas.py, main.py, App.jsx
- Category references in seed data use name subqueries instead of hardcoded IDs
- Updated global `~/.claude/tech-stack.md` with UUID-as-default-PK policy

**Files changed:**
- `db/init.sql` — Full rewrite: UUID PKs, pgcrypto, 246 jokes
- `api/models.py` — UUID columns via `sqlalchemy.dialects.postgresql.UUID`
- `api/schemas.py` — Pydantic `UUID` types
- `api/main.py` — Route/query params now `UUID`
- `web/src/App.jsx` — Removed `parseInt()` for category_id

**Pending:**
- Test with `docker-compose down -v && docker-compose up --build`
- Verify frontend handles UUID strings in all views

---

## 2026-04-09 14:15 — Repo Init + Nginx → Caddy Swap

**What happened:**
- Bootstrapped repository via `/_init_dev_flow` (git init, remotes, .gitignore, CLAUDE.md, TaskMaster, full docs scaffold)
- Swapped Nginx for Caddy across entire stack (reverse proxy container + web container static server)
- 80-line nginx.conf replaced with 19-line Caddyfile
- Dropped rate limiting, renamed NGINX_PORT → CADDY_PORT
- Updated all documentation references

**Files changed:**
- `caddy/Caddyfile` — NEW (reverse proxy config)
- `nginx/nginx.conf` — DELETED
- `docker-compose.yml` — nginx service → caddy service
- `web/Dockerfile` — nginx → caddy for static file serving
- `CLAUDE.md`, `README.md`, `RESUME.md` — Nginx → Caddy
- `docs/` — PRD, INTENT, ui, change-log updated
- `.ai-chats/` — session documentation

**Pending:**
- `.env` needs manual rename: `NGINX_PORT` → `CADDY_PORT`
- Create repo on git.spl.tech and push
- Test `docker-compose up --build` with Caddy

**Status:** Committed locally. Pool push timed out. Origin needs repo created.

---

## 2026-04-09 13:40 — Initial Launch

**What happened:**
- Started Docker Desktop (was not running)
- Created `.env` with default credentials and port config
- Fixed `ajv` module resolution error in `web/package.json` (react-scripts 5.0.1 + Node 20 compatibility)
- Port 80 was occupied by Caddy — switched to port 8888
- All 4 containers running healthy: postgres, api, web, caddy

**Files changed:**
- `.env` — changed CADDY_PORT from 80 to 8888
- `db/init.sql` — additional joke data (100+ jokes) already present from scaffold

**Status:** App running on http://localhost:8888
