# UI Documentation

## Overview

Single-page React 18 web application — "The Pun Palace". Served via Caddy reverse proxy at port 80.

## Pages / Screens / Commands

| Page/Screen | Purpose | Key Components |
|-------------|---------|----------------|
| Main view | Random joke display + punchline reveal | Random joke button, punchline reveal animation |
| Category browser | Browse jokes by 15 categories | Category cards with emoji icons, joke list |
| Search | Full-text joke search | Search input, filtered results |
| Add joke | Submit new dad jokes | Form with setup/punchline/category fields |
| Groan-o-Meter | Statistical analysis of joke ratings | Charts/stats display |

## Design System

- **Framework:** React 18
- **Theme:** Dad-joke themed (pun-heavy UI copy)
- **Icons:** Emoji-based category icons (15 categories)

## User Flows

### Get a Random Joke

1. User clicks "Random Joke" button
2. System fetches from `/api/jokes/random`
3. Setup line displays immediately
4. User clicks to reveal punchline (animation)

### Rate a Joke

1. User views a joke
2. User selects rating (1-5 groans)
3. System POSTs to `/api/jokes/{id}/rate`
4. Groan-o-Meter updates

### Search for a Joke

1. User types in search box
2. System queries `/api/jokes/search?q={term}`
3. Matching jokes displayed in results

## Responsive Behavior

Web-only SPA served through Caddy. Basic responsive layout.

## Accessibility

- Semantic HTML for joke content
- Button-based interactions for punchline reveals

---

*Created: 2026-04-09*
*Last updated: 2026-04-09*
