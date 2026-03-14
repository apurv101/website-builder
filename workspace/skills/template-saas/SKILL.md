---
name: template-saas
description: SaaS product landing page — dark gradients, glassmorphism cards, bold CTAs
approved: false
---

# Template: SaaS Landing Page

**Best for:** Software products, startups, apps, developer tools, API services
**Style:** Dark and bold with gradient accents, glass-effect cards, high contrast CTAs

## Sections

1. **Navbar** — Logo left, 3-4 links center, CTA button right. Sticky with backdrop-filter blur on scroll. Semi-transparent background.
2. **Hero** — Large bold headline (max 6 words), gradient text on the key word. Subtitle underneath (1 sentence). Two buttons: primary (filled, gradient) and secondary (outline). Optional hero image/screenshot floating with subtle shadow on the right side.
3. **Logos bar** — "Trusted by" strip with 4-6 greyed-out company logos in a row. Subtle separator lines above and below.
4. **Features grid** — 3 columns, each card with glassmorphism effect (semi-transparent bg, backdrop-filter blur, subtle border). Icon at top (use emoji or simple SVG), bold title, 2-line description.
5. **How it works** — 3 steps in a horizontal flow with numbered circles connected by a line. Each step: number, title, description.
6. **Testimonials** — 2-3 quote cards with avatar circle, name, role, company. Cards have subtle border and shadow.
7. **Pricing** — 2-3 tier cards side by side. Middle card highlighted (scaled up slightly, gradient border). Each card: plan name, price, feature list with checkmarks, CTA button.
8. **CTA section** — Full-width gradient background. Large headline, subtitle, single prominent button. This is the "close the deal" section.
9. **Footer** — Dark background, 3-4 column links layout, logo, copyright.

## Design recipe

### Colors
```css
:root {
  --color-bg: #0a0a1a;
  --color-surface: rgba(255, 255, 255, 0.05);
  --color-surface-border: rgba(255, 255, 255, 0.1);
  --color-primary: #6366f1;
  --color-primary-light: #818cf8;
  --color-accent: #06b6d4;
  --color-text: #f1f5f9;
  --color-text-muted: #94a3b8;
  --color-gradient: linear-gradient(135deg, #6366f1, #06b6d4);
}
```

### Typography
- Headlines: font-weight 700-800, letter-spacing -0.02em for large text
- Hero headline: 3.5-4rem desktop, 2rem mobile
- Section headlines: 2-2.5rem
- Body text: 1rem-1.125rem, line-height 1.6, color text-muted
- Use `font-family: system-ui, -apple-system, sans-serif`

### Visual effects
- **Glassmorphism cards**: `background: rgba(255,255,255,0.05); backdrop-filter: blur(12px); border: 1px solid rgba(255,255,255,0.1); border-radius: 16px;`
- **Gradient text**: `background: linear-gradient(135deg, #6366f1, #06b6d4); -webkit-background-clip: text; -webkit-text-fill-color: transparent;`
- **Button hover**: slight scale(1.02) + box-shadow glow in primary color
- **Card hover**: translate Y -4px + increased shadow
- **Glow effect behind hero**: radial-gradient circle of primary color at 10% opacity behind the hero section
- **Scroll animations**: fade-in-up on sections as they enter viewport (IntersectionObserver, translate Y 20px → 0, opacity 0 → 1, transition 0.6s)

### Layout
- Max-width 1200px container centered
- Section padding: 5rem 0 (desktop), 3rem 0 (mobile)
- Features grid: `grid-template-columns: repeat(3, 1fr)` → `1fr` on mobile
- Pricing: `grid-template-columns: repeat(3, 1fr)` → stack on mobile
- Gap: 2rem between grid items
- Generous padding inside cards: 2rem

### Responsive
- 1024px: reduce hero headline to 2.5rem
- 768px: stack features and pricing to single column, reduce section padding
- 480px: further reduce type sizes, full-width buttons
