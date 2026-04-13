# AI Chat Session: GSD Tech Stack Migration Planning
- **Date:** 2026-04-13
- **Model:** Opus-4.6
- **Tool:** Claude Code
- **Project:** Dad-a-Base

## Summary
Started GSD new-project workflow to plan a full tech stack migration from off-stack tech (React CRA, Python FastAPI, SQLAlchemy, Nginx) to the Bauss Stack (SvelteKit 5, Drizzle, Tailwind + shadcn-svelte, Caddy, Bun, TypeScript strict).

Session focused on the questioning phase - understanding what Dad-a-Base is and what it needs to do.

## Tech Stack Analysis (Completed)
Compared project's actual tech against the Bauss Stack:

| Layer | Current | Target (Bauss) | Status |
|-------|---------|----------------|--------|
| Frontend | React 18 + CRA | SvelteKit 5 + Tailwind + shadcn-svelte | Deviation |
| Backend | Python FastAPI | SvelteKit API routes (or Hono) | Deviation |
| ORM | SQLAlchemy (Python) | Drizzle (TypeScript) | Deviation |
| Language | Python + JavaScript | TypeScript (strict) | Deviation |
| Runtime | Node (react-scripts) | Bun | Deviation |
| Reverse Proxy | Nginx (Note: prior session swapped to Caddy) | Caddy | May already be done |
| Database | PostgreSQL 16 | PostgreSQL 16 | Compliant |
| Linter | None | Biome 2.0+ | Missing |
| Testing | react-scripts test only | Vitest + Playwright | Incomplete |

**Only PostgreSQL is on-stack.** Full rewrite selected (option A).

## GSD Workflow Progress
1. **Init** - Completed. Brownfield detected (existing code, no codebase map).
2. **Brownfield offer** - User chose "Skip mapping" (we already analyzed the codebase).
3. **Questioning** - IN PROGRESS. Gathered:
   - Dad-a-Base is a community-driven dad joke platform
   - Features: browse, search, submit, vote, categories, favorites
   - Submission moderation: jokes go to "pending" state, need 2-3 community validations before appearing in public list
   - Accounts: TBD (question asked but not yet answered - browse vs interact distinction)

## Questions Still Open
- User accounts: sign up to browse, or only to interact?
- Anonymous voting vs account-tied actions?
- Categories: predefined set or user-created?
- Search: full-text, tag-based, or both?
- "Random joke" feature?
- API: public API for third-party consumption?
- The dad joke tone/theme of the app (keep the puns in the UX?)

## Technical Decisions Made
| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Full rewrite (option A) | Only PostgreSQL is on-stack; incremental migration would leave a split-brain codebase | -- Pending |
| Skip codebase mapping | Already analyzed all project files in conversation | -- Pending |

## Files Created/Modified
- None yet (still in questioning phase, no planning artifacts written)

## Next Steps
1. Resume GSD questioning (Step 3) - finish gathering requirements
2. Write PROJECT.md (Step 4)
3. Configure workflow preferences (Step 5)
4. Research phase (Step 6)
5. Define requirements (Step 7)
6. Create roadmap (Step 8)
7. Start `/gsd:plan-phase 1`

## Exchange Index
- [01 - Tech stack analysis and GSD questioning](./Opus-4.6--01.md)
