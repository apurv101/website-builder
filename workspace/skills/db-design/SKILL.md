---
name: db-design
description: Design databases and create SQL migrations for sites that need data storage
---

# Database Design

When a site needs to store or manage data (products, orders, posts, contacts, etc.):

## How it works

Each site gets its own PostgreSQL schema (`site_<name>`). Tables and views in the schema are automatically exposed as REST API endpoints via PostgREST at `/api/<table_or_view>`.

- **Tables** store data
- **Views** shape data for the frontend (filter columns, join tables, compute values)
- **Migrations** are versioned SQL files that evolve the schema over time

## Creating migrations

Put migration files in the site's `migrations/` directory:

```
<site-name>/
  src/
  migrations/
    001_create_products.sql
    002_add_orders.sql
    003_add_categories.sql
  package.json
```

### File naming

`NNN_description.sql` — 3-digit prefix for ordering, underscores in description. Each migration runs exactly once, tracked in the database.

### Migration rules

1. Always use `CREATE TABLE IF NOT EXISTS` and `CREATE OR REPLACE VIEW`
2. Never drop tables in a migration — create a new migration to alter instead
3. Read access (SELECT) on all tables and views is granted automatically — no GRANT needed for reads
4. Explicitly grant write access where the frontend needs it:
   ```sql
   GRANT INSERT ON orders TO web_anon;
   GRANT INSERT ON contact_submissions TO web_anon;
   ```
5. Don't grant UPDATE or DELETE to `web_anon` unless the frontend truly needs it
6. Don't qualify table names with schema — the migration runner sets the search path automatically

### Migration template

```sql
-- migrations/001_create_products.sql

CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL,
    stock INTEGER DEFAULT 0,
    image_url TEXT,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- View: only active, in-stock products for the storefront
CREATE OR REPLACE VIEW storefront_products AS
SELECT id, name, description, price, image_url
FROM products
WHERE active = true AND stock > 0;
```

## Schema design patterns

### E-commerce store

```sql
-- 001_create_store.sql

CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL,
    stock INTEGER DEFAULT 0,
    image_url TEXT,
    category TEXT,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    customer_name TEXT NOT NULL,
    customer_email TEXT NOT NULL,
    items JSONB NOT NULL,
    total NUMERIC(10,2) NOT NULL,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Public storefront view
CREATE OR REPLACE VIEW storefront_products AS
SELECT id, name, description, price, image_url, category
FROM products
WHERE active = true AND stock > 0;

-- Allow placing orders
GRANT INSERT ON orders TO web_anon;
GRANT USAGE, SELECT ON orders_id_seq TO web_anon;
```

### Blog / content site

```sql
-- 001_create_blog.sql

CREATE TABLE IF NOT EXISTS posts (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    content TEXT NOT NULL,
    excerpt TEXT,
    published BOOLEAN DEFAULT false,
    published_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Only published posts visible to readers
CREATE OR REPLACE VIEW published_posts AS
SELECT id, title, slug, content, excerpt, published_at
FROM posts
WHERE published = true
ORDER BY published_at DESC;
```

### Contact / lead capture

```sql
-- 001_create_contacts.sql

CREATE TABLE IF NOT EXISTS contact_submissions (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    message TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Allow form submissions
GRANT INSERT ON contact_submissions TO web_anon;
GRANT USAGE, SELECT ON contact_submissions_id_seq TO web_anon;
```

## Data types reference

| Use case | Type | Example |
|----------|------|---------|
| Money | `NUMERIC(10,2)` | `price NUMERIC(10,2)` |
| Timestamps | `TIMESTAMPTZ` | `created_at TIMESTAMPTZ DEFAULT NOW()` |
| Yes/no flags | `BOOLEAN` | `active BOOLEAN DEFAULT true` |
| Flexible data | `JSONB` | `metadata JSONB` |
| Auto-increment ID | `SERIAL` | `id SERIAL PRIMARY KEY` |
| Unique text key | `TEXT UNIQUE` | `slug TEXT UNIQUE NOT NULL` |

## After creating migrations

Deploy using the web-deploy skill. It automatically applies pending migrations before building the frontend.

To verify migrations were applied, you can check:
```bash
cd /home/node/.openclaw/workspace/scripts && node -e "
const { Client } = require('pg');
const c = new Client({ connectionString: process.env.DATABASE_URL });
c.connect()
  .then(() => c.query(\"SELECT * FROM applied_migrations WHERE site_name = '<site-name>' ORDER BY migration_name\"))
  .then(r => { console.table(r.rows); })
  .finally(() => c.end());
"
```

## How PostgREST schema routing works

Each site's data lives in its own schema (`site_<name>`). PostgREST dynamically discovers all `site_*` schemas via the `pgrst.pre_config()` function — no manual configuration needed.

The frontend selects which schema to query using the `Accept-Profile` header (for reads) and `Content-Profile` header (for writes). The `api.ts` helper in the frontend-design skill handles this automatically by deriving the schema name from the subdomain.

**You don't need to create proxy views or reference schema names in migrations.** Just create tables and views with unqualified names — the migration runner sets the search path automatically.

## Seed data with stock

If a view filters `WHERE stock > 0`, products with `stock = 0` (the default) won't appear. Always set stock explicitly when inserting seed data:

```sql
INSERT INTO products (name, price, stock) VALUES ('Widget', 29.99, 50);
```
