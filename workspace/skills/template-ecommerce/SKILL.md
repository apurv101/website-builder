---
name: template-ecommerce
description: E-commerce storefront — product grid, clean shopping UI, warm editorial feel
approved: false
---

# Template: E-commerce Store

**Best for:** Online shops, boutiques, product-based businesses, artisan goods, home goods
**Style:** Clean and elevated with product-first photography, warm neutrals, editorial shopping feel

## Sections

1. **Navbar** — Logo left, centered navigation (Shop, Collections, About, Contact), cart icon right with item count badge. Sticky with white/cream background.
2. **Hero** — Full-width lifestyle image showing products in context. Overlay: short headline + "Shop Now" button. Or: split layout with image left, headline + text + CTA right.
3. **Featured collection** — Horizontal scrollable row or 4-column grid of product cards. Each card: product image (aspect-ratio 3/4), product name, price. Clean, no borders. Hover: image swaps to alternate angle or slight zoom.
4. **Category grid** — 2-3 large category cards with lifestyle images. Each: category name overlaid in elegant type. "Kitchen", "Living Room", "Bedroom" etc. Links to filtered views.
5. **Product highlight** — Full-width split: large product image left (60%), product details right (40%). Name, price, short description, "Add to Cart" button, trust badges (free shipping, returns).
6. **Social proof** — Customer reviews: 2-3 cards with star rating, review text, customer name. Or Instagram-style photo grid showing products in real life.
7. **Brand story** — About section: image + text side by side. Why the brand exists, craftsmanship, values. Warm and authentic tone.
8. **Newsletter** — Subtle banner: "Join our list for early access" + email input + button. Warm accent background.
9. **Footer** — 4 columns: Shop links, Customer service, About, Newsletter. Payment icons at bottom. Warm dark background.

## Design recipe

### Colors
```css
:root {
  --color-bg: #fffcf7;
  --color-surface: #ffffff;
  --color-text: #2d2a26;
  --color-text-muted: #8a8580;
  --color-primary: #2d2a26;
  --color-accent: #c87941;
  --color-border: #e8e4df;
  --color-badge: #c87941;
  --font-heading: Georgia, 'Times New Roman', serif;
  --font-body: system-ui, -apple-system, sans-serif;
}
```

### Typography
- Headlines: serif (Georgia), font-weight 400-600, letter-spacing -0.01em — elegant, not heavy
- Product names: 0.95rem, sans-serif, font-weight 500
- Prices: 1rem, font-weight 600, no currency symbol clutter
- Body text: 1rem, sans-serif, line-height 1.65
- "Add to Cart" buttons: 0.875rem uppercase, letter-spacing 0.08em

### Visual effects
- **Product card hover**: image scale(1.05) in overflow-hidden container, smooth 0.4s transition
- **Second image on hover**: if available, crossfade to alternate product photo
- **Button style**: solid background with generous padding (14px 32px), no border-radius or very slight (2-4px) — editorial, not bubbly
- **Category card overlay**: `background: linear-gradient(transparent 40%, rgba(0,0,0,0.5))` with text at bottom
- **Cart badge**: small circle with accent color, positioned top-right of cart icon
- **Subtle animations**: fade-in on scroll for product grids

### Layout
- Max-width 1300px container
- Product grid: `grid-template-columns: repeat(4, 1fr)` desktop, 2 on tablet, 1-2 on mobile
- Product cards: no border, no shadow — rely on whitespace
- Category grid: `grid-template-columns: repeat(3, 1fr)` with tight gap (4-8px)
- Section spacing: 5rem between sections
- Product images: consistent `aspect-ratio: 3/4` with `object-fit: cover`

### Responsive
- 1024px: product grid → 3 columns, category grid → 2 columns
- 768px: product grid → 2 columns, hero → stack image above text
- 480px: product grid → 2 columns (smaller), increase touch targets on buttons
