---
name: web-deploy
description: Deploy a site to Cloudflare Pages and assign a subdomain
---

# Web Deploy

When the user's site is ready to go live:

## 1. Build the project

```bash
cd <project-directory>
npm run build
```

Verify the `dist/` folder exists and contains `index.html`.

## 2. Deploy to Cloudflare Pages

```bash
npx wrangler pages project create <project-name> --production-branch main 2>/dev/null || true
npx wrangler pages deploy dist --project-name <project-name> --branch main
```

The project name must be URL-safe (lowercase, hyphens, no spaces). Use the same name from scaffolding.

## 3. Assign a custom subdomain

After the first deploy, add the subdomain:

```bash
npx wrangler pages project edit <project-name> --domains <project-name>.zevza.com
```

If the DNS record doesn't exist yet, create it:

```bash
# Get the zone ID for the domain
ZONE_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=zevza.com" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  -H "Content-Type: application/json" | python3 -c "import sys,json; print(json.load(sys.stdin)['result'][0]['id'])")

# Create CNAME record pointing to the Pages project
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{
    "type": "CNAME",
    "name": "<project-name>",
    "content": "<project-name>.pages.dev",
    "proxied": true
  }'
```

## 4. Tell the user

Once deployed, share the URL:
- **Live at:** `https://<project-name>.zevza.com`
- SSL is automatic via Cloudflare

## 5. Redeploying updates

If the user wants changes after the site is live, just rebuild and redeploy:

```bash
npm run build
npx wrangler pages deploy dist --project-name <project-name> --branch main
```

The subdomain stays the same. Updates are live in seconds.

## Important notes

- Every site is a separate Cloudflare Pages project
- The `CLOUDFLARE_API_TOKEN` environment variable must be set on the server
- The domain's DNS must be managed by Cloudflare (nameservers pointed to Cloudflare)
- HTTPS is automatic — no manual cert setup needed
