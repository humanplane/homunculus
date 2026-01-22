#!/bin/bash
# Homunculus v2 Observation Capture
# Append-only, non-blocking. Never fails (exit 0 always).

set -e

EVENT_TYPE="${1:-unknown}"
OBS_FILE=".claude/homunculus/observations.jsonl"

# Ensure directory exists
mkdir -p "$(dirname "$OBS_FILE")"

# Read input from stdin (hook data as JSON)
INPUT=$(cat)

# Get timestamp
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Build observation JSON based on event type
case "$EVENT_TYPE" in
  prompt)
    # UserPromptSubmit: capture user intent
    PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty' 2>/dev/null || echo "")
    if [ -n "$PROMPT" ]; then
      # Truncate long prompts to save space
      PROMPT_SHORT=$(echo "$PROMPT" | head -c 500)
      jq -nc --arg ts "$TIMESTAMP" --arg type "prompt" --arg prompt "$PROMPT_SHORT" \
        '{timestamp: $ts, type: $type, prompt: $prompt}' >> "$OBS_FILE"
    fi
    ;;
  tool)
    # PostToolUse: capture tool + result
    TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
    TOOL_INPUT=$(echo "$INPUT" | jq -c '.tool_input // {}' 2>/dev/null || echo "{}")
    TOOL_RESPONSE=$(echo "$INPUT" | jq -c '.tool_response // {}' 2>/dev/null || echo "{}")

    if [ -n "$TOOL_NAME" ]; then
      # Truncate response to avoid huge logs
      RESPONSE_SHORT=$(echo "$TOOL_RESPONSE" | head -c 1000)
      jq -nc --arg ts "$TIMESTAMP" --arg type "tool" --arg tool "$TOOL_NAME" \
        --argjson input "$TOOL_INPUT" --arg response "$RESPONSE_SHORT" \
        '{timestamp: $ts, type: $type, tool: $tool, input: $input, response: $response}' >> "$OBS_FILE" 2>/dev/null || \
      jq -nc --arg ts "$TIMESTAMP" --arg type "tool" --arg tool "$TOOL_NAME" \
        '{timestamp: $ts, type: $type, tool: $tool}' >> "$OBS_FILE"
    fi
    ;;
  *)
    # Unknown event type - still log it
    jq -nc --arg ts "$TIMESTAMP" --arg type "$EVENT_TYPE" --arg raw "$INPUT" \
      '{timestamp: $ts, type: $type, raw: $raw}' >> "$OBS_FILE" 2>/dev/null || true
    ;;
esac

# Always exit 0 - never block the session
exit 0
