---
name: template-portfolio-agency
description: Creative agency site — bold contrast, large imagery, case study cards, dark/light sections
approved: false
---

# Template: Creative Agency

**Best for:** Design agencies, marketing agencies, studios, creative consultancies, development shops
**Style:** Bold and confident with high contrast dark/light alternating sections, large imagery, strong presence

## Sections

1. **Navbar** — Agency logo left, links right: Work, Services, About, Contact. CTA button: "Start a project". Sticky. Transparent on hero, solid on scroll.
2. **Hero** — Full-viewport dark section. Massive headline (the agency's value proposition) in white, very large type. Subtle background: slow-moving gradient, grain texture overlay, or a moody video/image. Scroll-down indicator.
3. **Selected work** — 2-column grid of project cards. Each card: large image covering the card, project title and client overlaid at bottom on hover (dark gradient overlay). Cards alternate between full-width and half-width for visual rhythm.
4. **Services** — Light background section. 3-4 services in a grid. Each: large number (01, 02, 03), service name, short description. Clean, structured, no icons.
5. **Stats/credibility** — Horizontal strip: "150+ Projects", "12 Years", "40 Clients", "8 Awards". Large numbers, small labels. Dark background.
6. **Testimonial** — Single large quote on a contrasting background. Client name, company, and small avatar. Minimal — one powerful quote is better than a carousel.
7. **About** — Team grid or agency story. If team: 3-4 member photos with name and role. Photos are black and white, color on hover.
8. **CTA** — Dark section. "Ready to start?" large headline. Brief text. Contact button.
9. **Footer** — Dark, multi-column: services list, contact info (email, phone, address), social links, newsletter signup.

## Design recipe

### Colors
```css
:root {
  --color-bg-dark: #0f0f0f;
  --color-bg-light: #f5f5f0;
  --color-text-on-dark: #ffffff;
  --color-text-on-light: #0f0f0f;
  --color-text-muted: #999999;
  --color-accent: #ff3c00;
  --color-border-light: #e0e0e0;
  --color-border-dark: rgba(255, 255, 255, 0.15);
}
```

### Typography
- Hero headline: 4-6rem, font-weight 800, letter-spacing -0.03em, line-height 0.95 — intentionally massive
- Section headlines: 2.5-3rem, font-weight 700
- Service numbers: 1rem, font-weight 300, color text-muted
- Stat numbers: 3rem, font-weight 800
- Body: 1rem, line-height 1.6
- Use uppercase sparingly for labels and nav

### Visual effects
- **Alternating dark/light sections**: creates visual rhythm and impact
- **Project card hover**: dark gradient overlay fades in from bottom, text slides up, image scale(1.05)
- **Hero background**: CSS grain overlay using a subtle noise texture (tiny repeating SVG or radial gradient noise)
- **Team photos**: `filter: grayscale(100%)` default, `grayscale(0%)` on hover with transition
- **Stats section**: numbers count up animation on scroll (IntersectionObserver triggered)
- **Smooth page feel**: all transitions 0.4s cubic-bezier(0.16, 1, 0.3, 1)

### Layout
- Full-width sections alternating dark/light
- Work grid: mix of `grid-template-columns: 1fr 1fr` and `1fr` rows for rhythm
- Services: `grid-template-columns: repeat(4, 1fr)` with vertical dividers
- Max-width 1400px for content within full-width sections
- Generous padding: 6-8rem vertical per section

### Responsive
- 1024px: hero headline → 3rem, services → 2 columns
- 768px: single column throughout, reduce section padding to 4rem
- Work grid → single column stack
- Stats → 2x2 grid instead of horizontal strip
