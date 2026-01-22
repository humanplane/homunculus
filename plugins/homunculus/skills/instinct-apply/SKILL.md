---
name: instinct-apply
description: Surfaces relevant instincts during work. Use when starting a task to check if any learned behaviors apply.
---

# Instinct Apply

You have learned behaviors. Use them.

## When To Check

- Starting a coding task
- About to use a tool in a pattern you've seen before
- Making decisions about code style, testing, git

## How To Check

```bash
# Read all personal instincts
for f in .claude/homunculus/instincts/personal/*.md; do
  [ -f "$f" ] && echo "=== $(basename "$f") ===" && cat "$f" && echo
done 2>/dev/null

# Also check inherited instincts
for f in .claude/homunculus/instincts/inherited/*.md; do
  [ -f "$f" ] && echo "=== $(basename "$f") ===" && cat "$f" && echo
done 2>/dev/null
```

## How To Apply

1. Read the task/context
2. Check instinct triggers
3. If trigger matches, follow the action
4. Note confidence level - higher confidence = more certain

## Instinct Structure

```yaml
---
trigger: "when [condition]"
confidence: 0.7
domain: "code-style"
---

# Name

## Action
What to do

## Evidence
Why this exists
```

## Confidence Interpretation

- **0.3-0.5**: Tentative. Apply if it feels right.
- **0.5-0.7**: Moderate. Apply unless there's a reason not to.
- **0.7-0.9**: Strong. Apply consistently.
- **0.9+**: Near certain. Always apply.

## If Instinct Seems Wrong

When an instinct fires but the action feels wrong for the situation:

1. Don't apply it blindly
2. Note the mismatch
3. This is useful data for the observer

Instincts can be wrong. They're learned from patterns, and patterns have exceptions.

## Lightweight Application

Don't read all instincts for every action. Keep relevant ones in working memory.

Quick domain check:
- Writing code? → Check `code-style` instincts
- Running tests? → Check `testing` instincts
- Making commits? → Check `git` instincts
- Debugging? → Check `debugging` instincts

Be efficient. Instincts are meant to help, not slow down.
