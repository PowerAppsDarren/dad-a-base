"""
Pydantic schemas for request/response validation.
"Schema? I hardly know 'a!"
"""
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime
from uuid import UUID


class CategoryBase(BaseModel):
    name: str
    emoji: str = "😄"
    description: Optional[str] = None


class CategoryResponse(CategoryBase):
    id: UUID
    joke_count: int = 0

    class Config:
        from_attributes = True


class JokeBase(BaseModel):
    setup: str = Field(..., min_length=1, description="The setup of the joke")
    punchline: str = Field(..., min_length=1, description="The punchline (the good part)")
    category_id: Optional[UUID] = Field(None, description="Category ID")


class JokeCreate(JokeBase):
    pass


class JokeResponse(BaseModel):
    id: UUID
    setup: str
    punchline: str
    category_id: Optional[UUID]
    category_name: Optional[str] = None
    category_emoji: Optional[str] = None
    groan_factor: float
    avg_rating: Optional[float] = None
    rating_count: int = 0
    created_at: datetime

    class Config:
        from_attributes = True


class RatingCreate(BaseModel):
    score: int = Field(..., ge=1, le=5, description="Rating from 1 (polite chuckle) to 5 (involuntary groan)")


class RatingResponse(BaseModel):
    id: UUID
    joke_id: UUID
    score: int
    created_at: datetime

    class Config:
        from_attributes = True


class PaginatedJokes(BaseModel):
    jokes: list[JokeResponse]
    total: int
    page: int
    per_page: int
    total_pages: int


class GroanOMeter(BaseModel):
    total_jokes: int
    total_ratings: int
    average_groan: float
    highest_groan_joke: Optional[JokeResponse] = None
    most_rated_joke: Optional[JokeResponse] = None
    dad_level: str  # Classification based on average
