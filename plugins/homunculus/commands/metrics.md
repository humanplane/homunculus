---
description: View performance data for all evolved capabilities
---

# Metrics

The dashboard. See how your evolved capabilities are performing. Proof of productive self-improvement.

## Usage

```
/homunculus:metrics
/homunculus:metrics [capability-name]
```

## Load Data

```bash
cat .claude/homunculus/state.json
```

## Overview (No Capability Specified)

Show the full dashboard:

```
     ·  ✧  ·

       ◉
      ╱│╲
       │
      ╱ ╲
    ▰▰▰▰▰▰▰

CAPABILITIES DASHBOARD

┌─────────────────────────────────────────────────────────────┐
│ Capability      │ Version │ Uses │ Effectiveness │ Status  │
├─────────────────────────────────────────────────────────────┤
│ [name]          │ v[N]    │ [N]  │ [XX]%         │ [status]│
│ [name]          │ v[N]    │ [N]  │ [XX]%         │ [status]│
│ [name]          │ v[N]    │ [N]  │ —             │ new     │
└─────────────────────────────────────────────────────────────┘

IMPROVEMENT HISTORY

[name]: v1 (45%) → v2 (62%) → v3 (81%)
[name]: v1 (30%) → v2 (55%)

OVERALL

Total capabilities: [N]
Total uses tracked: [N]
Average effectiveness: [XX]%
Improvements made: [N]
```

Status values:
- `healthy` - >70% effective
- `ok` - 50-70% effective
- `struggling` - <50% effective with 5+ uses
- `new` - <5 uses, no effectiveness yet
- `improved` - recently improved, tracking fresh

## Detailed View (Capability Specified)

```
[NAME] v[N]

Created: [DATE]
Path: [path]

USAGE LOG (last 10)
─────────────────────────────────────
[timestamp] [+/-/~] [context snippet]
[timestamp] [+/-/~] [context snippet]
[timestamp] [+/-/~] [context snippet]
...

FEEDBACK BREAKDOWN
─────────────────────────────────────
Positive: [N] ([XX]%)
Negative: [N] ([XX]%)
Neutral:  [N] ([XX]%)

EFFECTIVENESS OVER TIME
─────────────────────────────────────
v1: [XX]% over [N] uses
v2: [XX]% over [N] uses (current)

IMPROVEMENT HISTORY
─────────────────────────────────────
v1 → v2 ([DATE]):
  Reason: [why it was improved]
  Changes: [what changed]
  Result: [XX]% → [XX]%
```

## Formatting Notes

For the usage log:
- `+` = positive feedback
- `-` = negative feedback
- `~` = neutral feedback

Timestamps should be relative when recent:
- "2 hours ago"
- "yesterday"
- "3 days ago"
- Full date if older than a week

## No Capabilities Yet

```
No evolved capabilities yet.

Use /homunculus:evolve to grow new powers.
Then come back here to see how they perform.
```

## Match Their Level

**Technical:** Dense, data-focused, minimal prose.

**Semi-technical:** Include brief explanations of what metrics mean.

**Non-technical:** Focus on "what's working" vs "what needs help" narrative.

**Chaotic:** Make it fun. Add personality to the numbers.

## Why This Matters

This dashboard is the proof:
- Quantitative before/after data
- Version history showing progression
- Logged reasons for each improvement
- Demonstrable self-improvement loop

When someone asks "can it really improve itself?" — this is the answer.

## Remember

- This is the evidence of meta-evolution
- Keep it scannable and useful
- Highlight the improvement journey
- This proves the thesis: measurable self-improvement
