---
name: template-portfolio-photo
description: Photography portfolio — dark cinematic layout, fullscreen galleries, minimal UI
approved: false
---

# Template: Photography Portfolio

**Best for:** Photographers, videographers, visual artists, cinematographers
**Style:** Dark, cinematic, image-first design with minimal text and maximal visual impact

## Sections

1. **Navbar** — Photographer name/logo left in clean sans-serif. Minimal links: Work, About, Contact. Light text on dark bg. Thin, unobtrusive. Consider transparent navbar overlaying the hero.
2. **Hero** — Full-viewport hero image (100vh). No text overlay, or just the photographer's name and tagline in small, elegant type. Image uses `object-fit: cover`. Subtle scroll indicator (thin animated arrow or line at bottom).
3. **Gallery grid** — Masonry or asymmetric grid of photographs. Mix of landscape and portrait aspect ratios. Images have no borders or shadows — they breathe with whitespace (gap). Hover: subtle scale + overlay with project name.
4. **Featured project** — Full-width image with project title overlaid. Clicking leads to more images (or shows inline gallery). Alternating layout: image left + text right, then reversed.
5. **About** — Side-by-side: portrait photo of the photographer (left) + short bio text (right). Minimal, personal. Include a notable client list or publication logos.
6. **Contact** — Simple centered section: headline, email link, social icons. Or a minimal contact form (name, email, message). Keep it understated.
7. **Footer** — Minimal: copyright + social links. Same dark background, nearly invisible.

## Design recipe

### Colors
```css
:root {
  --color-bg: #0a0a0a;
  --color-surface: #141414;
  --color-text: #e5e5e5;
  --color-text-muted: #737373;
  --color-accent: #ffffff;
  --color-border: rgba(255, 255, 255, 0.1);
  --font-body: system-ui, -apple-system, sans-serif;
}
```

### Typography
- Photographer name: 1rem, uppercase, letter-spacing 0.15em, font-weight 500
- Section titles: 0.8rem uppercase, letter-spacing 0.1em, color text-muted
- Bio text: 1.125rem, line-height 1.7, font-weight 300
- Minimal text throughout — let images speak
- No serif fonts — clean sans-serif keeps focus on photos

### Visual effects
- **Hero image**: `width: 100%; height: 100vh; object-fit: cover;`
- **Gallery hover**: `transform: scale(1.02); filter: brightness(0.7);` with overlay text fading in (opacity transition)
- **Image loading**: fade-in from opacity 0 as images load
- **Scroll indicator**: thin line or small arrow, animated with CSS keyframes (translateY bounce)
- **Cursor**: consider `cursor: pointer` on gallery images with a custom feel
- **Page transitions**: smooth fade between sections using scroll-triggered opacity
- **No decorative elements** — every pixel serves the photography

### Layout
- Full-bleed images (no max-width container for hero and featured sections)
- Gallery grid: CSS columns (2-3 columns) or masonry-style grid with varying heights
- Gap between gallery images: 4-8px (tight) or 1.5-2rem (breathing room — choose based on style)
- About section: max-width 900px, centered
- Generous vertical padding between sections: 6-8rem

### Responsive
- 1024px: gallery → 2 columns
- 768px: gallery → 1 column, hero height → 70vh
- About section: stack photo above text
- Keep images full-width on mobile — they're the product
