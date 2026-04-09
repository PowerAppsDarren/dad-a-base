# Exchange 01 — Launch Request

## User
> run this app now

## Assistant

Examined the project structure: Docker Compose stack with PostgreSQL, FastAPI, React, and Nginx.

### Actions taken:
1. **Created `.env`** — no env file existed. Used defaults from README (dad_admin/imdad_changeme123/dadabase)
2. **Started Docker Desktop** — wasn't running, launched it and waited ~30s for daemon
3. **First build attempt** — web container failed: `Cannot find module 'ajv/dist/compile/codegen'` (react-scripts 5.0.1 + Node 20 issue). Added `ajv` as direct dependency in `web/package.json` — turned out it was already in the committed version.
4. **Port 80 conflict** — Caddy was serving on port 80. Switched `.env` to `NGINX_PORT=8888`.
5. **Port 50080 failed** — Windows excluded port range. Settled on 8888.
6. **Final launch** — all 4 containers healthy. Verified with `curl http://localhost:8888/api/jokes/random` — returned a joke successfully.

### Result
App running at http://localhost:8888 with all services healthy.
