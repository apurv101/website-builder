---
name: template-local-business
description: Local business site — warm and inviting, services grid, hours/location, testimonials, booking CTA
approved: false
---

# Template: Local Business

**Best for:** Restaurants, cafes, salons, barbershops, gyms, pet care, dental offices, repair shops, any brick-and-mortar
**Style:** Warm and inviting with friendly colors, clear information hierarchy, trust-building layout

## Sections

1. **Navbar** — Business logo/name left, links right: Services, About, Reviews, Contact. "Book Now" or "Call Us" CTA button. Sticky with solid background.
2. **Hero** — Large lifestyle photo of the business (interior, team at work, product in action). Overlay with business name, one-line tagline, and primary CTA ("Book Appointment", "Order Now", "Visit Us"). Full-width, min-height 70vh.
3. **Services/menu grid** — 3-4 column grid of services or menu items. Each card: icon or small image, service name, short description, price (if applicable). Clean cards with subtle shadow.
4. **About** — Side-by-side: warm photo of the owner/team (left) + story text (right). Personal, authentic tone: "Since 2015, we've been..." Include credentials or specialties.
5. **Testimonials** — 3 review cards with star ratings (gold stars), review text, customer name. Cards on a slightly different background color for contrast.
6. **Location & hours** — Two columns: hours table (Mon-Sun with open/close times) on one side, address + phone + email on the other. Optional: embedded map placeholder or "Get Directions" link. Business photo below.
7. **CTA section** — Warm accent background. "Ready to visit?" headline, phone number large and clickable (`tel:` link), "Book Online" button.
8. **Footer** — Business name, address, phone, hours summary, social links. Warm dark background.

## Design recipe

### Colors
```css
:root {
  --color-bg: #fffdf8;
  --color-surface: #ffffff;
  --color-primary: #b45309;
  --color-primary-dark: #92400e;
  --color-text: #292524;
  --color-text-muted: #78716c;
  --color-border: #e7e5e4;
  --color-accent-bg: #fef3c7;
  --color-stars: #f59e0b;
  --font-heading: Georgia, 'Times New Roman', serif;
  --font-body: system-ui, -apple-system, sans-serif;
}
```

### Typography
- Business name (hero): 2.5-3.5rem, serif, font-weight 700
- Section titles: 2rem, serif, font-weight 600
- Service names: 1.125rem, sans-serif, font-weight 600
- Prices: 1rem, font-weight 700, color primary
- Body: 1rem, sans-serif, line-height 1.65
- Phone number in CTA: 1.5rem, font-weight 700 — easy to tap
- Warm, approachable type — serif for headlines, sans-serif for everything else

### Visual effects
- **Hero overlay**: `background: linear-gradient(rgba(0,0,0,0.3), rgba(0,0,0,0.5))` over photo
- **Service card hover**: translateY -4px + shadow increase
- **Star ratings**: gold color (#f59e0b), use ★ character or SVG stars
- **CTA section**: warm accent background (amber/honey tone)
- **Testimonial cards**: subtle left border in primary color (3px solid)
- **Phone link**: styled as a button on mobile, underlined link on desktop
- **Scroll fade-in**: gentle opacity + translateY animation on sections

### Layout
- Max-width 1100px container
- Services grid: `repeat(3, 1fr)` desktop, `repeat(2, 1fr)` tablet, `1fr` mobile
- About: 2-column (image 45%, text 55%)
- Location/hours: 2-column, equal width
- Testimonials: 3-column grid, cards with equal height
- Section spacing: 4-5rem

### Responsive
- 1024px: services → 2 columns
- 768px: everything single column, about photo above text
- Phone numbers and address: tap-friendly on mobile
- CTA buttons: full-width on mobile
