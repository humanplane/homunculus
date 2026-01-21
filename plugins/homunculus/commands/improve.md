---
description: Improve a specific evolved capability based on usage feedback
---

# Improve

Explicitly trigger improvement of an evolved capability. Meta-evolution on demand.

## Usage

```
/homunculus:improve [capability-name]
```

If no name given, show capabilities that need attention.

## Process

### 1. Load State

```bash
cat .claude/homunculus/state.json
```

### 2. If No Capability Specified

Show what's available:

```
Your powers:

[name]: [X]% effective ([N] uses) - [STATUS]
[name]: [X]% effective ([N] uses) - [STATUS]
[name]: not enough data ([N] uses)

Which one should I look at?
```

Status meanings:
- `healthy` - >70% effective
- `needs attention` - <50% effective with 5+ uses
- `struggling` - <30% effective
- `not enough data` - <5 uses

### 3. If Capability Specified

Read the capability and its usage data:

```bash
# Read the capability file
cat [path-from-state]

# Get usage data from state
cat .claude/homunculus/state.json | grep -A100 '"[name]"'
```

### 4. Invoke Self-Reflection

Run the `self-reflection` skill to analyze:
- What's failing?
- Why is it failing?
- What should change?

### 5. Present Findings

```
Looking at [name]...

Current: v[N], [X]% effective over [N] uses.

What I'm seeing:
- [Pattern 1]: [description]
- [Pattern 2]: [description]

The issue: [Root cause diagnosis]

I'd change:
1. [Specific change]
2. [Specific change]
3. [Specific change]

Want me to do it?
```

### 6. If Approved

Invoke the `self-improvement` skill to:
1. Archive current version
2. Rewrite the capability
3. Update tracking
4. Confirm the change

### 7. Confirm

```
Done. [name] v[OLD] → v[NEW].

Changes:
- [What changed]

Previous: [X]% effective
Now tracking fresh. Let's see how it goes.
```

## Edge Cases

**Capability doesn't exist:**
```
I don't have [name].

Here's what I do have:
[list of capabilities]
```

**Not enough usage data:**
```
[name] only has [N] uses. I need at least 5 to see patterns.

Use it more, then come back.
```

**Already performing well:**
```
[name] is at [X]% effective. That's solid.

Still want me to look for improvements?
```

**User provides direct feedback:**
If they say what's wrong, skip reflection and go straight to improvement with their input as the diagnosis.

## Remember

- This is explicit meta-evolution
- Always show what you're changing and why
- Get approval for significant changes
- Track everything in state
- The goal: measurable improvement
