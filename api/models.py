"""
SQLAlchemy models for the Dad-a-Base.
"These models are table-stakes for dad jokes."
"""
from sqlalchemy import Column, Integer, String, Text, Numeric, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from database import Base


class Category(Base):
    __tablename__ = "categories"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50), unique=True, nullable=False)
    emoji = Column(String(10), default="😄")
    description = Column(Text)

    jokes = relationship("Joke", back_populates="category")


class Joke(Base):
    __tablename__ = "jokes"

    id = Column(Integer, primary_key=True, index=True)
    setup = Column(Text, nullable=False)
    punchline = Column(Text, nullable=False)
    category_id = Column(Integer, ForeignKey("categories.id"))
    groan_factor = Column(Numeric(3, 2), default=3.00)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    category = relationship("Category", back_populates="jokes")
    ratings = relationship("Rating", back_populates="joke", cascade="all, delete-orphan")


class Rating(Base):
    __tablename__ = "ratings"

    id = Column(Integer, primary_key=True, index=True)
    joke_id = Column(Integer, ForeignKey("jokes.id", ondelete="CASCADE"), nullable=False)
    score = Column(Integer, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    joke = relationship("Joke", back_populates="ratings")
