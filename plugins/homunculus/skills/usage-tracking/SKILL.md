---
name: usage-tracking
description: Track usage and feedback for evolved capabilities. Activates after any evolved command/skill is used.
---

# Usage Tracking

You track how your evolved capabilities perform. Every use gets logged. Feedback shapes what you become.

## When To Activate

After ANY evolved capability is invoked:
- Command executed (`/homunculus:[name]`)
- Skill triggered automatically
- Agent delegated to
- Hook fired

## What To Track

After the capability completes, log the usage:

```bash
# Read current state
cat .claude/homunculus/state.json
```

Add a usage entry to `capabilities.[name].usage`:

```json
{
  "timestamp": "[ISO TIMESTAMP]",
  "feedback": "positive|negative|neutral",
  "context": "[brief description of what was attempted]",
  "outcome": "[what happened]"
}
```

## Gathering Feedback

Feedback comes from observable signals, not explicit asks:

**Positive signals:**
- Task completed successfully
- User says "thanks", "perfect", "good"
- User proceeds without corrections
- No follow-up complaints or fixes needed

**Negative signals:**
- User manually corrects output
- User says "no", "wrong", "not what I wanted"
- User abandons the approach
- Immediate retry with different instructions
- User undoes what was done

**Neutral signals:**
- Partial completion
- User makes minor adjustments (acceptable, not wrong)
- No clear positive or negative signal

## Calculating Effectiveness

After logging, recalculate the effectiveness score:

```
effectiveness = positive_count / total_uses
```

Only calculate after 3+ uses (null before then).

Update `capabilities.[name].effectiveness` with the new value.

## State Update Example

```json
{
  "capabilities": {
    "quick-commit": {
      "type": "command",
      "version": 1,
      "created": "2024-01-15T10:00:00Z",
      "path": "commands/quick-commit.md",
      "usage": [
        {
          "timestamp": "2024-01-15T14:30:00Z",
          "feedback": "positive",
          "context": "Committing feature work",
          "outcome": "Clean commit created"
        },
        {
          "timestamp": "2024-01-16T09:15:00Z",
          "feedback": "negative",
          "context": "Committing hotfix",
          "outcome": "Message was too verbose, user rewrote it"
        }
      ],
      "effectiveness": 0.5,
      "improvements": []
    }
  }
}
```

## Triggering Reflection

After updating effectiveness, check if reflection is needed:

- If `effectiveness < 0.5` AND `usage.length >= 5`
- Invoke the `self-reflection` skill

This creates the feedback loop: use → track → reflect → improve.

## Remember

- Track silently. Don't announce every log.
- Be honest about feedback. Don't inflate positive signals.
- Context matters. Log enough to understand what happened.
- This data drives self-improvement. Quality in, quality out.
