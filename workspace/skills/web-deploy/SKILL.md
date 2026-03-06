---
name: web-deploy
description: Deploy a site to the zevza.com server
---

# Web Deploy

When the user's site is ready to go live:

## 1. Build the project

```bash
cd <project-directory>
npm run build
```

Verify the `dist/` folder exists and contains `index.html`.

## 2. Deploy to the server

Copy the built `dist/` directory to the server's sites directory:

```bash
mkdir -p /var/www/sites/<project-name>/dist
cp -r dist/* /var/www/sites/<project-name>/dist/
```

The project name must be URL-safe (lowercase, hyphens, no spaces). Use the same name from scaffolding.

The site is instantly live — no DNS setup needed per site. The wildcard `*.zevza.com` handles all subdomains automatically.

## 3. Tell the user

Once deployed, share the URL:
- **Live at:** `https://<project-name>.zevza.com`
- SSL is automatic via Let's Encrypt wildcard cert

## 4. Redeploying updates

If the user wants changes after the site is live, just rebuild and redeploy:

```bash
npm run build
cp -r dist/* /var/www/sites/<project-name>/dist/
```

The subdomain stays the same. Updates are live instantly.

## Important notes

- Every site is a directory under `/var/www/sites/<project-name>/dist/`
- HTTPS is automatic — no manual cert setup needed
- No per-site DNS records required — the wildcard A record covers all subdomains
