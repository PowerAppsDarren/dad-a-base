import React, { useState, useEffect, useCallback } from 'react';
import './App.css';

const API = '/api';

// ---- API Helper ----
async function api(path, options = {}) {
  const res = await fetch(`${API}${path}`, {
    headers: { 'Content-Type': 'application/json' },
    ...options,
  });
  if (!res.ok) throw new Error(`API Error: ${res.status}`);
  return res.json();
}

// ---- Joke Card Component ----
function JokeCard({ joke, onRate }) {
  const [revealed, setRevealed] = useState(false);
  const [hoverRating, setHoverRating] = useState(0);
  const [rated, setRated] = useState(false);

  const handleRate = async (score) => {
    if (rated) return;
    try {
      await api(`/jokes/${joke.id}/rate`, {
        method: 'POST',
        body: JSON.stringify({ score }),
      });
      setRated(true);
      if (onRate) onRate();
    } catch (e) {
      console.error('Rating failed:', e);
    }
  };

  const groans = ['😐', '🙂', '😄', '😫', '🤣'];

  return (
    <div className="joke-card">
      {joke.category_name && (
        <span className="category-badge">
          {joke.category_emoji} {joke.category_name}
        </span>
      )}
      <div className="setup">{joke.setup}</div>
      <div
        className={`punchline ${revealed ? '' : 'hidden'}`}
        onClick={() => setRevealed(true)}
      >
        {joke.punchline}
      </div>
      {!revealed && (
        <button className="reveal-btn" onClick={() => setRevealed(true)}>
          Reveal Punchline 🥁
        </button>
      )}
      <div className="rating-container">
        <span className="label">Rate this groan:</span>
        {groans.map((emoji, i) => (
          <button
            key={i}
            className={`groan-btn ${(hoverRating || 0) >= i + 1 || rated ? 'active' : ''}`}
            onMouseEnter={() => !rated && setHoverRating(i + 1)}
            onMouseLeave={() => !rated && setHoverRating(0)}
            onClick={() => handleRate(i + 1)}
            disabled={rated}
            title={`${i + 1} groan${i > 0 ? 's' : ''}`}
          >
            {emoji}
          </button>
        ))}
        <span className="rating-info">
          {rated ? 'Rated!' : ''}
          {joke.avg_rating ? ` Avg: ${joke.avg_rating.toFixed(1)}/5` : ''}
          {joke.rating_count > 0 ? ` (${joke.rating_count})` : ''}
        </span>
      </div>
    </div>
  );
}

// ---- Main App ----
function App() {
  const [view, setView] = useState('random');
  const [joke, setJoke] = useState(null);
  const [jokes, setJokes] = useState([]);
  const [categories, setCategories] = useState([]);
  const [groanData, setGroanData] = useState(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState([]);
  const [selectedCategory, setSelectedCategory] = useState(null);
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [loading, setLoading] = useState(false);
  const [newJoke, setNewJoke] = useState({ setup: '', punchline: '', category_id: '' });

  // Fetch random joke
  const fetchRandomJoke = useCallback(async () => {
    setLoading(true);
    try {
      const data = await api('/jokes/random');
      setJoke(data);
    } catch (e) {
      console.error(e);
    }
    setLoading(false);
  }, []);

  // Fetch categories
  const fetchCategories = useCallback(async () => {
    try {
      const data = await api('/categories');
      setCategories(data);
    } catch (e) {
      console.error(e);
    }
  }, []);

  // Fetch jokes by category
  const fetchJokes = useCallback(async (catId = null, p = 1) => {
    setLoading(true);
    try {
      let url = `/jokes?page=${p}&per_page=10`;
      if (catId) url += `&category_id=${catId}`;
      const data = await api(url);
      setJokes(data.jokes);
      setTotalPages(data.total_pages);
      setPage(data.page);
    } catch (e) {
      console.error(e);
    }
    setLoading(false);
  }, []);

  // Fetch groan-o-meter
  const fetchGroan = useCallback(async () => {
    try {
      const data = await api('/groan-o-meter');
      setGroanData(data);
    } catch (e) {
      console.error(e);
    }
  }, []);

  // Search
  const handleSearch = useCallback(async (q) => {
    if (!q.trim()) { setSearchResults([]); return; }
    setLoading(true);
    try {
      const data = await api(`/jokes/search?q=${encodeURIComponent(q)}`);
      setSearchResults(data);
    } catch (e) {
      console.error(e);
    }
    setLoading(false);
  }, []);

  // Submit new joke
  const handleSubmitJoke = async (e) => {
    e.preventDefault();
    try {
      await api('/jokes', {
        method: 'POST',
        body: JSON.stringify({
          setup: newJoke.setup,
          punchline: newJoke.punchline,
          category_id: newJoke.category_id || null,
        }),
      });
      setNewJoke({ setup: '', punchline: '', category_id: '' });
      alert('Joke added! You are now officially a dad joke contributor. 🎉');
    } catch (e) {
      alert('Failed to add joke. Even the API is groaning.');
    }
  };

  useEffect(() => {
    fetchCategories();
  }, [fetchCategories]);

  useEffect(() => {
    if (view === 'random') fetchRandomJoke();
    if (view === 'groan') fetchGroan();
    if (view === 'browse') fetchJokes(selectedCategory, 1);
  }, [view, fetchRandomJoke, fetchGroan, fetchJokes, selectedCategory]);

  return (
    <div className="app">
      {/* Header */}
      <header className="header">
        <h1>Dad-a-Base</h1>
        <p className="subtitle">"Hi Hungry, I'm Database!" — A Full-Stack Dad Joke Engine</p>
      </header>

      {/* Navigation */}
      <nav className="nav">
        <button className={view === 'random' ? 'active' : ''} onClick={() => setView('random')}>
          🎲 Random Joke
        </button>
        <button className={view === 'browse' ? 'active' : ''} onClick={() => { setView('browse'); setSelectedCategory(null); }}>
          📚 Browse
        </button>
        <button className={view === 'search' ? 'active' : ''} onClick={() => setView('search')}>
          🔍 Search
        </button>
        <button className={view === 'groan' ? 'active' : ''} onClick={() => setView('groan')}>
          📊 Groan-o-Meter
        </button>
        <button className={view === 'add' ? 'active' : ''} onClick={() => setView('add')}>
          ➕ Add Joke
        </button>
      </nav>

      {/* Main Content */}
      <main className="main">

        {/* Random Joke View */}
        {view === 'random' && (
          <div className="random-section">
            <button className="random-btn" onClick={fetchRandomJoke}>
              Tell Me a Dad Joke! 🎤
            </button>
            {loading && <div className="loading">Summoning dad energy</div>}
            {joke && !loading && (
              <div style={{ marginTop: '2rem' }}>
                <JokeCard joke={joke} key={joke.id} onRate={fetchGroan} />
              </div>
            )}
          </div>
        )}

        {/* Browse View */}
        {view === 'browse' && (
          <div>
            {!selectedCategory ? (
              <>
                <h2 style={{ fontFamily: 'var(--font-heading)', color: 'var(--dad-brown)', marginBottom: '1rem', textAlign: 'center' }}>
                  Pick a Category 📂
                </h2>
                <div className="categories-grid">
                  {categories.map(cat => (
                    <div
                      key={cat.id}
                      className="category-card"
                      onClick={() => { setSelectedCategory(cat.id); fetchJokes(cat.id, 1); }}
                    >
                      <span className="emoji">{cat.emoji}</span>
                      <div className="name">{cat.name}</div>
                      <div className="count">{cat.joke_count} jokes</div>
                    </div>
                  ))}
                </div>
              </>
            ) : (
              <>
                <button
                  className="reveal-btn"
                  onClick={() => setSelectedCategory(null)}
                  style={{ marginBottom: '1rem' }}
                >
                  ← Back to Categories
                </button>
                {loading && <div className="loading">Loading jokes</div>}
                {!loading && jokes.length === 0 && (
                  <div className="empty-state">
                    <span className="emoji">🦗</span>
                    No jokes here yet. Crickets!
                  </div>
                )}
                {jokes.map(j => (
                  <JokeCard key={j.id} joke={j} onRate={fetchGroan} />
                ))}
                {totalPages > 1 && (
                  <div className="pagination">
                    <button
                      disabled={page <= 1}
                      onClick={() => fetchJokes(selectedCategory, page - 1)}
                    >
                      ← Previous
                    </button>
                    <span>Page {page} of {totalPages}</span>
                    <button
                      disabled={page >= totalPages}
                      onClick={() => fetchJokes(selectedCategory, page + 1)}
                    >
                      Next →
                    </button>
                  </div>
                )}
              </>
            )}
          </div>
        )}

        {/* Search View */}
        {view === 'search' && (
          <div>
            <div className="search-container">
              <input
                className="search-input"
                type="text"
                placeholder='Search for jokes... try "chicken" or "computer"'
                value={searchQuery}
                onChange={(e) => {
                  setSearchQuery(e.target.value);
                  handleSearch(e.target.value);
                }}
              />
            </div>
            {loading && <div className="loading">Searching the Dad-a-Base</div>}
            {!loading && searchQuery && searchResults.length === 0 && (
              <div className="empty-state">
                <span className="emoji">🤷‍♂️</span>
                No jokes found. That's no laughing matter!
              </div>
            )}
            {searchResults.map(j => (
              <JokeCard key={j.id} joke={j} onRate={fetchGroan} />
            ))}
          </div>
        )}

        {/* Groan-o-Meter View */}
        {view === 'groan' && groanData && (
          <div className="groan-meter">
            <h2>The Groan-o-Meter 📊</h2>
            <p style={{ color: '#666', marginBottom: '1rem' }}>
              Measuring dad joke quality since... well, just now.
            </p>

            <div className="meter-bar">
              <div
                className="meter-fill"
                style={{ width: `${(groanData.average_groan / 5) * 100}%` }}
              >
                {groanData.average_groan.toFixed(1)}/5.0
              </div>
            </div>

            <div className="stats-grid">
              <div className="stat-card">
                <div className="value">{groanData.total_jokes}</div>
                <div className="label">Total Jokes</div>
              </div>
              <div className="stat-card">
                <div className="value">{groanData.total_ratings}</div>
                <div className="label">Total Ratings</div>
              </div>
              <div className="stat-card">
                <div className="value">{groanData.average_groan.toFixed(2)}</div>
                <div className="label">Avg Groan Factor</div>
              </div>
            </div>

            <div className="dad-level">
              Dad Level: {groanData.dad_level}
            </div>

            {groanData.highest_groan_joke && (
              <div style={{ marginTop: '2rem', textAlign: 'left' }}>
                <h3 style={{ color: 'var(--dad-brown)', marginBottom: '0.5rem' }}>
                  Most Groan-Worthy Joke 😫
                </h3>
                <JokeCard joke={groanData.highest_groan_joke} />
              </div>
            )}
          </div>
        )}

        {/* Add Joke View */}
        {view === 'add' && (
          <div className="add-joke-form">
            <h2>Submit a Dad Joke ✍️</h2>
            <p style={{ color: '#666', marginBottom: '1.5rem' }}>
              Think you've got what it takes? Add your joke to the Dad-a-Base!
            </p>
            <form onSubmit={handleSubmitJoke}>
              <div className="form-group">
                <label>Setup (the question/statement)</label>
                <textarea
                  rows="2"
                  placeholder="Why did the dad joke cross the road?"
                  value={newJoke.setup}
                  onChange={(e) => setNewJoke({ ...newJoke, setup: e.target.value })}
                  required
                />
              </div>
              <div className="form-group">
                <label>Punchline (the groaner)</label>
                <textarea
                  rows="2"
                  placeholder="To get to the other pun!"
                  value={newJoke.punchline}
                  onChange={(e) => setNewJoke({ ...newJoke, punchline: e.target.value })}
                  required
                />
              </div>
              <div className="form-group">
                <label>Category</label>
                <select
                  value={newJoke.category_id}
                  onChange={(e) => setNewJoke({ ...newJoke, category_id: e.target.value })}
                >
                  <option value="">Select a category...</option>
                  {categories.map(cat => (
                    <option key={cat.id} value={cat.id}>{cat.emoji} {cat.name}</option>
                  ))}
                </select>
              </div>
              <button type="submit" className="submit-btn">
                Add to the Dad-a-Base! 🎉
              </button>
            </form>
          </div>
        )}
      </main>

      {/* Footer */}
      <footer className="footer">
        <p>
          Dad-a-Base v1.0.0 — Built with love, puns, and questionable engineering decisions.
        </p>
        <p style={{ marginTop: '0.5rem', opacity: 0.7 }}>
          Powered by PostgreSQL, FastAPI, React, and an unreasonable amount of Docker containers.
        </p>
        <p style={{ marginTop: '0.5rem' }}>
          <a href="/api/docs" target="_blank" rel="noopener noreferrer">API Docs</a>
          {' | '}
          <a href="/api/groan-o-meter" target="_blank" rel="noopener noreferrer">Groan-o-Meter API</a>
        </p>
      </footer>
    </div>
  );
}

export default App;
