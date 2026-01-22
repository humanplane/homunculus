---
description: Export instincts for sharing
---

# Export Instincts

Package your learned instincts for sharing with others.

## What Gets Exported

- Personal instincts (`.claude/homunculus/instincts/personal/`)
- Optionally: inherited instincts

Does NOT export:
- Observations (too personal, too large)
- Identity (bound to you)
- Pending instincts (not yet approved)

## Create Export

```bash
# Create exports directory
mkdir -p .claude/homunculus/exports

# Export personal instincts
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
EXPORT_FILE=".claude/homunculus/exports/instincts-$TIMESTAMP.tar.gz"

tar -czf "$EXPORT_FILE" \
  -C .claude/homunculus/instincts personal

echo "Exported to: $EXPORT_FILE"
ls -la "$EXPORT_FILE"
```

## Export with Metadata

For richer exports, create a manifest:

```bash
# Count instincts
PERSONAL_COUNT=$(ls .claude/homunculus/instincts/personal/ 2>/dev/null | wc -l | tr -d ' ')

# Get domains
DOMAINS=$(grep -h "^domain:" .claude/homunculus/instincts/personal/*.md 2>/dev/null | \
  sed 's/domain: "//' | sed 's/"//' | sort | uniq | tr '\n' ',' | sed 's/,$//')

# Create manifest
cat > .claude/homunculus/exports/manifest.json << EOF
{
  "exported": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "version": "2.0.0",
  "instincts": {
    "personal": $PERSONAL_COUNT
  },
  "domains": "$DOMAINS"
}
EOF

# Include manifest in export
tar -czf "$EXPORT_FILE" \
  -C .claude/homunculus/exports manifest.json \
  -C .claude/homunculus/instincts personal

rm .claude/homunculus/exports/manifest.json
```

## Voice

```
Exported [N] instincts to [FILE].

Domains covered: [LIST]

Share the file. Others can import with /homunculus:import.
```
