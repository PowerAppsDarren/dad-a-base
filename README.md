# Dad-a-Base

### "Hi Hungry, I'm Database!"

> The world's most gloriously over-engineered dad joke delivery system.
> Because if you're going to tell bad jokes, you might as well do it with
> enterprise-grade infrastructure.

---

## Architecture

```
                    The Dad-a-Base Architecture
              (More layers than a dad's winter outfit)

  Browser (You)
      |
      v
  +------------------+
  |   Nginx          |  Port 80
  |   Reverse        |  "The Bouncer"
  |   Pun-roxy       |
  +--------+---------+
           |
     +-----+------+
     |            |
     v            v
+----------+  +----------+
| React    |  | FastAPI  |
| Frontend |  | Backend  |
| "The     |  | "The     |
|  Pun     |  |  Joke    |
|  Palace" |  |  Engine" |
+----------+  +----+-----+
                   |
                   v
            +-----------+
            | PostgreSQL |
            | "The Pun-  |
            |  derlying  |
            |  Data      |
            |  Store"    |
            +-----------+
```

## What's Inside

| Service    | Tech          | Container           | Purpose                          |
|-----------|---------------|---------------------|----------------------------------|
| Database  | PostgreSQL 16 | `dadabase-postgres` | Stores 122 certified dad jokes   |
| Backend   | FastAPI       | `dadabase-api`      | REST API with punny docs         |
| Frontend  | React 18      | `dadabase-web`      | The Pun Palace UI                |
| Proxy     | Nginx 1.25    | `dadabase-nginx`    | Routes traffic, rate limits      |

## Quick Start

**Prerequisites:** Docker and Docker Compose installed.

```bash
# Clone or download the project
cd dad-a-base

# Launch the Dad-a-Base
docker-compose up --build

# That's it. One command. Like all great dad jokes: simple delivery.
```

Open your browser to **http://localhost** and prepare to groan.

## Features

- **Random Joke Button** - Get a random dad joke with a punchline reveal animation
- **Category Browser** - 15 categories with emoji icons (Classic, Food, Science, Tech, Animals, etc.)
- **Full-Text Search** - Find the perfect pun for any occasion
- **Rating System** - Rate jokes from 1 (polite chuckle) to 5 (involuntary groan)
- **Groan-o-Meter** - Real-time statistical analysis of dad joke quality
- **Add Your Own** - Contribute to the groan-ter good
- **Swagger Docs** - Visit `/api/docs` for interactive API docs

## API Endpoints

| Method | Endpoint              | Description                              |
|--------|-----------------------|------------------------------------------|
| GET    | `/api/jokes`          | List jokes (paginated, filterable)       |
| GET    | `/api/jokes/random`   | Random joke (optional category filter)   |
| GET    | `/api/jokes/{id}`     | Get specific joke                        |
| POST   | `/api/jokes`          | Add a new joke                           |
| GET    | `/api/jokes/search`   | Search jokes by text                     |
| GET    | `/api/categories`     | List all categories                      |
| POST   | `/api/jokes/{id}/rate`| Rate a joke (1-5 groans)                 |
| GET    | `/api/groan-o-meter`  | Statistical groan analysis               |

## Database Schema

```
categories          jokes                    ratings
+----------+       +---------------+        +----------+
| id (PK)  |<------| category_id   |        | id (PK)  |
| name     |       | id (PK)       |------->| joke_id  |
| emoji    |       | setup         |        | score    |
| desc     |       | punchline     |        | created  |
+----------+       | groan_factor  |        +----------+
                    | created_at    |
                    +---------------+
```

Comes pre-seeded with **122 quality dad jokes** across 15 categories, plus 130 seed ratings.

## Configuration

Edit `.env` to customize:

```env
POSTGRES_USER=dad_admin
POSTGRES_PASSWORD=imdad_changeme123   # Please change this!
POSTGRES_DB=dadabase
NGINX_PORT=80                         # Change if port 80 is taken
```

## Development

```bash
# Start with hot reload (rebuild on changes)
docker-compose up --build

# View logs
docker-compose logs -f api

# Access the database directly
docker exec -it dadabase-postgres psql -U dad_admin -d dadabase

# Tear it all down
docker-compose down

# Nuclear option (removes data too)
docker-compose down -v
```

## Why So Over-Engineered?

Because "Why did the developer use 4 Docker containers for a joke app?"
**"Because they wanted to make sure the architecture was... containerized
comedy!"**

Also because this is a masterclass in:
- Docker Compose multi-service orchestration
- Service health checks and dependency ordering
- Reverse proxy configuration
- Full-stack Python + React development
- PostgreSQL with proper schema design
- REST API design with FastAPI

## Dad Joke of the README

> **Why did the database administrator leave his wife?**
>
> She had one-to-many relationships.

---

*Built with an unreasonable amount of Docker containers and dad energy.*

*Remember: A good dad joke is like a good database query -- it always returns groan.*
