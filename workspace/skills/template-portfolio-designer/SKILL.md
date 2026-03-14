---
name: template-portfolio-designer
description: Designer portfolio — editorial case-study layout, strong typography, project showcases
approved: false
---

# Template: Designer Portfolio

**Best for:** Graphic designers, UX/UI designers, brand designers, illustrators, creative professionals
**Style:** Editorial and refined with strong typographic hierarchy, case study focused, confident whitespace

## Sections

1. **Navbar** — Name/logo left, navigation right. Clean sans-serif or a distinctive serif. Links: Work, About, Contact. No background color — transparent or matches page bg.
2. **Hero** — Large statement headline: the designer's tagline or positioning statement in bold type (2-3 lines max). Subtitle with specialty. No image — pure typography impact. Or: headline left + rotating project thumbnail right.
3. **Selected work** — List of projects, each as a full-width row: project image/thumbnail (large, ~60% width), project title, client name, year, and category. Alternate image left/right per row. Hover: image slightly scales, title underlines.
4. **Case study preview** — For the most important project: full-width hero image, then a structured breakdown: challenge → approach → outcome, with supporting images inline. This shows depth.
5. **Skills/services** — Simple 2-column list or horizontal strip: "Branding, UI/UX, Typography, Art Direction, Motion" — understated, just establishing credibility.
6. **About** — Photo + bio side by side. Personal but professional tone. Include notable clients or awards as a simple list.
7. **Contact** — Large "Let's work together" headline. Email link prominent. Social links. Optional: simple contact form.
8. **Footer** — Minimal: copyright, social icons, back-to-top link.

## Design recipe

### Colors
```css
:root {
  --color-bg: #fafafa;
  --color-surface: #ffffff;
  --color-text: #111111;
  --color-text-muted: #666666;
  --color-primary: #111111;
  --color-accent: #ff4400;
  --color-border: #e0e0e0;
  --font-heading: system-ui, -apple-system, sans-serif;
  --font-body: system-ui, -apple-system, sans-serif;
}
```

### Typography
- Hero headline: 3.5-5rem, font-weight 700, letter-spacing -0.03em, line-height 1.05 — this is the centerpiece
- Project titles: 1.5-2rem, font-weight 600
- Body text: 1rem-1.125rem, line-height 1.6, font-weight 400
- Labels (year, category): 0.8rem, uppercase, letter-spacing 0.08em, color text-muted
- "Let's work together" CTA headline: 2.5-3rem, bold
- Typography IS the design — strong contrast between large headlines and small labels

### Visual effects
- **Project hover**: image `scale(1.03)` in overflow-hidden container + title underline animates in
- **Minimal shadows** — rely on whitespace and borders for separation
- **Accent color sparingly**: only on hover states, links, or one highlight element
- **Line separators**: thin 1px borders between project rows
- **Smooth scrolling**: `scroll-behavior: smooth` on html
- **Image treatment**: slight border-radius (4-8px), consistent aspect ratio per project

### Layout
- Max-width 1200px container
- Project rows: `grid-template-columns: 1fr 1fr` alternating image/text sides
- Generous whitespace: 6-8rem between sections, 4rem between project rows
- About: 2-column layout (photo 40%, text 60%)
- Skills: horizontal flex row with separators between items

### Responsive
- 1024px: hero headline → 2.5rem, project rows stack (image above text)
- 768px: single column everything, reduce section spacing to 4rem
- Contact headline: reduce to 2rem on mobile
