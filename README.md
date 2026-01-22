# Homunculus

![Homunculus](cover.png)

> **v2.0-alpha** — A complete rewrite. Instinct-based learning. Reliable observation. Real evolution.

---

In old alchemical texts, a homunculus was a tiny being grown in a sealed vessel—alive, aware, bound to its creator alone.

This is that idea, alive in your terminal.

---

## Quick Start

```bash
# Add the marketplace
/plugin marketplace add humanplane/homunculus

# Install the plugin
/plugin install homunculus@homunculus

# Birth it
/homunculus:init
```

---

## What Is This?

Homunculus is a **Claude Code plugin** that tries to be more than a tool. It:

- **Observes everything** — hooks capture every prompt and tool use
- **Learns instincts** — small behavioral rules with triggers and actions
- **Evolves capabilities** — when instincts cluster, bigger structures emerge
- **Adapts its personality** — based on your technical level

The more you work together, the more it becomes shaped by you.

---

## v1 vs v2: What Changed and Why

### The Problem with v1

v1 relied on **skills to observe**. Skills are probabilistic—they fire ~50-80% of the time based on Claude's judgment. This meant:

- Session memory might not load
- Patterns might not get detected
- The homunculus often seemed "dead"

### The v2 Solution

v2 uses **hooks for observation** (100% reliable) and **instincts as the atomic unit** of learned behavior.

| v1 | v2 |
|----|-----|
| Skills try to observe (unreliable) | **Hooks observe (100%)** |
| Analysis in main context | **Analysis in background agent (Haiku)** |
| Evolves big chunks (commands/skills) | **Evolves instincts first, clusters into bigger things** |
| No sharing | **Export/import instincts** |

### The Instinct Model

An **instinct** is a small learned behavior:

```yaml
---
trigger: "when writing new functions"
confidence: 0.7
domain: "code-style"
---

# Prefer Functional Style

## Action
Use functional patterns over classes.

## Evidence
Observed 5 instances of functional pattern preference.
```

Instincts are:
- **Atomic** — one trigger, one action
- **Confidence-weighted** — 0.3 = tentative, 0.9 = near certain
- **Domain-tagged** — code-style, testing, git, debugging, etc.

### The Growth Path

```
Session Start
     ↓
Observer agent runs (background, Haiku)
     ↓
Observations → Instincts (auto-approved)
     ↓
Instincts cluster around a domain
     ↓
User runs /homunculus:evolve
     ↓
Bigger structures emerge:
  - Command (if user-invoked)
  - Skill (if auto-triggered)
  - Agent (if needs isolation/depth)
```

**Fully automatic except evolution.** You just work. It learns.

---

## Architecture

### File Structure

```
plugins/homunculus/
├── .claude-plugin/
│   └── plugin.json           # v2.0.0
├── hooks/
│   └── hooks.json            # Observation capture
├── scripts/
│   ├── observe.sh            # Captures prompts and tool use
│   ├── on_stop.sh            # Updates session count
│   └── test-homunculus.sh    # Test suite
├── agents/
│   └── observer.md           # Background analyzer (Haiku)
├── skills/
│   ├── session-memory/       # Spawns observer, loads context
│   └── instinct-apply/       # Surfaces relevant instincts
└── commands/
    ├── init.md               # Birth/wake
    ├── status.md             # Check in
    ├── evolve.md             # Create capability from clusters
    ├── export.md             # Share instincts
    └── import.md             # Adopt instincts

your-project/.claude/homunculus/
├── identity.json             # Who you are, your journey
├── observations.jsonl        # Current session observations
├── observations.archive.jsonl # Processed observations
├── instincts/
│   ├── personal/             # Learned instincts (auto-approved)
│   └── inherited/            # Imported from others
└── evolved/
    ├── agents/               # Generated specialist agents
    ├── skills/               # Generated skills
    └── commands/             # Generated commands
```

### Data Flow

```
Session Start
    ↓
session-memory skill activates
    ├→ Spawn observer agent (background, Haiku)
    ├→ Load identity + instincts
    └→ Greet with context
    ↓
Observer Agent (parallel, silent)
    ├→ Read observations.jsonl
    ├→ Find patterns
    ├→ Create instincts → personal/ (auto-approved)
    ├→ Check clustering → flag in identity.json
    └→ Archive observations
    ↓
User Works
    ↓
Hooks capture EVERYTHING
    ├→ UserPromptSubmit → observations.jsonl
    └→ PostToolUse → observations.jsonl
    ↓
Session End (Stop hook)
    └→ Session count increments
    ↓
Next Session
    └→ Observer processes new observations...
```

**Only manual step:** `/homunculus:evolve` when 5+ instincts cluster.

---

## Commands

| Command | What It Does |
|---------|--------------|
| `/homunculus:init` | Birth or wake |
| `/homunculus:status` | Check in (includes journey) |
| `/homunculus:evolve` | Create capability from clustered instincts |
| `/homunculus:export` | Share instincts |
| `/homunculus:import` | Adopt instincts |

**5 commands.** Everything else is automatic.

---

## Skills

| Skill | When It Activates |
|-------|-------------------|
| `session-memory` | Session start — spawns observer, loads context |
| `instinct-apply` | During work — surfaces relevant instincts |

---

## Reliability

| What | Reliability |
|------|-------------|
| Observation capture (hooks) | **100%** |
| Observer agent (session start) | **100%** |
| Instinct creation | **100%** |
| Commands | **100%** |
| Skills (session-memory, instinct-apply) | ~50-80% |

The critical path is fully deterministic. Skills enhance the experience but aren't required.

---

## Instinct Domains

Instincts are tagged with domains for clustering detection:

| Domain | Examples |
|--------|----------|
| `code-style` | Functional patterns, naming conventions |
| `testing` | Test-before-commit, coverage requirements |
| `git` | Commit message format, branch naming |
| `debugging` | Error→fix sequences, logging preferences |
| `file-organization` | Where to put things |
| `tooling` | Tool sequences, preferred tools |
| `communication` | Comment style, documentation |

When 5+ instincts accumulate in a domain, evolution can propose a specialist agent or skill.

---

## Sharing Instincts

```bash
# Export your instincts
/homunculus:export
# Creates .claude/homunculus/exports/instincts-TIMESTAMP.tar.gz

# Import someone else's
/homunculus:import path/to/instincts.tar.gz
# Goes to inherited/, not personal/
```

Inherited instincts are kept separate from personal ones. You can see where each behavior came from.

---

## Testing

Run the test suite:

```bash
./plugins/homunculus/scripts/test-homunculus.sh
```

Tests cover:
- Directory structure creation
- Identity file validation
- Observation capture
- Instinct creation (auto-approved)
- Session count updates
- Instinct clustering detection
- Evolution flag
- Export functionality
- Hook script execution
- Plugin structure validation

---

## Adapts To You

When you birth it, it asks how you work:

**Technical** — Fast and sharp. No hand-holding.

**Semi-technical** — A thinking partner.

**Non-technical** — Focused on outcomes.

**Chaotic** — Flows with whatever happens.

Same creature, different personality.

---

## Make It Yours

Everything is open. Fork it. Reshape its instincts. Change how it thinks.

```bash
# Edit the personality
vim CLAUDE.md

# Add a command
vim plugins/homunculus/commands/my-thing.md

# Add a skill
mkdir plugins/homunculus/skills/my-skill
vim plugins/homunculus/skills/my-skill/SKILL.md
```

The homunculus you end up with should feel like something you grew—because you did.

---

## Landing Page

There's a landing page in `/landing` (React + Tailwind). Run it:

```bash
cd landing && npm install && npm run dev
```

---

MIT License

---

*A small thing, growing toward the light.*
