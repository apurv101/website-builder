---
name: web-scaffold
description: Scaffold a new landing page using Vite + React
---

# Web Scaffold

When the user wants a new website or landing page:

## 1. Gather requirements

Ask (if not already specified):
- **What is the site for?** Business, personal portfolio, event, product launch?
- **Style**: Minimal, bold, playful, corporate, dark mode?
- **Content**: Do they have text/images, or should you use placeholder content?
- **Sections**: Hero, features, testimonials, pricing, contact, footer?

Don't overwhelm — if they seem unsure, suggest sensible defaults and iterate.

## 2. Scaffold the project

Always use Vite + React + TypeScript. This is the standard stack.

**IMPORTANT:** The container has `NODE_ENV=production` set, which causes `npm install` to skip devDependencies (vite, typescript, etc.). You MUST override it.

```bash
npm create vite@latest <project-name> -- --template react-ts
cd <project-name>
NODE_ENV=development npm install
```

Use a short, URL-safe project name derived from what the user described (e.g. "joes-bakery", "saas-launch", "wedding-rsvp").

## 3. Project structure

Keep it simple. One-page landing pages don't need complex routing.

```
<project-name>/
  src/
    App.tsx          # Main landing page component
    App.css          # All styles (CSS modules or plain CSS)
    main.tsx         # Entry point (don't modify)
    components/      # Only if needed (e.g. Navbar, Footer, Hero)
  public/
    favicon.ico
  index.html
  package.json
  vite.config.ts
```

## 4. Styling approach

- Write plain CSS in App.css (no Tailwind, no CSS-in-JS — keep dependencies minimal)
- Use CSS custom properties for colors and fonts
- Mobile-first responsive design
- System font stack unless the user requests a specific font

## 5. Build and preview

```bash
NODE_ENV=development npm run build    # Output goes to dist/
npm run preview                       # Preview production build locally
```

Use the browser tool to show the user their site after building.

## 6. Iterate

Show the user a preview after each major change. Ask what they'd like to adjust before deploying.
