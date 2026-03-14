---
name: template-music-artist
description: Music artist or DJ site — dark cinematic design, bold visuals, tour dates, music player
approved: false
---

# Template: Music Artist

**Best for:** Musicians, bands, DJs, producers, performing artists, record labels
**Style:** Dark, cinematic, and immersive with bold typography, atmospheric visuals, and a sense of energy

## Sections

1. **Hero** — Full-viewport dark atmospheric section. Artist name in massive bold type (5-7rem). Background: moody artist photo with heavy dark overlay, or a solid dark gradient with subtle texture. Tagline or genre below name. Optional: embedded music player or "Listen Now" button.
2. **Latest release** — Full-width section showcasing new album/single. Large album art on one side, track details on the other: title, release date, tracklist, streaming platform links (Spotify, Apple Music, etc.) as icon buttons.
3. **Music/discography** — Horizontal scrollable row of album/single covers. Each: square album art, title below, year. Click to expand with tracklist. Or: grid layout if more items.
4. **Tour dates** — Table/list of upcoming shows. Each row: date (large), city + venue, ticket button. Alternating subtle background on rows. "No upcoming shows" state if empty. Past dates can be shown greyed out.
5. **Video** — Featured music video embed or a fullwidth background video section. Dark surrounding area to keep focus on the video.
6. **About/bio** — Atmospheric photo + bio text. Keep it short and in the artist's voice. Include notable achievements, collaborations, press quotes.
7. **Newsletter/mailing list** — "Join the list" with email signup. Dark background, simple form. "Be the first to know about new releases and shows."
8. **Footer** — Social media links (Instagram, Spotify, YouTube, TikTok, Twitter) prominent. Copyright. Management/booking email.

## Design recipe

### Colors
```css
:root {
  --color-bg: #0a0a0a;
  --color-surface: #161616;
  --color-primary: #ff2d55;
  --color-text: #ffffff;
  --color-text-muted: #888888;
  --color-border: rgba(255, 255, 255, 0.1);
  --color-gradient: linear-gradient(180deg, #0a0a0a 0%, #1a1020 100%);
}
```

### Typography
- Artist name (hero): 5-7rem, font-weight 900, uppercase, letter-spacing -0.02em — dominating the viewport
- Section titles: 1.5-2rem, font-weight 700, uppercase, letter-spacing 0.05em
- Tour date cities: 1.25rem, font-weight 600
- Body text: 1rem, line-height 1.6, color text-muted
- All caps for navigation and labels
- Sans-serif throughout — modern, clean, bold

### Visual effects
- **Hero atmosphere**: dark overlay (70-80% opacity) over artist photo, optional grain texture overlay
- **Gradient backgrounds**: subtle dark gradients between sections to create depth
- **Album art hover**: lift + glow shadow in primary color: `box-shadow: 0 8px 30px rgba(255, 45, 85, 0.3)`
- **Tour date hover**: row background highlight, ticket button becomes more prominent
- **CTA buttons**: primary color fill, bold, uppercase text, hover: brightness increase + slight scale
- **Subtle glow**: primary color radial gradient at low opacity behind key elements
- **Text glow effect**: `text-shadow: 0 0 40px rgba(255, 45, 85, 0.3)` on hero artist name
- **Smooth scroll**: all sections fade in on scroll

### Layout
- Full-width dark sections, edge to edge
- Latest release: `grid-template-columns: 1fr 1fr` (album art + details)
- Discography: horizontal scroll container or 4-column grid
- Tour dates: max-width 800px, centered, list layout
- Social links in footer: large icon row, centered, generous spacing between icons

### Responsive
- 1024px: hero text → 3.5rem, latest release → stack vertically
- 768px: hero text → 2.5rem, discography → 2 columns or horizontal scroll
- 480px: tour dates → compact cards instead of table rows
