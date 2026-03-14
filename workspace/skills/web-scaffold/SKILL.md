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
    main.tsx         # Entry point
    ErrorBoundary.tsx # Error boundary (catches runtime crashes)
    components/      # Only if needed (e.g. Navbar, Footer, Hero)
  public/
    favicon.ico
    images/          # User-provided images (logos, photos, screenshots)
  index.html
  package.json
  vite.config.ts
```

## 3a. ErrorBoundary

Every project must include `src/ErrorBoundary.tsx` — a React class component that catches runtime errors and shows a friendly message + refresh button instead of a blank screen. In dev mode it also shows the error details.

Create `src/ErrorBoundary.tsx`:

```tsx
import { Component, type ErrorInfo, type ReactNode } from 'react'

interface Props {
  children: ReactNode
}

interface State {
  hasError: boolean
  error: Error | null
}

class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props)
    this.state = { hasError: false, error: null }
  }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error }
  }

  componentDidCatch(error: Error, info: ErrorInfo) {
    console.error('ErrorBoundary caught:', error, info.componentStack)
  }

  render() {
    if (!this.state.hasError) {
      return this.props.children
    }

    const isDev = import.meta.env.DEV

    return (
      <div style={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontFamily: 'system-ui, -apple-system, sans-serif',
        padding: '2rem',
        backgroundColor: '#fafafa',
        color: '#333',
      }}>
        <div style={{ textAlign: 'center', maxWidth: '500px' }}>
          <h1 style={{ fontSize: '1.5rem', marginBottom: '0.5rem' }}>
            Something went wrong
          </h1>
          <p style={{ color: '#666', marginBottom: '1.5rem' }}>
            An unexpected error occurred. Please try refreshing the page.
          </p>
          <button
            onClick={() => window.location.reload()}
            style={{
              padding: '0.6rem 1.5rem',
              fontSize: '1rem',
              border: 'none',
              borderRadius: '6px',
              backgroundColor: '#333',
              color: '#fff',
              cursor: 'pointer',
            }}
          >
            Refresh page
          </button>
          {isDev && this.state.error && (
            <pre style={{
              marginTop: '2rem',
              padding: '1rem',
              backgroundColor: '#fee',
              borderRadius: '6px',
              fontSize: '0.8rem',
              textAlign: 'left',
              overflow: 'auto',
              maxHeight: '300px',
              color: '#c00',
            }}>
              {this.state.error.message}
              {'\n\n'}
              {this.state.error.stack}
            </pre>
          )}
        </div>
      </div>
    )
  }
}

export default ErrorBoundary
```

Update `main.tsx` to wrap `<App />` with `<ErrorBoundary>`:

```tsx
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import ErrorBoundary from './ErrorBoundary.tsx'
import App from './App.tsx'

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <ErrorBoundary>
      <App />
    </ErrorBoundary>
  </StrictMode>,
)
```

## 3b. User-provided images

If the user has sent images (via WhatsApp), copy them into the project immediately — media files expire after 2 minutes:

```bash
mkdir -p <project-name>/public/images
cp <MediaPath> <project-name>/public/images/<descriptive-name>.ext
```

Choose a descriptive filename (e.g. `logo.png`, `hero-bg.jpg`). Reference them in components as `/images/<filename>`. Vite copies everything in `public/` into `dist/` automatically.

## 3c. Data-connected sites

If the site needs to store or manage data (store, blog with CMS, dashboard, inventory):

1. Create a `migrations/` directory for SQL migration files
2. Create `src/api.ts` with the API helper (see the frontend-design skill)
3. Add the `/api` proxy to `vite.config.ts` so local dev hits the local PostgREST:

```typescript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:3001',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, ''),
      },
    },
  },
})
```

This only affects `npm run dev` — production builds are unaffected. The local PostgREST is started by `./scripts/local-up.sh` from the repo root.

These are needed for the db-design and frontend-design skills. You can add them later too — a simple site can grow into a data-connected one at any time.

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
