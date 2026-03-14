---
name: template-blog
description: Blog or content site — clean editorial layout, readable typography, card grids
approved: false
---

# Template: Blog

**Best for:** Food blogs, lifestyle blogs, personal blogs, newsletters, content creators
**Style:** Clean and airy with strong typography, warm tones, generous whitespace

## Sections

1. **Navbar** — Blog name/logo left in a serif or display font. Minimal links: Home, About, Categories, Subscribe button. Clean underline hover effect on links.
2. **Hero/Featured post** — Full-width featured article with large background image, dark gradient overlay at bottom, headline and date overlaid in white text. Or: side-by-side layout with image left, headline + excerpt right.
3. **Post grid** — 3-column card grid of recent posts. Each card: image with aspect-ratio 3/2, category tag above title, headline, excerpt (2 lines), author + date at bottom. Cards have subtle shadow and rounded corners.
4. **Category bar** — Horizontal scrollable list of category pills/tags for filtering. Active state with filled background.
5. **Newsletter signup** — Centered section with warm background color. Headline "Stay in the loop", subtitle, email input + subscribe button inline.
6. **About the author** — Small section with photo circle, name, short bio, social links. Can be a sidebar element or standalone section.
7. **Footer** — Light or warm background, 3 columns: about, categories, social links. Copyright at bottom.

## Design recipe

### Colors
```css
:root {
  --color-bg: #faf8f5;
  --color-surface: #ffffff;
  --color-primary: #c2410c;
  --color-primary-light: #f97316;
  --color-text: #1c1917;
  --color-text-muted: #78716c;
  --color-border: #e7e5e4;
  --color-accent-bg: #fef3c7;
  --font-heading: Georgia, 'Times New Roman', serif;
  --font-body: system-ui, -apple-system, sans-serif;
}
```

### Typography
- Headlines: serif font (Georgia), font-weight 700, letter-spacing -0.01em
- Hero headline: 3rem desktop, 1.75rem mobile
- Post card titles: 1.25rem, font-weight 600
- Body/excerpt text: 1rem, line-height 1.7, sans-serif
- Category tags: 0.75rem uppercase, letter-spacing 0.05em, font-weight 600
- Dates/meta: 0.875rem, color text-muted

### Visual effects
- **Card hover**: subtle shadow increase + image scale(1.03) with overflow hidden
- **Image treatment**: `border-radius: 12px; object-fit: cover; aspect-ratio: 3/2;`
- **Category pills**: small rounded backgrounds with brand color at low opacity
- **Link hover**: underline offset animation (text-underline-offset transition)
- **Newsletter section**: warm accent background (--color-accent-bg)
- **Subtle transitions**: all interactive elements transition 0.2s ease

### Layout
- Max-width 1100px for main content
- Post grid: 3 columns desktop, 2 tablet, 1 mobile
- Card padding: 0 (image bleeds to edges), content padding 1.25rem
- Section spacing: 4rem between sections
- Featured post: full-width, min-height 400px with image background

### Responsive
- 1024px: post grid → 2 columns
- 768px: post grid → 1 column, reduce hero height
- Featured post: stack image above text on mobile
