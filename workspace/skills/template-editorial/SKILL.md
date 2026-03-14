---
name: template-editorial
description: Editorial magazine or news publication — newspaper-inspired grid, serif typography, sophisticated layout
approved: false
---

# Template: Editorial / Magazine

**Best for:** News publications, online magazines, research journals, literary platforms, industry newsletters
**Style:** Sophisticated newspaper-inspired design with serif headlines, multi-column grids, and elegant typography

## Sections

1. **Header** — Publication name centered in large serif font (newspaper masthead style). Thin rule lines above and below. Date and edition info in small text. Navigation links below in uppercase small text.
2. **Featured article** — Large headline spanning full width in bold serif. Subtitle/deck in lighter weight. Author byline with small avatar. Can include a large hero image with caption.
3. **Article grid** — Asymmetric newspaper-style layout: 1 large article (2/3 width) + 2 stacked smaller articles (1/3 width). Thin vertical divider lines between columns. Each article: category label, headline, excerpt, author, date.
4. **Section divider** — Thin horizontal rule with section name centered (like newspaper section headers: "Opinion", "Culture", "Technology").
5. **Secondary articles** — 3-4 column grid of smaller article cards. Minimal styling: headline + excerpt + date. No images, text-focused.
6. **Pull quote** — Full-width highlight strip with a large quotation in italic serif, centered, with author attribution.
7. **Newsletter CTA** — Subtle, inline banner: "Subscribe to our newsletter" with email field. Understated design, fits the editorial tone.
8. **Footer** — Full-width dark or off-white background. Publication name, columns of links (sections, about, legal), social icons.

## Design recipe

### Colors
```css
:root {
  --color-bg: #fafaf8;
  --color-surface: #ffffff;
  --color-primary: #b91c1c;
  --color-text: #111827;
  --color-text-muted: #6b7280;
  --color-border: #d1d5db;
  --color-accent-bg: #f3f4f6;
  --font-heading: Georgia, 'Times New Roman', serif;
  --font-body: system-ui, -apple-system, sans-serif;
}
```

### Typography
- Masthead/publication name: 2.5-3rem, serif, uppercase or small-caps, letter-spacing 0.1em
- Article headlines: serif, font-weight 700, sizes vary by prominence (1.75rem featured, 1.25rem secondary, 1rem tertiary)
- Body/excerpts: sans-serif, 1rem, line-height 1.65
- Category labels: 0.7rem uppercase, letter-spacing 0.08em, primary color, font-weight 700
- Bylines: 0.8rem, color text-muted, italic
- Strong typographic hierarchy is the entire design — sizes and weights carry the visual weight, not colors or effects

### Visual effects
- **Divider lines**: 1px solid borders between columns and sections — this is the main visual device
- **Article hover**: headline color shifts to primary (red)
- **No heavy shadows or gradients** — the design relies on whitespace, rules, and type contrast
- **Pull quote styling**: large italic serif, 1.5-2rem, with a thin top and bottom border, generous padding
- **Category labels**: colored text (primary), no background — like newspaper section labels
- **Image captions**: small italic text below images

### Layout
- Max-width 1200px
- Asymmetric grids: use `grid-template-columns: 2fr 1fr` for featured layout
- Vertical dividers: `border-right: 1px solid var(--color-border)` between columns
- Horizontal rules between sections
- Generous line-height and paragraph spacing for readability
- Column gap: 2rem with padding to keep text away from dividers

### Responsive
- 1024px: asymmetric grid → single column, remove vertical dividers
- 768px: all grids single column, increase body text to 1.05rem for readability
- Keep serif headlines at all sizes — they define the editorial feel
