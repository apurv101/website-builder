---
name: template-dashboard
description: Internal tool or dashboard — data-dense layout, sidebar nav, cards and tables, functional UI
approved: false
---

# Template: Dashboard / Internal Tool

**Best for:** Admin panels, analytics dashboards, business tools, CRM interfaces, inventory systems
**Style:** Clean and functional with dense information layout, clear data hierarchy, sidebar navigation

## Sections

1. **Sidebar** — Fixed left sidebar (240px width). Logo/app name at top. Vertical nav links with icons: Dashboard, Orders, Products, Customers, Settings. Active state with primary color highlight and background. Collapse to icons on smaller screens.
2. **Top bar** — Horizontal bar at top of main content area. Breadcrumb or page title left, user avatar + notification bell right. Search bar in center (optional).
3. **Stats row** — 4 metric cards in a row at top of main content. Each: label (small text), large number, trend indicator (up/down arrow with percentage, green/red). Cards have subtle border and clean background.
4. **Charts area** — 1-2 chart placeholder sections. Revenue over time (line chart area), sales by category (bar chart area). Use colored div blocks as chart placeholders or simple CSS-only visual representations.
5. **Data table** — Full-width table with columns: checkbox, ID, name, status (badge), date, amount, actions (edit/delete buttons). Sortable column headers. Alternating row backgrounds. Pagination at bottom.
6. **Recent activity** — Side panel or section listing recent actions: "Order #123 placed", "New customer signed up". Each: icon, description, timestamp. Scrollable.
7. **Quick actions** — Row of action buttons: "Add Product", "Export Data", "Generate Report". Secondary importance below stats.

## Design recipe

### Colors
```css
:root {
  --color-bg: #f1f5f9;
  --color-surface: #ffffff;
  --color-sidebar: #0f172a;
  --color-sidebar-text: #94a3b8;
  --color-sidebar-active: #2563eb;
  --color-primary: #2563eb;
  --color-success: #16a34a;
  --color-warning: #f59e0b;
  --color-danger: #dc2626;
  --color-text: #0f172a;
  --color-text-muted: #64748b;
  --color-border: #e2e8f0;
}
```

### Typography
- Page titles: 1.5rem, font-weight 700
- Stat numbers: 2rem, font-weight 800
- Stat labels: 0.8rem, color text-muted, uppercase, letter-spacing 0.04em
- Table headers: 0.75rem, uppercase, letter-spacing 0.05em, font-weight 600, color text-muted
- Table body: 0.875rem, font-weight 400
- All sans-serif — `system-ui` throughout
- Dense but readable — smaller base sizes than marketing sites

### Visual effects
- **Status badges**: small rounded pills — green for active, amber for pending, red for cancelled, gray for draft. `padding: 2px 10px; border-radius: 12px; font-size: 0.75rem;`
- **Card shadows**: `box-shadow: 0 1px 3px rgba(0,0,0,0.08)` — very subtle
- **Table row hover**: light blue/gray background highlight
- **Sidebar active item**: left border accent (3px solid primary), background slightly lighter
- **Trend indicators**: green text + ↑ for positive, red text + ↓ for negative
- **No scroll animations** — dashboards need to feel instant and functional
- **Action buttons**: small, outlined style for secondary actions, filled for primary

### Layout
- **Sidebar + main**: `grid-template-columns: 240px 1fr` for the overall page
- **Stats row**: `grid-template-columns: repeat(4, 1fr)` with 1rem gap
- **Charts**: `grid-template-columns: 2fr 1fr` for main chart + side panel
- **Table**: full-width within main content, with horizontal scroll on mobile
- **Padding**: 1.5rem on main content area, 1rem inside cards
- **Dense spacing**: 1-1.5rem between sections (not the 4-5rem of marketing sites)

### Responsive
- 1024px: sidebar collapses to icon-only (60px wide), stats → 2x2 grid
- 768px: sidebar becomes a top hamburger menu, full-width content
- Table: horizontal scroll container on mobile
- Stats: stack vertically on small screens
- Charts: stack vertically
