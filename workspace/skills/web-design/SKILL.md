---
name: web-design
description: Design and style landing pages with modern CSS and responsive layouts
---

# Web Design

When designing or styling a landing page:

> **If a template was applied**, use these guidelines to refine and customize — don't redesign from scratch. The template's design recipe has already established the visual direction. Focus on swapping in the user's content, adjusting colors for their brand, and making refinements they request.

## Landing page structure

A typical landing page flows top to bottom:

1. **Navbar** — Logo + minimal links (optional CTA button)
2. **Hero** — Big headline, subtext, primary CTA button
3. **Features/Benefits** — 3-4 cards or icon+text blocks
4. **Social proof** — Testimonials, logos, stats
5. **Pricing** (if applicable) — 2-3 tier cards
6. **CTA section** — Repeat the main call to action
7. **Footer** — Links, copyright, social icons

Not every page needs all sections. Ask the user what matters most.

## Responsive layout

- CSS Grid for page-level section layouts
- Flexbox for component-level alignment
- Mobile-first: single column by default, expand at breakpoints
- Breakpoints: 640px (sm), 768px (md), 1024px (lg)

## Colors and typography

- Ask for brand colors, or suggest a palette based on their vibe
- Use CSS custom properties:
  ```css
  :root {
    --color-primary: #2563eb;
    --color-text: #1f2937;
    --color-bg: #ffffff;
    --color-light: #f9fafb;
    --font-body: system-ui, -apple-system, sans-serif;
  }
  ```
- High contrast text (WCAG AA minimum)
- Consistent spacing scale (multiples of 8px)

## Component patterns

### Hero
- Full-width background (color or gradient, avoid stock images unless provided)
- If the user sent a hero image or photo, use it as the hero background or feature image
- Headline: short, benefit-driven (6-10 words)
- Subtext: 1-2 sentences max
- One primary CTA button with clear action text ("Get Started", "Book Now")

### User-provided images (logos, photos, screenshots)
- When the user sends a logo, use it in the navbar and footer instead of text
- Size logos appropriately (typically 40-60px height in navbar)
- For hero photos, consider using as a background with an overlay for text readability:
  ```css
  .hero {
    background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), url('/images/hero.jpg');
    background-size: cover;
    background-position: center;
  }
  ```
- For team/product photos, use `object-fit: cover` to maintain aspect ratio in fixed containers
- Always add meaningful `alt` text based on what the image shows
- Reference images as `/images/<filename>` (served from `public/images/`)

### Feature cards
- Grid layout: 1 column mobile, 2-3 columns desktop
- Each card: icon/emoji + heading + short description
- Keep descriptions under 2 lines

### CTA buttons
- Prominent color (primary brand color)
- Generous padding (12px 32px minimum)
- Rounded corners (8px)
- Hover state with slight darken or lift

## Accessibility

- Semantic HTML (nav, main, section, footer)
- Alt text on images
- Button elements for actions, anchor elements for navigation
- Visible focus styles
- Skip-to-content link if navigation is complex

## Performance

- No external CSS frameworks (no Tailwind, no Bootstrap)
- System font stack (no font loading delay)
- SVG for icons when possible
- Lazy load images below the fold
