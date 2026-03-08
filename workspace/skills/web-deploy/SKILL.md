---
name: web-deploy
description: Deploy a site to the zevza.com server
---

# Web Deploy

When the user's site is ready to go live:

## 1. Build the project

**IMPORTANT:** The container has `NODE_ENV=production`, which skips devDependencies. Always override it for install and build.

```bash
cd <project-directory>
NODE_ENV=development npm install
NODE_ENV=development npm run build
```

Verify the `dist/` folder exists and contains `index.html`.

If the project uses user-provided images, verify they are present in `dist/`:
```bash
ls dist/images/   # Should contain all images from public/images/
```
If images are missing, rebuild or copy them manually into `dist/images/`.

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
NODE_ENV=development npm install
NODE_ENV=development npm run build
cp -r dist/* /var/www/sites/<project-name>/dist/
```

The subdomain stays the same. Updates are live instantly.

## Important notes

- Every site is a directory under `/var/www/sites/<project-name>/dist/`
- HTTPS is automatic — no manual cert setup needed
- No per-site DNS records required — the wildcard A record covers all subdomains
