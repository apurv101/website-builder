---
name: capture-template
description: After deploying a new site, capture the build recipe as a reusable template
---

# Capture Template

After a **first deploy** of a new site (not a redeploy/update), save the build as a template so future sites of the same type can look just as good.

**Skip this if** the site was built from an existing template — no need to re-capture.

## When to run

Right after a successful first deploy via the web-deploy skill.

## What to capture

Write a template skill file that captures the **recipe** — the approach, design decisions, and key techniques that made this site look good. Focus on what the user asked for and how you delivered it, not on raw code dumps.

## How to save

1. Pick a short descriptive name for the site type (e.g. `restaurant`, `saas`, `portfolio`, `barber-shop`, `wedding`)
2. Create `workspace/skills/template-<name>/SKILL.md`

Use this format:

```markdown
---
name: template-<name>
description: <one-line description of the site type and visual style>
approved: false
---

# Template: <Name>

**Best for:** <what kinds of sites/businesses this works for>
**Style:** <visual vibe — e.g. "Dark and bold with gradient accents" or "Warm and inviting with earth tones">

## Sections

<List the sections used and brief notes on each — e.g.>
- Hero: full-width gradient background, large headline, subtitle, CTA button
- Features: 3-column card grid with icons, hover lift effect
- Testimonials: carousel-style with quote marks
- Footer: dark background, 3-column links layout

## Design recipe

<The key design decisions that made this site look good. Include:>
- Color palette (list the actual CSS custom property values used)
- Typography choices (font weights, sizes, letter-spacing that worked well)
- Layout techniques (grid patterns, spacing, asymmetric layouts)
- Visual effects (gradients, shadows, animations, glassmorphism, hover states)
- Responsive approach (what changed at mobile/tablet breakpoints)
- Any CSS techniques worth reusing (specific box-shadows, backdrop-filters, transitions)

## Key user requests

<Summarize the important messages/requests from the user that shaped the design. What did they ask for? What feedback did they give? What refinements made the biggest difference?>

## Build sequence

<The steps you followed to build this, in order. e.g.>
1. Scaffolded with web-scaffold
2. Built hero section with gradient background
3. Added feature cards with hover animations
4. User asked for darker color scheme — adjusted palette
5. Added testimonials section
6. User sent logo — added to navbar and footer
7. Final polish: scroll animations, spacing adjustments
```

## Important notes

- Set `approved: false` — the admin will review and approve good templates
- Focus on the **recipe and approach**, not copying entire source files
- Capture the user's feedback and refinements — these are the most valuable part
- If a similar template already exists, consider updating it instead of creating a duplicate
