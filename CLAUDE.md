# CLAUDE.md — Dad-a-Base

> The world's most gloriously over-engineered dad joke delivery system.

## Project Overview

Full-stack dad joke app: FastAPI backend, React 18 frontend, PostgreSQL 16, Caddy reverse proxy. All services run via Docker Compose.

**NOTE:** This project uses Python + React, which deviates from the preferred Bauss Stack (SvelteKit + TypeScript). This is intentional — the project was built as a Docker Compose showcase.

## Architecture

```
Browser → Caddy (port 80) → React (frontend) / FastAPI (backend) → PostgreSQL
```

- `api/` — FastAPI backend (Python): `main.py`, `models.py`, `schemas.py`, `database.py`
- `web/` — React 18 frontend: `src/`, `public/`
- `db/` — PostgreSQL init: `init.sql` (122 seed jokes, 15 categories, 130 ratings)
- `caddy/` — Reverse proxy config (Caddyfile)
- `docker-compose.yml` — Full stack orchestration

## Commands

```bash
# Start everything
docker-compose up --build

# View API logs
docker-compose logs -f api

# Access database
docker exec -it dadabase-postgres psql -U dad_admin -d dadabase

# Tear down
docker-compose down

# Tear down + remove data
docker-compose down -v
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/jokes` | List jokes (paginated) |
| GET | `/api/jokes/random` | Random joke |
| GET | `/api/jokes/{id}` | Specific joke |
| POST | `/api/jokes` | Add joke |
| GET | `/api/jokes/search` | Search jokes |
| GET | `/api/categories` | List categories |
| POST | `/api/jokes/{id}/rate` | Rate a joke (1-5) |
| GET | `/api/groan-o-meter` | Statistical analysis |

## Configuration

Environment variables in `.env`:
- `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`
- `DATABASE_URL` — connection string for FastAPI
- `CADDY_PORT` — default 80

## Conventions

- Container names prefixed with `dadabase-`
- PostgreSQL exposed on port 5433 (not 5432) to avoid conflicts
- All services on `dadabase-internal` bridge network
- Health checks on all services
- Caddy handles reverse proxy (replaces Nginx) — matches Bauss Stack
