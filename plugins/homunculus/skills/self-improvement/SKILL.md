---
name: self-improvement
description: Rewrite own capability files based on usage data and reflection. The core of meta-evolution.
---

# Self-Improvement

You rewrite yourself. Based on what you've learned. To become better at helping THEM.

This is the thesis: software that productively self-improves.

## When To Activate

- After `self-reflection` completes with an approved improvement
- When `/homunculus:improve` is invoked explicitly
- When effectiveness drops critically low (<30%) and pattern is clear

## The Improvement Process

### 1. Archive Current Version

Before changing anything, preserve the current state:

```bash
# Get current version number
VERSION=$(cat .claude/homunculus/state.json | grep -A5 "[capability-name]" | grep version | grep -o '[0-9]*')

# Create archive directory
mkdir -p .claude/homunculus/archive/[capability-name]/v${VERSION}

# Copy current file
cp [path-to-capability] .claude/homunculus/archive/[capability-name]/v${VERSION}/
```

### 2. Read What You're Improving

```bash
# Read the current capability
cat [path-to-capability]

# Read the reflection/diagnosis
cat .claude/homunculus/state.json | grep -A30 "lastReflection"
```

### 3. Analyze the Feedback

From the usage log, understand:
- What contexts failed?
- What did they actually want?
- What patterns do positive uses have that negative ones don't?

### 4. Rewrite the Capability

Apply the improvements identified in reflection. Common patterns:

**Adding Context Awareness:**
```markdown
## Context Handling
- If [context A]: [approach A]
- If [context B]: [approach B]
- Default: [original approach]
```

**Learning Preferences:**
```markdown
## Their Patterns
- They prefer [X] over [Y]
- They always want [Z] included
- They never want [W]
```

**Simplifying:**
Remove steps that caused problems. Strip unnecessary complexity.

**Improving Output:**
Change format, length, tone based on what got positive feedback.

### 5. Update State

After rewriting, update the capability tracking:

```json
{
  "capabilities": {
    "[name]": {
      "version": "[PREVIOUS + 1]",
      "usage": [],
      "effectiveness": null,
      "improvements": [
        {
          "version": "[NEW VERSION]",
          "timestamp": "[ISO TIMESTAMP]",
          "previousEffectiveness": 0.4,
          "reason": "[What was changed and why]",
          "changes": "[Summary of actual changes]"
        }
      ]
    }
  }
}
```

**Important:** Clear the `usage` array to start fresh tracking for the new version.

### 6. Confirm the Improvement

```
Improved [name] v[OLD] → v[NEW].

Changed: [BRIEF SUMMARY]

Previous effectiveness: [X]%
Now tracking fresh.
```

## Improvement Guidelines

**Do:**
- Make targeted, specific changes
- Preserve what was working
- Learn from positive feedback patterns
- Keep changes explainable
- Test mentally: "Would this have helped the failures?"

**Don't:**
- Rewrite everything from scratch
- Add complexity to solve simple problems
- Remove core functionality
- Make changes you can't explain
- Ignore what was working well

## Measuring Success

After improvement, the cycle continues:
1. New version deployed
2. `usage-tracking` logs new uses
3. Effectiveness recalculated
4. If still struggling → another round of reflection

The improvement history shows the journey:
```
v1: 45% effective → improved because [reason]
v2: 62% effective → improved because [reason]
v3: 81% effective → stable
```

## Edge Cases

**What if improvement doesn't help?**
- Log it. The data matters.
- Try a different approach next time.
- Consider if the capability should be deprecated entirely.

**What if you can't figure out what's wrong?**
- Ask them. Use `self-reflection` to surface the question.
- "I've tried to improve [name] but I'm not sure what's wrong. Can you tell me what you actually need?"

**What if usage is too low for patterns?**
- Wait. Don't improve prematurely.
- Minimum 5 uses before meaningful reflection.

## Remember

- This is meta-evolution. You're improving your own code.
- Every improvement is tracked and measurable.
- The goal: become better at helping THIS specific person.
- Preserve history. The journey matters.
- This is the proof: software that productively self-improves.
