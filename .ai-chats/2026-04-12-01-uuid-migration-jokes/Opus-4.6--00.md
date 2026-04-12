# AI Chat Session: UUID Migration + Dad Joke Expansion
- **Date:** 2026-04-09 through 2026-04-12
- **Model:** Opus-4.6
- **Tool:** Claude Code
- **Project:** Dad-a-Base

## Summary

Two major changes to the Dad-a-Base project:

1. **124 new dad jokes** — Spawned 4 parallel research agents to find high-quality dad jokes across all 15 categories. Curated results and added them to `db/init.sql`, bringing total from 122 to 246 jokes.

2. **UUID primary keys everywhere** — Replaced all `SERIAL` integer primary keys with `UUID DEFAULT gen_random_uuid()` across all 3 tables (categories, jokes, ratings). Updated the entire stack: PostgreSQL schema, SQLAlchemy models, Pydantic schemas, FastAPI route params, and React frontend. Category references in seed data changed from hardcoded integer IDs to name-based subqueries.

3. **Tech stack policy update** — Added UUID-as-default-PK rule to `~/.claude/tech-stack.md` in the Database section, establishing it as a global convention.

## Technical Details

### Files Modified
- `db/init.sql` — Full rewrite: UUID PKs, pgcrypto extension, 246 jokes with category subqueries
- `api/models.py` — `Column(Integer, primary_key=True)` → `Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)`
- `api/schemas.py` — All `id: int` → `id: UUID`, all FK refs updated
- `api/main.py` — Route params `joke_id: int` → `UUID`, query params updated
- `web/src/App.jsx` — Removed `parseInt()` for category_id (UUIDs are strings)
- `~/.claude/tech-stack.md` — Added UUID primary key policy in Database section

### Key Decisions
- UUIDs over sequential IDs: prevents ordering leaks, enables cross-system merges, single-purpose identifiers
- Category references by name subquery instead of hardcoded IDs — cleaner and UUID-safe
- `gen_random_uuid()` (pgcrypto) over `uuid_generate_v4()` (uuid-ossp) — built into newer PostgreSQL

## Lessons Learned
- When seeding data with UUID PKs, reference related rows by unique natural keys (like category name) rather than trying to hardcode UUIDs
- Agent research quality varies — curating and deduplicating across 4 agents took deliberate effort

## Next Steps
- `docker-compose down -v && docker-compose up --build` to test full UUID migration
- Verify frontend handles UUID strings correctly in all views
- Consider adding UUID validation middleware

## Exchange Index
- [00 - Summary](./Opus-4.6--00.md) (this file)
