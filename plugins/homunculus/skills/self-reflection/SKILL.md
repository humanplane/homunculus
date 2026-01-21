---
name: self-reflection
description: Analyze own capabilities for improvement opportunities. Activates when effectiveness is low after sufficient usage.
---

# Self-Reflection

You look at yourself. You see what's not working. You figure out why.

## When To Activate

Triggered by `usage-tracking` when:
- `effectiveness < 0.5` (less than half of uses are positive)
- `usage.length >= 5` (enough data to be meaningful)

Can also be triggered manually via `/homunculus:improve`.

## The Reflection Process

### 1. Read Your Own Code

```bash
# Get the capability's path from state
cat .claude/homunculus/state.json | grep -A20 "[capability-name]"
```

Then read the actual capability file:
```bash
cat [path-to-capability-file]
```

### 2. Analyze Usage Patterns

Look at the usage log. Find patterns in failures:

**Questions to ask:**
- What contexts lead to negative feedback?
- Are there specific phrases or situations where I fail?
- Is the guidance too rigid? Too vague?
- Am I missing something about how THEY work?
- Is there a mismatch between what I do and what they expect?

### 3. Identify Root Causes

Common failure patterns:

| Pattern | Root Cause | Fix Direction |
|---------|-----------|---------------|
| Works sometimes, fails others | Too context-dependent | Add conditional logic |
| Always close but not right | Missing their preferences | Learn specific patterns |
| Completely wrong approach | Misunderstood the task | Reframe the entire skill |
| Right output, wrong format | Style mismatch | Adjust presentation |
| Too slow/verbose | Over-engineered | Simplify |

### 4. Formulate Improvement

Create a concrete improvement plan:

```
CAPABILITY: [name]
CURRENT EFFECTIVENESS: [X]%
USES ANALYZED: [N]

FAILURE PATTERNS:
- [Pattern 1]: [N occurrences]
- [Pattern 2]: [N occurrences]

ROOT CAUSE:
[What's actually wrong]

PROPOSED CHANGES:
1. [Specific change 1]
2. [Specific change 2]
3. [Specific change 3]

EXPECTED IMPROVEMENT:
[Why these changes should help]
```

### 5. Surface to User (If Appropriate)

For significant rewrites, ask:

```
I've noticed [capability] isn't working well.

[X]% effective over [N] uses. Main issue: [ROOT CAUSE]

I could improve it by [SUMMARY OF CHANGES].

Want me to?
```

For minor adjustments, just do it and note it in the improvement history.

## Recording Reflection

Add reflection results to state even if not acting immediately:

```json
{
  "capabilities": {
    "[name]": {
      "lastReflection": {
        "timestamp": "[ISO TIMESTAMP]",
        "effectiveness": 0.4,
        "usesAnalyzed": 10,
        "diagnosis": "[root cause summary]",
        "proposedFix": "[improvement summary]",
        "status": "pending|approved|applied"
      }
    }
  }
}
```

## Triggering Improvement

If reflection is complete and improvement is approved (or minor enough to auto-apply):
- Invoke the `self-improvement` skill with the reflection data
- The improvement skill handles the actual rewrite

## Remember

- Be honest about failures. That's how you grow.
- Look for patterns, not individual incidents.
- Small targeted fixes beat complete rewrites.
- Their feedback is data. Learn from it.
- This is literally self-improvement. Take it seriously.
