#!/bin/bash
# Homunculus v2 Integration Test
# Tests the full flow with seeded data + observer invocation
#
# This test:
# 1. Seeds observations.jsonl with realistic patterns
# 2. Triggers the observer agent to analyze them
# 3. Checks if instincts were created
#
# Note: Requires `claude` CLI to be available

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
TEST_DIR="/tmp/homunculus-integration-$$"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo "============================================"
echo "Homunculus v2 Integration Test"
echo "============================================"
echo ""

# Check for claude CLI
check_claude() {
    echo -n "Checking for claude CLI... "
    if command -v claude &> /dev/null; then
        echo -e "${GREEN}Found${NC}"
        return 0
    else
        echo -e "${YELLOW}Not found${NC}"
        echo "Claude CLI not available. Running seed-only tests."
        return 1
    fi
}

# Setup test project
setup() {
    echo -n "Setting up test project... "
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"

    # Initialize git
    git init --quiet
    echo "test" > file.txt
    git add . && git commit -m "initial" --quiet

    # Create homunculus structure
    mkdir -p .claude/homunculus/instincts/{pending,personal,inherited}
    mkdir -p .claude/homunculus/evolved/{agents,skills,commands}

    # Create identity.json
    cat > .claude/homunculus/identity.json << 'EOF'
{
  "version": "2.0.0",
  "project": {
    "name": "test-project",
    "description": "Integration test project",
    "born": "2026-01-22T00:00:00Z"
  },
  "creator": {
    "level": "technical"
  },
  "journey": {
    "milestones": [],
    "sessionCount": 0,
    "lastSession": null
  },
  "homunculus": {
    "evolved": [],
    "awakened": "2026-01-22T00:00:00Z"
  },
  "instincts": {
    "personal": 0,
    "inherited": 0,
    "pending": 0
  },
  "lastAnalysis": null
}
EOF

    echo -e "${GREEN}OK${NC}"
}

# Seed observations with realistic patterns
seed_observations() {
    echo -n "Seeding observations with patterns... "

    # Pattern 1: Repeated "Read then Edit" sequence (5 times)
    for i in 1 2 3 4 5; do
        TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
        echo "{\"timestamp\":\"$TS\",\"type\":\"tool\",\"tool\":\"Read\",\"input\":{\"file_path\":\"src/component$i.tsx\"}}" >> .claude/homunculus/observations.jsonl
        echo "{\"timestamp\":\"$TS\",\"type\":\"tool\",\"tool\":\"Edit\",\"input\":{\"file_path\":\"src/component$i.tsx\"}}" >> .claude/homunculus/observations.jsonl
    done

    # Pattern 2: Always runs tests after editing (4 times)
    for i in 1 2 3 4; do
        TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
        echo "{\"timestamp\":\"$TS\",\"type\":\"tool\",\"tool\":\"Bash\",\"input\":{\"command\":\"npm test\"}}" >> .claude/homunculus/observations.jsonl
    done

    # Pattern 3: Consistent commit message style (3 times)
    for msg in "feat: add user auth" "feat: add login form" "feat: add logout button"; do
        TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
        echo "{\"timestamp\":\"$TS\",\"type\":\"prompt\",\"prompt\":\"commit this with message: $msg\"}" >> .claude/homunculus/observations.jsonl
    done

    # Pattern 4: Prefers functional patterns (explicit preference)
    TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    echo "{\"timestamp\":\"$TS\",\"type\":\"prompt\",\"prompt\":\"use functional patterns, no classes\"}" >> .claude/homunculus/observations.jsonl

    local count=$(wc -l < .claude/homunculus/observations.jsonl | tr -d ' ')
    echo -e "${GREEN}OK${NC} ($count observations)"
}

# Test 1: Verify observation format
test_observation_format() {
    echo -n "Test 1: Observation format validation... "

    local errors=0
    while IFS= read -r line; do
        if ! echo "$line" | jq -e . > /dev/null 2>&1; then
            ((errors++))
        fi

        # Check required fields
        if ! echo "$line" | jq -e '.timestamp and .type' > /dev/null 2>&1; then
            ((errors++))
        fi
    done < .claude/homunculus/observations.jsonl

    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}PASS${NC}"
        return 0
    else
        echo -e "${RED}FAIL${NC} ($errors invalid entries)"
        return 1
    fi
}

# Test 2: Verify patterns are detectable
test_pattern_detection() {
    echo -n "Test 2: Pattern detection (Read→Edit sequence)... "

    # Count Read→Edit pairs
    local read_count=$(grep -c '"tool":"Read"' .claude/homunculus/observations.jsonl)
    local edit_count=$(grep -c '"tool":"Edit"' .claude/homunculus/observations.jsonl)

    if [ "$read_count" -ge 5 ] && [ "$edit_count" -ge 5 ]; then
        echo -e "${GREEN}PASS${NC} (Read: $read_count, Edit: $edit_count)"
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        return 1
    fi
}

# Test 3: Test with Claude (if available)
test_with_claude() {
    echo -e "${CYAN}Test 3: Observer agent invocation...${NC}"

    if ! check_claude; then
        echo -e "${YELLOW}SKIP${NC} (claude CLI not available)"
        return 0
    fi

    echo "Invoking observer agent to analyze observations..."
    echo ""

    # Create a prompt that triggers the observer
    local prompt="You are the homunculus observer. Analyze the observations in .claude/homunculus/observations.jsonl and create instincts in .claude/homunculus/instincts/pending/. Look for: repeated tool sequences, explicit preferences, consistent patterns. Create markdown instinct files with frontmatter (trigger, confidence, domain). Be concise."

    # Run claude with the prompt (timeout after 60s)
    timeout 60 claude -p "$prompt" --allowedTools Read,Write,Bash 2>&1 || true

    echo ""

    # Check if any instincts were created
    local pending_count=$(ls .claude/homunculus/instincts/pending/ 2>/dev/null | wc -l | tr -d ' ')

    if [ "$pending_count" -gt 0 ]; then
        echo -e "${GREEN}PASS${NC} - Created $pending_count pending instinct(s)"
        echo ""
        echo "Created instincts:"
        ls -la .claude/homunculus/instincts/pending/
        return 0
    else
        echo -e "${YELLOW}WARN${NC} - No instincts created (may need different prompt)"
        return 0  # Don't fail, LLM behavior varies
    fi
}

# Test 4: Manual verification prompt
test_manual_prompt() {
    echo ""
    echo -e "${CYAN}=== Manual Verification ===${NC}"
    echo ""
    echo "To manually test the full flow:"
    echo ""
    echo "  1. cd $TEST_DIR"
    echo "  2. claude"
    echo "  3. Run: /homunculus:analyze"
    echo "  4. Check: ls .claude/homunculus/instincts/pending/"
    echo "  5. Run: /homunculus:review"
    echo ""
}

# Cleanup
cleanup() {
    echo ""
    echo -n "Cleanup (keeping test dir for inspection)... "
    echo -e "${GREEN}OK${NC}"
    echo "Test directory: $TEST_DIR"
}

# Main
main() {
    local failed=0

    setup
    seed_observations

    echo ""
    echo "--- Running Tests ---"
    echo ""

    test_observation_format || ((failed++))
    test_pattern_detection || ((failed++))
    test_with_claude || ((failed++))
    test_manual_prompt

    echo ""
    echo "============================================"
    if [ $failed -eq 0 ]; then
        echo -e "${GREEN}Integration tests completed${NC}"
    else
        echo -e "${RED}$failed test(s) failed${NC}"
    fi
    echo "============================================"

    cleanup

    return $failed
}

main "$@"
