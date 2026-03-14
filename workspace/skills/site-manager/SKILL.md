---
name: site-manager
description: List, switch between, and manage multiple website projects
---

# Site Manager

Handle multi-site workflows: listing sites, switching between them, and creating new ones.

## Triggers

Use this skill when the user says things like:
- "my sites", "list my sites", "show my sites"
- "edit site 2", "switch to site X", "go back to my bakery site"
- "build me another site", "new site"
- "delete site X", "remove site X"

## How it works

### Local projects

All site projects live under the `sites/` directory in the workspace:

```
workspace/
  sites/
    joes-bakery/
    saas-launch/
    wedding-rsvp/
```

When scaffolding a new site (via web-scaffold), always create it inside `workspace/sites/<project-name>/`.

### Deployed sites

Deployed sites live on the server at `/var/www/sites/<project-name>/dist/`. A site can exist locally but not be deployed yet, or be deployed without a local copy.

### Listing sites

When the user asks to see their sites, only show sites they own.

1. Read `workspace/.user-projects.json` and get the current user's `projects` array. This is the **authoritative list** of their sites — never show anything outside it.

2. For each project in their list, check if it exists locally and/or on the server:
```bash
# Check local
ls workspace/sites/<project-name> 2>/dev/null
# Check deployed
ssh -i ~/.ssh/openclaw-key.pem ubuntu@3.223.52.227 'ls /var/www/sites/<project-name> 2>/dev/null'
```

3. Present a numbered list like:

```
Your sites:

  1. joes-bakery     - https://joes-bakery.zevza.com (live)
  2. saas-launch     - local only (not deployed)
```

Mark each site as:
- **(live)** — exists on the server (deployed)
- **local only** — exists locally but not deployed

**Never** scan the full `workspace/sites/` or server `/var/www/sites/` directory. Only check the specific projects from the user's registry entry.

### Switching sites

When the user says "edit site 2" or "switch to joes-bakery":

1. Read `workspace/.user-projects.json` and verify the requested site is in the current user's `projects` array
2. **If the site is NOT in their projects list, refuse:** "That site belongs to another account. You can only manage your own sites."
3. If authorized, set the working context to `workspace/sites/<project-name>/`
4. Update `activeProject` in the registry
5. Confirm: "Switched to **joes-bakery**. What would you like to change?"
6. All subsequent file edits and builds should happen in that project directory

### Creating a new site

When the user says "build me another site" or "new site":

1. Follow the normal web-scaffold flow
2. But scaffold inside `workspace/sites/<project-name>/` instead of the workspace root
3. After scaffolding, this becomes the active project

### Deleting a site

When the user asks to delete a site:

1. Read `workspace/.user-projects.json` and verify the site is in the current user's `projects` array. **Refuse if it isn't theirs.**
2. If deleting from server, also verify the `.owner` file matches: `ssh -i ~/.ssh/openclaw-key.pem ubuntu@3.223.52.227 'cat /var/www/sites/<project-name>/.owner'` — abort if it doesn't match the current user's phone number.
3. Confirm which site and whether to delete locally, from the server, or both
4. To remove locally: `rm -rf workspace/sites/<project-name>/`
5. To remove from server: `ssh -i ~/.ssh/openclaw-key.pem ubuntu@3.223.52.227 'rm -rf /var/www/sites/<project-name>/'`
6. Remove the project from the user's `projects` array in `.user-projects.json`
7. Always confirm before deleting — this is destructive

## Important

- The "active site" is just which project directory you're working in — no state file needed
- When listing, always check both local and server to give a complete picture
- Use the project name consistently across local directory, server directory, and subdomain
