#!/bin/bash
# Homunculus v2 Stop Hook
# Updates session count

set -e

STATE=".claude/homunculus/identity.json"
PENDING_DIR=".claude/homunculus/instincts/pending"

# Ensure directories exist
mkdir -p "$(dirname "$STATE")"
mkdir -p "$PENDING_DIR"

# Update session count
if [ -f "$STATE" ] && command -v jq >/dev/null 2>&1; then
  COUNT=$(jq -r ".journey.sessionCount // 0" "$STATE")
  TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  TMP=$(mktemp)

  jq --arg c "$((COUNT+1))" --arg t "$TIMESTAMP" \
    '.journey.sessionCount = ($c|tonumber) | .journey.lastSession = $t' \
    "$STATE" > "$TMP" && mv "$TMP" "$STATE"
fi

exit 0
