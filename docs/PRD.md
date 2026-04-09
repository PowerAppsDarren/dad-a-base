# Product Requirements Document (PRD)

## Project Name

Dad-a-Base

## Intent Reference

> **VITAL:** See [INTENT.md](./INTENT.md) for the core purpose and boundaries of this project.

## Problem Statement

Dad jokes deserve enterprise-grade infrastructure. Currently, dad jokes are scattered across the internet with no proper database, API, or rating system. Dad-a-Base solves this by providing a full-stack, containerized dad joke delivery platform.

## Goals

- Deliver dad jokes via a polished React UI with category browsing and search
- Provide a RESTful API for programmatic joke access
- Enable community rating of jokes via a 1-5 groan scale
- Demonstrate Docker Compose multi-service orchestration as an educational showcase

## Non-Goals

- User authentication or accounts
- Social features (sharing, comments)
- Mobile native apps
- Joke generation via AI

## User Stories

| As a... | I want to... | So that... |
|---------|-------------|------------|
| Visitor | Get a random dad joke | I can groan unexpectedly |
| Visitor | Browse jokes by category | I can find the right pun for any occasion |
| Visitor | Search jokes by keyword | I can find that one joke I half-remember |
| Visitor | Rate jokes | The best (worst?) jokes rise to the top |
| Visitor | Add my own joke | I can contribute to the groan-ter good |
| Developer | Access jokes via REST API | I can build integrations and bots |

## Technical Requirements

- Docker Compose single-command deployment
- PostgreSQL with proper schema (categories, jokes, ratings)
- FastAPI with Swagger docs
- React SPA with category browsing, search, and rating
- Caddy reverse proxy
- Health checks on all services

## Dependencies

- Docker & Docker Compose
- PostgreSQL 16
- Python 3.x + FastAPI
- React 18 + npm
- Caddy 2

## Success Metrics

| Metric | Target | How Measured |
|--------|--------|-------------|
| Deployment time | < 2 minutes | `docker-compose up --build` cold start |
| Seed jokes | 122+ | Count in init.sql |
| Categories | 15 | Count in init.sql |
| API response time | < 100ms | FastAPI /health endpoint |

## Timeline

| Phase | Description | Target |
|-------|------------|--------|
| 1 | Core infrastructure (DB, API, proxy) | Complete |
| 2 | Frontend UI (browse, search, rate) | Complete |
| 3 | Polish and documentation | In progress |

---

*Created: 2026-04-09*
*Last updated: 2026-04-09*
