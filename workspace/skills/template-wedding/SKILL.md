---
name: template-wedding
description: Wedding or event site — elegant typography, soft colors, RSVP section, photo gallery
approved: false
---

# Template: Wedding / Event

**Best for:** Weddings, engagements, galas, anniversary celebrations, formal events
**Style:** Elegant and romantic with soft colors, refined serif typography, delicate details

## Sections

1. **Hero** — Full-viewport with a beautiful engagement/venue photo as background. Couple's names in large elegant serif text, centered. Date below in lighter weight. Subtle gradient overlay for text readability. Thin decorative line or flourish between names and date.
2. **Countdown** — Centered countdown timer: days, hours, minutes, seconds in large elegant numbers. Small labels below each. Soft background. (Use a React state + setInterval for live countdown.)
3. **Our story** — Timeline of the relationship: 3-4 milestones (how we met, first date, proposal). Each: date, title, short text, optional photo. Vertical line connecting milestones.
4. **Event details** — 2-3 cards for ceremony, reception, after-party. Each: event name, date/time, venue name, address, optional map link. Cards have subtle border and elegant styling.
5. **Photo gallery** — Grid of couple photos. 3-column masonry-style. Images have subtle rounded corners. Lightbox on click (or simple modal overlay).
6. **RSVP** — Centered form: guest name, email, number of guests (dropdown), dietary restrictions (text), attending yes/no (radio buttons), submit button. Elegant form styling with thin borders.
7. **Registry** — Simple section with links to gift registries. 2-3 cards with store logos/names and "View Registry" buttons.
8. **Footer** — Couple's names, date, a short thank-you message. Minimal. Optional: hashtag for social media photos.

## Design recipe

### Colors
```css
:root {
  --color-bg: #fdf9f3;
  --color-surface: #ffffff;
  --color-primary: #8b6f4e;
  --color-primary-light: #c9a87c;
  --color-text: #3d3833;
  --color-text-muted: #9a948d;
  --color-border: #e8e0d4;
  --color-accent-bg: #f5efe6;
  --font-heading: Georgia, 'Times New Roman', serif;
  --font-body: system-ui, -apple-system, sans-serif;
}
```

### Typography
- Couple's names (hero): 3.5-5rem, serif, font-weight 400, letter-spacing 0.02em — elegant, not bold
- Section titles: 2rem, serif, font-weight 400
- Body text: 1rem, sans-serif, line-height 1.7
- Countdown numbers: 3rem, serif, font-weight 300
- Labels: 0.75rem, uppercase, letter-spacing 0.1em, color text-muted
- Thin, refined type throughout — nothing heavy or bold

### Visual effects
- **Decorative elements**: thin horizontal rules, small flourishes (CSS borders or SVG ornaments) between sections
- **Hero overlay**: `background: linear-gradient(rgba(0,0,0,0.2), rgba(0,0,0,0.3))`
- **Photo hover**: slight brightness increase + subtle scale
- **Form styling**: thin bottom-border inputs (not boxed), focus state with primary color border
- **Timeline line**: thin vertical line with small circles at each milestone (CSS pseudo-elements)
- **Fade-in animations**: gentle fade + slight translateY on scroll for each section
- **Overall feel**: delicate, airy, never heavy or loud

### Layout
- Max-width 900px for text content (narrower for intimacy)
- Photo gallery: 3-column masonry or grid with varying heights
- Event cards: centered, max-width 600px, stacked vertically
- RSVP form: max-width 500px, centered
- Generous spacing: 5-6rem between sections
- Everything centered — this isn't a marketing page, it's an invitation

### Responsive
- 1024px: reduce hero text to 2.5rem
- 768px: gallery → 2 columns, reduce countdown numbers to 2rem
- 480px: gallery → 1 column, stack event cards, full-width form
