---
name: frontend-design
description: Design data-connected web UIs (stores, dashboards, inventory) that talk to the database via REST API
---

# Frontend Design

When designing a site that displays or manages data (stores, dashboards, inventory, etc.):

## API connection

Sites connect to the database through PostgREST, which exposes database views and tables as REST endpoints at `/api/`.

### API helper

Create `src/api.ts` in every data-connected project:

```typescript
// src/api.ts
const subdomain = window.location.hostname.split('.')[0];
const SCHEMA = 'site_' + subdomain.replace(/-/g, '_');

export async function query<T = any>(
  view: string,
  params?: Record<string, string>
): Promise<T[]> {
  const url = new URL(`/api/${view}`, window.location.origin);
  if (params) {
    Object.entries(params).forEach(([k, v]) => url.searchParams.set(k, v));
  }
  const res = await fetch(url.toString(), {
    headers: { 'Accept-Profile': SCHEMA },
  });
  if (!res.ok) throw new Error(`API error: ${res.status}`);
  return res.json();
}

export async function insert<T = any>(
  table: string,
  data: Record<string, any>
): Promise<T> {
  const res = await fetch(`/api/${table}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Profile': SCHEMA,
      'Accept-Profile': SCHEMA,
      'Prefer': 'return=representation',
    },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error(`API error: ${res.status}`);
  const result = await res.json();
  return Array.isArray(result) ? result[0] : result;
}

export async function update<T = any>(
  table: string,
  filters: string,
  data: Record<string, any>
): Promise<T[]> {
  const res = await fetch(`/api/${table}?${filters}`, {
    method: 'PATCH',
    headers: {
      'Content-Type': 'application/json',
      'Content-Profile': SCHEMA,
      'Accept-Profile': SCHEMA,
      'Prefer': 'return=representation',
    },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error(`API error: ${res.status}`);
  return res.json();
}

export async function remove(table: string, filters: string): Promise<void> {
  const res = await fetch(`/api/${table}?${filters}`, {
    method: 'DELETE',
    headers: { 'Content-Profile': SCHEMA },
  });
  if (!res.ok) throw new Error(`API error: ${res.status}`);
}
```

### PostgREST query syntax

Use these filter patterns in the `params` argument to `query()` or in URL query strings:

| Operation | Syntax | Example |
|-----------|--------|---------|
| Equal | `field=eq.value` | `name=eq.Widget` |
| Not equal | `field=neq.value` | `status=neq.archived` |
| Greater than | `field=gt.value` | `price=gt.10` |
| Less than | `field=lt.value` | `stock=lt.5` |
| Like | `field=like.*term*` | `name=like.*shoe*` |
| In list | `field=in.(a,b,c)` | `status=in.(active,pending)` |
| Order | `order=field.asc` | `order=price.desc` |
| Limit | `limit=N` | `limit=20` |
| Offset | `offset=N` | `offset=40` |
| Select fields | `select=a,b,c` | `select=id,name,price` |

## Component patterns

### Product grid

```tsx
import { useEffect, useState } from 'react';
import { query } from './api';

interface Product {
  id: number;
  name: string;
  description: string;
  price: number;
  image_url: string;
}

function ProductGrid() {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    query<Product>('storefront_products', { order: 'name.asc' })
      .then(setProducts)
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <div className="loading">Loading...</div>;
  if (products.length === 0) return <div className="empty">No products yet.</div>;

  return (
    <div className="product-grid">
      {products.map(p => (
        <div key={p.id} className="product-card">
          {p.image_url && <img src={p.image_url} alt={p.name} />}
          <h3>{p.name}</h3>
          <p>{p.description}</p>
          <span className="price">${p.price.toFixed(2)}</span>
        </div>
      ))}
    </div>
  );
}
```

### Order / contact form

```tsx
import { useState } from 'react';
import { insert } from './api';

function ContactForm() {
  const [status, setStatus] = useState<'idle' | 'sending' | 'sent' | 'error'>('idle');

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setStatus('sending');
    const form = new FormData(e.currentTarget);
    try {
      await insert('contact_submissions', {
        name: form.get('name'),
        email: form.get('email'),
        message: form.get('message'),
      });
      setStatus('sent');
    } catch {
      setStatus('error');
    }
  }

  if (status === 'sent') return <p>Thanks! We'll be in touch.</p>;

  return (
    <form onSubmit={handleSubmit}>
      <input name="name" placeholder="Name" required />
      <input name="email" type="email" placeholder="Email" required />
      <textarea name="message" placeholder="Message" />
      <button type="submit" disabled={status === 'sending'}>
        {status === 'sending' ? 'Sending...' : 'Send'}
      </button>
      {status === 'error' && <p className="error">Something went wrong. Try again.</p>}
    </form>
  );
}
```

### Data list with filters

```tsx
function ProductList() {
  const [products, setProducts] = useState<Product[]>([]);
  const [category, setCategory] = useState('');

  useEffect(() => {
    const params: Record<string, string> = { order: 'name.asc' };
    if (category) params['category'] = `eq.${category}`;
    query<Product>('storefront_products', params).then(setProducts);
  }, [category]);

  return (
    <div>
      <select value={category} onChange={e => setCategory(e.target.value)}>
        <option value="">All categories</option>
        <option value="electronics">Electronics</option>
        <option value="clothing">Clothing</option>
      </select>
      {/* render products */}
    </div>
  );
}
```

## Store layout

A typical store page flows:

1. **Navbar** - Logo, category links, cart icon
2. **Hero/banner** - Featured product or promotion
3. **Product grid** - Cards with image, name, price
4. **Product detail** (if multi-page) - Full description, add to cart
5. **Cart** (client-side state) - Items, quantities, total
6. **Checkout form** - Name, email, shipping, submit order
7. **Footer** - About, contact, policies

## CSS for data-connected components

```css
.product-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 1.5rem;
  padding: 2rem;
}

.product-card {
  border: 1px solid var(--color-border, #e5e7eb);
  border-radius: 8px;
  overflow: hidden;
  transition: box-shadow 0.2s;
}

.product-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.product-card img {
  width: 100%;
  aspect-ratio: 4/3;
  object-fit: cover;
}

.loading, .empty {
  text-align: center;
  padding: 3rem;
  color: var(--color-text-muted, #6b7280);
}
```

## Design guidelines

Follow all guidelines from the web-design skill, plus:
- Always show a loading state while fetching data
- Show an empty state when there's no data
- Show error messages if API calls fail
- Use optimistic updates for better UX (update UI before server confirms)
- Keep cart/selection state in React state (client-side, no database needed)

## Local development

For local preview, the API won't be available (PostgREST runs on the server). Use mock data for previews:

```typescript
// src/api.ts — add at the top for local dev
const IS_LOCAL = window.location.hostname === 'localhost';

// In query():
if (IS_LOCAL) {
  return MOCK_DATA[view] || [];
}
```

Add a `src/mock-data.ts` file with sample data matching the database views. Remove or gate behind `IS_LOCAL` before deploying.
