---
name: web-deploy
description: Deploy a site to the zevza.com server (static files + database migrations)
---

# Web Deploy

When the user's site is ready to go live, use the deploy script:

```bash
/home/node/.openclaw/workspace/scripts/site-deploy.sh <project-name>
```

This single command handles the entire deploy pipeline.

## What the script does

1. **Validates** the site name and project directory
2. **Applies database migrations** (if `migrations/*.sql` exist) via `migrate.js`
3. **Installs dependencies** with `NODE_ENV=development npm install`
4. **Type checks** with `npx tsc -b` — blocks deploy on type errors
5. **Builds** with `npm run build` — blocks deploy on build errors
6. **Validates build output**: checks for `dist/index.html`, JS/CSS bundles, and images
7. **Backs up** the current deployment (keeps last 3 backups)
8. **Copies** new `dist/` to `/var/www/sites/<project-name>/dist/`

## Handling failures

If the script exits with an error, it will tell you exactly what failed:

- **Type errors**: Fix the TypeScript errors shown in the output, then re-run
- **Build errors**: Fix the build errors, then re-run
- **Missing build output**: Check that `index.html`, JS bundles, and CSS are being generated. Rebuild if needed

The script blocks on errors — a broken build never reaches production.

## Rollback

If a deployed site has issues, restore the previous version:

```bash
/home/node/.openclaw/workspace/scripts/site-deploy.sh rollback <project-name>
```

This restores the most recent backup instantly.

## Redeploying updates

After making changes to a live site, just run the same deploy command again:

```bash
/home/node/.openclaw/workspace/scripts/site-deploy.sh <project-name>
```

The current deployment is automatically backed up before the new one goes live.

## After deploy

- **Live at:** `https://<project-name>.zevza.com`
- SSL is automatic via Let's Encrypt wildcard cert
- If the site has a database: API is available at `https://<project-name>.zevza.com/api/`

## Important notes

- Every site is a directory under `/var/www/sites/<project-name>/dist/`
- HTTPS is automatic — no manual cert setup needed
- No per-site DNS records required — the wildcard A record covers all subdomains
- Database migrations are tracked — each `.sql` file runs exactly once
- After deploying migrations, PostgREST automatically exposes new tables/views at `/api/`
