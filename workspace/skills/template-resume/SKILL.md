---
name: template-resume
description: Personal resume or CV site — clean structured layout, timeline, skills bars, professional
approved: false
---

# Template: Resume / CV

**Best for:** Job seekers, professionals, consultants, freelancers wanting an online resume
**Style:** Clean, structured, and professional with clear information hierarchy and scannable layout

## Sections

1. **Header/hero** — Name in large clean type, job title/tagline below. Contact info row: email, phone, location, LinkedIn. Optional: professional headshot on the right side. Clean background, no heavy imagery.
2. **Summary** — 2-3 sentence professional summary. Centered or left-aligned. Sets the narrative for the page.
3. **Experience** — Vertical timeline of positions. Each entry: company name + logo area, job title, date range (right-aligned), 3-4 bullet points of achievements. Most recent first. Thin timeline line on the left connecting entries.
4. **Skills** — Visual skill display: categorized groups (Frontend, Backend, Tools, Soft Skills). Each skill as a tag/pill, or a simple list. Keep it scannable. Optional: proficiency bars or dot indicators.
5. **Education** — Simpler than experience: school name, degree, dates, honors. 1-2 entries max.
6. **Projects** — 2-3 notable side projects or portfolio pieces. Each: title, short description, tech stack tags, link. Small cards in a row.
7. **Contact CTA** — "Let's connect" with email link prominent, social links (LinkedIn, GitHub, Twitter). Simple form optional.
8. **Footer** — Minimal: "Built with React" or similar, copyright, download resume PDF link.

## Design recipe

### Colors
```css
:root {
  --color-bg: #ffffff;
  --color-surface: #f8fafc;
  --color-primary: #2563eb;
  --color-text: #0f172a;
  --color-text-muted: #64748b;
  --color-border: #e2e8f0;
  --color-tag-bg: #eff6ff;
  --color-tag-text: #2563eb;
  --color-timeline: #cbd5e1;
}
```

### Typography
- Name: 2.5-3rem, font-weight 800, letter-spacing -0.02em
- Job title: 1.25rem, font-weight 400, color text-muted
- Section titles: 1.5rem, font-weight 700, with thin bottom border
- Company names: 1.125rem, font-weight 600
- Job titles (in timeline): 1rem, font-weight 500, color primary
- Body/bullets: 0.95rem, line-height 1.6
- Dates: 0.875rem, color text-muted, right-aligned
- Everything sans-serif — professional and modern

### Visual effects
- **Timeline**: thin vertical line (`border-left: 2px solid var(--color-timeline)`) with small circles at each entry (pseudo-elements)
- **Skill tags**: rounded pills with light primary background and primary text color
- **Section transitions**: subtle border-bottom on section titles for structure
- **Hover on project cards**: subtle shadow + translateY -2px
- **Link hover**: primary color with underline
- **Print-friendly**: add `@media print` styles that clean up for PDF printing
- **Clean, no animations** — this is a professional document, not a showcase

### Layout
- Max-width 800px, centered — document-like width for readability
- Single column primary, with sidebar option (name+photo+contact left, content right)
- Experience entries: flex row with date right-aligned, content left
- Skills: flex-wrap for tag pills, grouped by category
- Projects: 3-column grid or single column list
- Section spacing: 3rem between sections
- Tight, efficient use of space — like a well-formatted resume

### Responsive
- 768px: remove sidebar if using one, stack to single column
- Dates move from right-aligned to above the content
- Skills tags wrap naturally
- Max-width becomes 100% with padding on mobile
