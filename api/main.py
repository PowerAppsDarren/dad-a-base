"""
Dad-a-Base API - The RESTful Joke Engine
"REST? More like JEST!"

A gloriously over-engineered API for serving dad jokes to the masses.
"""
from uuid import UUID
from fastapi import FastAPI, Depends, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from sqlalchemy import func, or_
from typing import Optional
import random
import math

from database import get_db, engine, Base
from models import Joke, Category, Rating
from schemas import (
    JokeCreate, JokeResponse, CategoryResponse,
    RatingCreate, RatingResponse, PaginatedJokes, GroanOMeter
)

# Create tables (in case they don't exist from init.sql)
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Dad-a-Base API",
    description="""
# Welcome to the Dad-a-Base API! 👴💬

The world's most over-engineered dad joke delivery system.

## Features
- 🎲 Random joke endpoint (for when you need a quick groan)
- 📚 Browse by category (organized chaos)
- 🔍 Full-text search (find the perfect pun)
- ⭐ Rate jokes (1-5 groans)
- 📊 Groan-o-Meter (statistical analysis of dad humor)

## Fun Fact
This API has more endpoints than your dad has stories about walking uphill both ways to school.

*"I told my wife she was drawing her eyebrows too high. She looked surprised."*
    """,
    version="1.0.0",
    contact={
        "name": "Department of Dad Jokes",
        "email": "dad@dadabase.joke",
    },
    license_info={
        "name": "PUNS License (Puns Universally Needed for Society)",
    },
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ---- Helper Functions ----

def joke_to_response(joke: Joke, db: Session) -> JokeResponse:
    """Convert a Joke ORM object to a JokeResponse."""
    ratings = db.query(Rating).filter(Rating.joke_id == joke.id).all()
    avg_rating = sum(r.score for r in ratings) / len(ratings) if ratings else None

    return JokeResponse(
        id=joke.id,
        setup=joke.setup,
        punchline=joke.punchline,
        category_id=joke.category_id,
        category_name=joke.category.name if joke.category else None,
        category_emoji=joke.category.emoji if joke.category else None,
        groan_factor=float(joke.groan_factor) if joke.groan_factor else 3.0,
        avg_rating=round(avg_rating, 2) if avg_rating else None,
        rating_count=len(ratings),
        created_at=joke.created_at,
    )


DAD_LEVELS = [
    (1.0, "Amateur Punster 🌱"),
    (2.0, "Joke Apprentice 📖"),
    (2.5, "Certified Dad 👔"),
    (3.0, "Senior Dad Engineer 🔧"),
    (3.5, "Principal Groaner 😫"),
    (4.0, "Dad Joke Architect 🏗️"),
    (4.5, "Chief Pun Officer 👑"),
    (5.0, "Legendary Dad 🏆"),
]


def get_dad_level(avg: float) -> str:
    for threshold, level in DAD_LEVELS:
        if avg <= threshold:
            return level
    return "Legendary Dad 🏆"


# ---- Health Check ----

@app.get("/health", tags=["System"])
def health_check():
    """Health check endpoint. Because even dad jokes need a checkup."""
    return {"status": "healthy", "message": "The Dad-a-Base is alive and punning!"}


# ---- Joke Endpoints ----

@app.get("/jokes", response_model=PaginatedJokes, tags=["Jokes"])
def list_jokes(
    page: int = Query(1, ge=1, description="Page number"),
    per_page: int = Query(20, ge=1, le=100, description="Jokes per page"),
    category_id: Optional[UUID] = Query(None, description="Filter by category"),
    sort_by: str = Query("newest", description="Sort: newest, oldest, groan_factor, rating"),
    db: Session = Depends(get_db),
):
    """
    Get all jokes with pagination. Like dad's stories, they never end.
    """
    query = db.query(Joke)

    if category_id:
        query = query.filter(Joke.category_id == category_id)

    # Sorting
    if sort_by == "oldest":
        query = query.order_by(Joke.created_at.asc())
    elif sort_by == "groan_factor":
        query = query.order_by(Joke.groan_factor.desc())
    else:
        query = query.order_by(Joke.created_at.desc())

    total = query.count()
    total_pages = math.ceil(total / per_page) if total > 0 else 1
    jokes = query.offset((page - 1) * per_page).limit(per_page).all()

    return PaginatedJokes(
        jokes=[joke_to_response(j, db) for j in jokes],
        total=total,
        page=page,
        per_page=per_page,
        total_pages=total_pages,
    )


@app.get("/jokes/random", response_model=JokeResponse, tags=["Jokes"])
def random_joke(
    category_id: Optional[UUID] = Query(None, description="Get random joke from specific category"),
    db: Session = Depends(get_db),
):
    """
    Get a random dad joke. It's like a box of chocolates,
    but every piece makes you groan.
    """
    query = db.query(Joke)
    if category_id:
        query = query.filter(Joke.category_id == category_id)

    jokes = query.all()
    if not jokes:
        raise HTTPException(status_code=404, detail="No jokes found. This is no laughing matter!")

    joke = random.choice(jokes)
    return joke_to_response(joke, db)


@app.get("/jokes/search", response_model=list[JokeResponse], tags=["Jokes"])
def search_jokes(
    q: str = Query(..., min_length=1, description="Search query"),
    db: Session = Depends(get_db),
):
    """
    Search for jokes. Finding the right pun is a search-and-rescue mission.
    """
    search_term = f"%{q}%"
    jokes = db.query(Joke).filter(
        or_(
            Joke.setup.ilike(search_term),
            Joke.punchline.ilike(search_term),
        )
    ).limit(50).all()

    return [joke_to_response(j, db) for j in jokes]


@app.get("/jokes/{joke_id}", response_model=JokeResponse, tags=["Jokes"])
def get_joke(joke_id: UUID, db: Session = Depends(get_db)):
    """
    Get a specific joke by ID. Because every joke deserves individual attention.
    """
    joke = db.query(Joke).filter(Joke.id == joke_id).first()
    if not joke:
        raise HTTPException(status_code=404, detail=f"Joke #{joke_id} not found. It must have been... pun-ished.")

    return joke_to_response(joke, db)


@app.post("/jokes", response_model=JokeResponse, status_code=201, tags=["Jokes"])
def create_joke(joke_data: JokeCreate, db: Session = Depends(get_db)):
    """
    Add a new dad joke. Contributing to the groan-ter good.
    """
    if joke_data.category_id:
        category = db.query(Category).filter(Category.id == joke_data.category_id).first()
        if not category:
            raise HTTPException(status_code=400, detail="Category not found. That's a categorically bad request!")

    joke = Joke(
        setup=joke_data.setup,
        punchline=joke_data.punchline,
        category_id=joke_data.category_id,
    )
    db.add(joke)
    db.commit()
    db.refresh(joke)

    return joke_to_response(joke, db)


# ---- Category Endpoints ----

@app.get("/categories", response_model=list[CategoryResponse], tags=["Categories"])
def list_categories(db: Session = Depends(get_db)):
    """
    List all joke categories. We've got them all categorically organized.
    """
    categories = db.query(Category).all()
    result = []
    for cat in categories:
        joke_count = db.query(Joke).filter(Joke.category_id == cat.id).count()
        result.append(CategoryResponse(
            id=cat.id,
            name=cat.name,
            emoji=cat.emoji,
            description=cat.description,
            joke_count=joke_count,
        ))
    return result


# ---- Rating Endpoints ----

@app.post("/jokes/{joke_id}/rate", response_model=RatingResponse, status_code=201, tags=["Ratings"])
def rate_joke(joke_id: UUID, rating_data: RatingCreate, db: Session = Depends(get_db)):
    """
    Rate a joke from 1 (polite smile) to 5 (involuntary groan).
    Remember: the worse the joke, the higher the rating!
    """
    joke = db.query(Joke).filter(Joke.id == joke_id).first()
    if not joke:
        raise HTTPException(status_code=404, detail="Can't rate what doesn't exist. Unlike dad jokes, which exist everywhere.")

    rating = Rating(joke_id=joke_id, score=rating_data.score)
    db.add(rating)

    # Update groan factor based on average ratings
    all_ratings = db.query(Rating).filter(Rating.joke_id == joke_id).all()
    if all_ratings:
        avg = sum(r.score for r in all_ratings) / len(all_ratings)
        joke.groan_factor = round(avg, 2)

    db.commit()
    db.refresh(rating)

    return RatingResponse(
        id=rating.id,
        joke_id=rating.joke_id,
        score=rating.score,
        created_at=rating.created_at,
    )


# ---- Groan-o-Meter ----

@app.get("/groan-o-meter", response_model=GroanOMeter, tags=["Statistics"])
def groan_o_meter(db: Session = Depends(get_db)):
    """
    The Groan-o-Meter: Statistical analysis of dad joke quality.
    Because data-driven groaning is the future.
    """
    total_jokes = db.query(Joke).count()
    total_ratings = db.query(Rating).count()

    avg_groan_result = db.query(func.avg(Joke.groan_factor)).scalar()
    avg_groan = float(avg_groan_result) if avg_groan_result else 0.0

    # Highest groan factor joke
    highest_groan = db.query(Joke).order_by(Joke.groan_factor.desc()).first()
    highest_groan_response = joke_to_response(highest_groan, db) if highest_groan else None

    # Most rated joke
    most_rated_subq = (
        db.query(Rating.joke_id, func.count(Rating.id).label("cnt"))
        .group_by(Rating.joke_id)
        .order_by(func.count(Rating.id).desc())
        .first()
    )
    most_rated_response = None
    if most_rated_subq:
        most_rated = db.query(Joke).filter(Joke.id == most_rated_subq[0]).first()
        if most_rated:
            most_rated_response = joke_to_response(most_rated, db)

    return GroanOMeter(
        total_jokes=total_jokes,
        total_ratings=total_ratings,
        average_groan=round(avg_groan, 2),
        highest_groan_joke=highest_groan_response,
        most_rated_joke=most_rated_response,
        dad_level=get_dad_level(avg_groan),
    )


# ---- Root ----

@app.get("/", tags=["System"])
def root():
    """The front door of the Dad-a-Base."""
    return {
        "message": "Welcome to the Dad-a-Base! 👴",
        "tagline": "Where every query returns a groan.",
        "docs": "/docs",
        "version": "1.0.0",
        "endpoints": {
            "random_joke": "/jokes/random",
            "all_jokes": "/jokes",
            "categories": "/categories",
            "search": "/jokes/search?q=your+query",
            "groan_o_meter": "/groan-o-meter",
        },
    }
