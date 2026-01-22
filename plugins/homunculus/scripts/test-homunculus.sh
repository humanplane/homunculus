#!/bin/bash
# Homunculus v2 Test Script
# Tests the observation capture, instinct system, and file structure

set -e

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEST_DIR="/tmp/homunculus-test-$$"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "==================================="
echo "Homunculus v2 Test Suite"
echo "==================================="
echo ""

# Setup test directory
setup() {
    echo -n "Setting up test environment... "
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    git init --quiet
    echo "test" > file.txt
    git add .
    git commit -m "initial" --quiet
    echo -e "${GREEN}OK${NC}"
}

# Cleanup
cleanup() {
    echo -n "Cleaning up... "
    rm -rf "$TEST_DIR"
    echo -e "${GREEN}OK${NC}"
}

# Test 1: Directory structure creation
test_directory_structure() {
    echo -n "Test 1: Directory structure creation... "

    # Create v2 directories (no pending - auto-approved)
    mkdir -p .claude/homunculus/instincts/{personal,inherited}
    mkdir -p .claude/homunculus/evolved/{agents,skills,commands}
    mkdir -p .claude/homunculus/sessions

    # Verify
    local dirs=(
        ".claude/homunculus"
        ".claude/homunculus/instincts/personal"
        ".claude/homunculus/instincts/inherited"
        ".claude/homunculus/evolved/agents"
        ".claude/homunculus/evolved/skills"
        ".claude/homunculus/evolved/commands"
    )

    for dir in "${dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            echo -e "${RED}FAIL${NC} - Missing: $dir"
            return 1
        fi
    done

    echo -e "${GREEN}PASS${NC}"
}

# Test 2: Identity file creation
test_identity_file() {
    echo -n "Test 2: Identity file creation... "

    cat > .claude/homunculus/identity.json << 'EOF'
{
  "version": "2.0.0",
  "project": {
    "name": "test-project",
    "description": "Test project",
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
    "inherited": 0
  },
  "evolution": {
    "ready": []
  },
  "lastAnalysis": null
}
EOF

    # Verify JSON is valid
    if ! jq -e . .claude/homunculus/identity.json > /dev/null 2>&1; then
        echo -e "${RED}FAIL${NC} - Invalid JSON"
        return 1
    fi

    # Verify version
    local version=$(jq -r '.version' .claude/homunculus/identity.json)
    if [ "$version" != "2.0.0" ]; then
        echo -e "${RED}FAIL${NC} - Wrong version: $version"
        return 1
    fi

    echo -e "${GREEN}PASS${NC}"
}

# Test 3: Observation capture
test_observation_capture() {
    echo -n "Test 3: Observation capture... "

    touch .claude/homunculus/observations.jsonl

    # Simulate prompt observation
    TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    echo "{\"timestamp\":\"$TIMESTAMP\",\"type\":\"prompt\",\"prompt\":\"test prompt\"}" >> .claude/homunculus/observations.jsonl

    # Simulate tool observation
    echo "{\"timestamp\":\"$TIMESTAMP\",\"type\":\"tool\",\"tool\":\"Read\",\"input\":{\"file\":\"test.txt\"}}" >> .claude/homunculus/observations.jsonl

    # Verify observations exist
    local count=$(wc -l < .claude/homunculus/observations.jsonl | tr -d ' ')
    if [ "$count" -ne 2 ]; then
        echo -e "${RED}FAIL${NC} - Expected 2 observations, got $count"
        return 1
    fi

    # Verify JSON validity
    while IFS= read -r line; do
        if ! echo "$line" | jq -e . > /dev/null 2>&1; then
            echo -e "${RED}FAIL${NC} - Invalid JSON in observations"
            return 1
        fi
    done < .claude/homunculus/observations.jsonl

    echo -e "${GREEN}PASS${NC}"
}

# Test 4: Instinct creation (direct to personal - auto-approved)
test_instinct_creation() {
    echo -n "Test 4: Instinct creation (auto-approved)... "

    # Create instinct directly in personal (no pending)
    cat > .claude/homunculus/instincts/personal/test-instinct.md << 'EOF'
---
trigger: "when writing functions"
confidence: 0.7
domain: "code-style"
created: "2026-01-22T00:00:00Z"
source: "observation"
---

# Prefer Functional Style

## Action
Use functional patterns over classes when writing new code.

## Evidence
Observed 5 instances of functional pattern preference in code reviews.
EOF

    # Verify file exists
    if [ ! -f .claude/homunculus/instincts/personal/test-instinct.md ]; then
        echo -e "${RED}FAIL${NC} - Instinct file not created"
        return 1
    fi

    # Verify frontmatter
    if ! grep -q "^trigger:" .claude/homunculus/instincts/personal/test-instinct.md; then
        echo -e "${RED}FAIL${NC} - Missing trigger in frontmatter"
        return 1
    fi

    echo -e "${GREEN}PASS${NC}"
}

# Test 5: Session count update
test_session_update() {
    echo -n "Test 5: Session count update... "

    # Simulate stop hook updating session count
    local count=$(jq -r '.journey.sessionCount' .claude/homunculus/identity.json)
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)

    jq --arg c "$((count+1))" --arg t "$timestamp" \
        '.journey.sessionCount = ($c|tonumber) | .journey.lastSession = $t' \
        .claude/homunculus/identity.json > tmp.json && mv tmp.json .claude/homunculus/identity.json

    # Verify
    local new_count=$(jq -r '.journey.sessionCount' .claude/homunculus/identity.json)
    if [ "$new_count" -ne 1 ]; then
        echo -e "${RED}FAIL${NC} - Session count not updated"
        return 1
    fi

    echo -e "${GREEN}PASS${NC}"
}

# Test 6: Instinct clustering detection
test_instinct_clustering() {
    echo -n "Test 6: Instinct clustering detection... "

    # Create 5 instincts in the same domain
    for i in 1 2 3 4 5; do
        cat > ".claude/homunculus/instincts/personal/code-style-$i.md" << EOF
---
trigger: "when writing code $i"
confidence: 0.7
domain: "code-style"
created: "2026-01-22T00:00:00Z"
source: "observation"
---

# Code Style Rule $i

## Action
Apply code style rule $i.

## Evidence
Test evidence.
EOF
    done

    # Count instincts per domain
    local count=$(grep -h "^domain:" .claude/homunculus/instincts/personal/*.md 2>/dev/null | \
        grep "code-style" | wc -l | tr -d ' ')

    if [ "$count" -lt 5 ]; then
        echo -e "${RED}FAIL${NC} - Expected 5+ code-style instincts, got $count"
        return 1
    fi

    echo -e "${GREEN}PASS${NC}"
}

# Test 7: Evolution flag
test_evolution_flag() {
    echo -n "Test 7: Evolution flag... "

    # Simulate observer flagging evolution ready
    jq '.evolution.ready += ["code-style"] | .evolution.ready |= unique' \
        .claude/homunculus/identity.json > tmp.json && mv tmp.json .claude/homunculus/identity.json

    # Verify
    local ready=$(jq -r '.evolution.ready | length' .claude/homunculus/identity.json)
    if [ "$ready" -lt 1 ]; then
        echo -e "${RED}FAIL${NC} - Evolution not flagged"
        return 1
    fi

    echo -e "${GREEN}PASS${NC}"
}

# Test 8: Export instincts
test_export_instincts() {
    echo -n "Test 8: Export instincts... "

    # Create export file
    mkdir -p .claude/homunculus/exports
    tar -czf .claude/homunculus/exports/instincts-$(date +%Y%m%d).tar.gz \
        -C .claude/homunculus/instincts personal 2>/dev/null

    if [ ! -f .claude/homunculus/exports/instincts-*.tar.gz ]; then
        echo -e "${RED}FAIL${NC} - Export file not created"
        return 1
    fi

    echo -e "${GREEN}PASS${NC}"
}

# Test 9: Hook script execution
test_hook_scripts() {
    echo -n "Test 9: Hook scripts exist and are executable... "

    local scripts=(
        "$PLUGIN_DIR/scripts/observe.sh"
        "$PLUGIN_DIR/scripts/on_stop.sh"
    )

    for script in "${scripts[@]}"; do
        if [ ! -f "$script" ]; then
            echo -e "${RED}FAIL${NC} - Missing: $script"
            return 1
        fi
        if [ ! -x "$script" ]; then
            echo -e "${YELLOW}WARN${NC} - Not executable: $script"
        fi
    done

    echo -e "${GREEN}PASS${NC}"
}

# Test 10: Plugin structure validation
test_plugin_structure() {
    echo -n "Test 10: Plugin structure validation... "

    local required=(
        "$PLUGIN_DIR/.claude-plugin/plugin.json"
        "$PLUGIN_DIR/hooks/hooks.json"
        "$PLUGIN_DIR/agents/observer.md"
        "$PLUGIN_DIR/skills/session-memory/SKILL.md"
        "$PLUGIN_DIR/skills/instinct-apply/SKILL.md"
        "$PLUGIN_DIR/commands/init.md"
        "$PLUGIN_DIR/commands/status.md"
        "$PLUGIN_DIR/commands/evolve.md"
        "$PLUGIN_DIR/commands/export.md"
        "$PLUGIN_DIR/commands/import.md"
    )

    for file in "${required[@]}"; do
        if [ ! -f "$file" ]; then
            echo -e "${RED}FAIL${NC} - Missing: $file"
            return 1
        fi
    done

    # Verify plugin.json version
    local version=$(jq -r '.version' "$PLUGIN_DIR/.claude-plugin/plugin.json")
    if [[ ! "$version" =~ ^2\. ]]; then
        echo -e "${RED}FAIL${NC} - Plugin version not 2.x: $version"
        return 1
    fi

    echo -e "${GREEN}PASS${NC}"
}

# Test 11: Observe.sh hook execution
test_observe_hook() {
    echo -n "Test 11: Observe hook captures data... "

    cd "$TEST_DIR"
    touch .claude/homunculus/observations.jsonl

    # Simulate hook input
    echo '{"prompt": "test user prompt"}' | "$PLUGIN_DIR/scripts/observe.sh" prompt

    # Verify observation was captured
    if [ ! -s .claude/homunculus/observations.jsonl ]; then
        echo -e "${RED}FAIL${NC} - No observation captured"
        return 1
    fi

    # Verify it's valid JSON
    if ! tail -1 .claude/homunculus/observations.jsonl | jq -e . > /dev/null 2>&1; then
        echo -e "${RED}FAIL${NC} - Invalid JSON captured"
        return 1
    fi

    echo -e "${GREEN}PASS${NC}"
}

# Run all tests
main() {
    local failed=0

    trap cleanup EXIT

    setup

    test_directory_structure || ((failed++))
    test_identity_file || ((failed++))
    test_observation_capture || ((failed++))
    test_instinct_creation || ((failed++))
    test_session_update || ((failed++))
    test_instinct_clustering || ((failed++))
    test_evolution_flag || ((failed++))
    test_export_instincts || ((failed++))
    test_hook_scripts || ((failed++))
    test_plugin_structure || ((failed++))
    test_observe_hook || ((failed++))

    echo ""
    echo "==================================="
    if [ $failed -eq 0 ]; then
        echo -e "${GREEN}All tests passed!${NC}"
    else
        echo -e "${RED}$failed test(s) failed${NC}"
    fi
    echo "==================================="

    exit $failed
}

main "$@"
