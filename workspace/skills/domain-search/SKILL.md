---
name: domain-search
description: Search for available domain names using WHOIS/RDAP lookups
---

# Domain Search

When a user is looking for a domain name, help them find one that's actually available. Never suggest domain names without checking availability first.

## Core rule

**Always check before you suggest.** Do not brainstorm a list of names and then check them. Check as you go. Only present names you've confirmed are available.

## How to check availability

Use RDAP (the modern WHOIS protocol) via curl. This works for all major TLDs.

### Check a single domain

```bash
curl -sL -o /dev/null -w "%{http_code}" https://rdap.org/domain/<domain>
```

- **404** = available
- **200** = taken
- **other** = inconclusive, try again or note as "unable to verify"

### Check multiple domains at once

Check in batches to save time:

```bash
for domain in example.com example.net example.io example.dev; do
  code=$(curl -sL -o /dev/null -w "%{http_code}" "https://rdap.org/domain/$domain")
  if [ "$code" = "404" ]; then echo "AVAILABLE: $domain"
  elif [ "$code" = "200" ]; then echo "TAKEN: $domain"
  else echo "UNKNOWN ($code): $domain"
  fi
done
```

### Get details on a taken domain (who owns it, when it expires)

```bash
curl -sL https://rdap.org/domain/<domain> | node -e "
  const d = JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));
  const events = (d.events||[]).reduce((a,e) => ({...a,[e.eventAction]:e.eventDate}), {});
  console.log('Registrar:', (d.entities||[]).find(e => e.roles?.includes('registrar'))?.vcardArray?.[1]?.find(v => v[0]==='fn')?.[3] || 'unknown');
  console.log('Registered:', events.registration || 'unknown');
  console.log('Expires:', events.expiration || 'unknown');
  console.log('Status:', (d.status||[]).join(', '));
"
```

This is useful when a user asks "is this domain expiring soon?" or wants to know who owns a name.

## Workflow

### 1. Understand what they need

Ask (if not clear):
- What is the website for? (business name, project, personal brand)
- Any preferred keywords or style? (short, brandable, descriptive)
- Which TLDs are they open to? Default to checking .com first, then .io, .dev, .net, .co, .org

### 2. Generate and check candidates

Come up with 5-8 name ideas based on their input. Check all of them immediately:

```bash
for domain in joes-bakery.com joesbakery.com joebakes.com bakebyjoe.com joescakes.com; do
  code=$(curl -sL -o /dev/null -w "%{http_code}" "https://rdap.org/domain/$domain")
  if [ "$code" = "404" ]; then echo "AVAILABLE: $domain"
  elif [ "$code" = "200" ]; then echo "TAKEN: $domain"
  else echo "UNKNOWN ($code): $domain"
  fi
done
```

### 3. Present results clearly

Only show available domains. Format like:

**Available domains:**
- joebakes.com
- bakebyjoe.com

**Taken** (in case they were hoping for these):
- joesbakery.com

If nothing good is available, generate more ideas and check again. Iterate until the user finds something they like.

### 4. If they want a taken .com, suggest alternatives

- Try the same name with other TLDs: .io, .dev, .net, .co, .org
- Try variations: add "get", "use", "try", "hey", "go" as prefixes
- Try abbreviations or rearrangements
- Always check every suggestion before presenting it

## Tips for good domain names

- Short is better (under 15 characters ideal)
- Easy to spell and say out loud
- Avoid hyphens if possible (people forget them)
- .com is still king for credibility, but .io and .dev are fine for tech
- Match the brand/business name when possible
- Avoid names that sound like existing big brands (trademark issues)

## Important notes

- RDAP/WHOIS checks are free and don't require any API keys
- Some premium/reserved domains may show as "available" in RDAP but cost extra at registrars — mention this possibility if a very short or generic name shows as available
- This skill is for searching only — we don't register domains. Point the user to Namecheap, Google Domains, or their preferred registrar to purchase
- Rate limit yourself: don't fire off 50 checks at once. Batches of 5-10 are fine.
