---
description: Import instincts from others
---

# Import Instincts

Adopt instincts shared by others.

## How It Works

Imported instincts go to `inherited/`, not `personal/`.

This keeps clear separation:
- `personal/` = learned from YOUR behavior
- `inherited/` = adopted from others

## Import From File

```bash
# User provides path to export file
IMPORT_FILE="$ARGUMENTS"

if [ ! -f "$IMPORT_FILE" ]; then
  echo "File not found: $IMPORT_FILE"
  exit 1
fi

# Extract to temp directory first
TEMP_DIR=$(mktemp -d)
tar -xzf "$IMPORT_FILE" -C "$TEMP_DIR"

# Show what we're importing
echo "=== Importing ==="
ls -la "$TEMP_DIR/personal/" 2>/dev/null

# Count
COUNT=$(ls "$TEMP_DIR/personal/" 2>/dev/null | wc -l | tr -d ' ')
echo ""
echo "Found $COUNT instincts to import."
```

Wait for confirmation before proceeding.

## On Confirmation

```bash
# Move to inherited (rename to avoid conflicts)
mkdir -p .claude/homunculus/instincts/inherited

for f in "$TEMP_DIR/personal/"*.md; do
  if [ -f "$f" ]; then
    BASENAME=$(basename "$f")
    # Add prefix to avoid conflicts
    DEST=".claude/homunculus/instincts/inherited/imported-$BASENAME"
    cp "$f" "$DEST"
  fi
done

# Cleanup
rm -rf "$TEMP_DIR"

# Count inherited
INHERITED=$(ls .claude/homunculus/instincts/inherited/ 2>/dev/null | wc -l | tr -d ' ')
echo "Imported. You now have $INHERITED inherited instincts."
```

## Update Identity

```bash
# Update counts
STATE=".claude/homunculus/identity.json"
INHERITED=$(ls .claude/homunculus/instincts/inherited/ 2>/dev/null | wc -l | tr -d ' ')

jq --arg i "$INHERITED" '.instincts.inherited = ($i|tonumber)' "$STATE" > tmp.json && mv tmp.json "$STATE"
```

## Voice

```
Importing [N] instincts from [FILE].

These will go to inherited/, not personal/.
You can review them anytime.

Proceed? (yes/no)
```

After import:
```
Done. [N] instincts inherited.

They'll apply alongside your personal instincts.
```
