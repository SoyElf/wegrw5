---
name: cli-modes-skill
description: "Quick entry point for understanding GitHub Copilot CLI modes (c-ask, c-plan, c-edit, c-agent) and how to select and use the right mode for your task."
keywords:
  - cli modes
  - c-ask c-plan c-edit c-agent
  - mode selection
  - task orchestration
  - copilot delegation
  - haiku sonnet opus
audience: "Orchestrators (like @ben), specialist agents, power users managing complex workflows"
prerequisites: "Basic familiarity with GitHub Copilot helpful; skill is self-contained and teaches from first principles"
difficulty: "Intermediate"
version: "1.0.0"
estimated_read_time: "20 minutes"
tags:
  - cli-modes
  - orchestration
  - copilot
  - agent-skills
  - beginner-friendly
status: "production"
---

# CLI Modes Skill

## Overview

GitHub Copilot's CLI mode system is your **primary mechanism for delegating work to agents and controlling task complexity**. This skill teaches you how to choose the right mode for any task—whether you're a human user automating workflows, an orchestrator like @ben delegating to specialists, or a specialist agent deciding how to execute delegated work.

The four modes—**c-ask** (fast analysis), **c-plan** (structured design), **c-edit** (scoped writing), and **c-agent** (autonomous execution)—form a **progressive escalation ladder**. Each mode comes with different safety guarantees, cost profiles, and reasoning capabilities. Choosing the right mode means:

- ✅ Solving problems most **safely and efficiently**
- ✅ Using the **appropriate reasoning level** (Haiku for quick diagnostics, Opus for complex workflows)
- ✅ Maintaining **clear governance** (read-only modes for analysis, scoped modes for bounded writes, approval gates for full autonomy)
- ✅ **Composing multiple modes** into reliable workflows

This skill is a **discovery entry point**, not a comprehensive reference. For detailed workflows, troubleshooting, and extended examples, see the comprehensive guide (linked below).

---

## When to Use This Skill

**Use this skill when you need to:**
- Select the right CLI mode for a task
- Understand what each mode can and cannot do
- Delegate work with clear mode guidance
- Decide between multiple execution approaches
- Learn core mental models for orchestration

**Skip if you already:**
- Know the four modes and when to use them
- Have specialist expertise in mode selection
- Are looking for extended workflows or troubleshooting (→ comprehensive guide instead)

---

## Entry Points

Since agents don't read linearly, choose your starting point:

### Quick Start: Decision Tree (5 min)

Jump to the [Mode Selection Decision Tree](#mode-selection-decision-tree) below to identify the right mode for your immediate task. If you need context, return to [Core Concepts](#core-concepts) afterward.

### Discovery Path: What Each Mode Does (10 min)

Read [Mode Overview](#mode-overview) to understand each mode's capabilities and limits, then use the [Mental Models](#mental-models) section to understand *why* the progression exists.

### Deep Dive: Complete Guide (20 min)

Start with [Mental Models](#mental-models) for conceptual foundation, then move through sections sequentially to build complete understanding of modes, safety, and delegation patterns.

### Problem-Solving Path: "How Do I...?" (varies)

- **"How do I explain code or diagnose an error?"** → c-ask mode in [Mode Overview](#mode-overview)
- **"How do I design a complex refactoring?"** → c-plan mode in [Mode Overview](#mode-overview)
- **"How do I safely edit files?"** → c-edit mode in [Mode Overview](#mode-overview)
- **"How do I run a multi-step workflow?"** → c-agent mode in [Mode Overview](#mode-overview)
- **"I'm delegating work to a specialist—which mode?"** → [Delegation Patterns](#delegation-patterns)

---

## Core Concepts

### Mental Models

Understanding four core mental models helps you make mode decisions intuitively.

#### 1. Progressive Escalation as Safety

The mode system implements **privilege escalation by design**. Each step up the ladder requires stronger justification:

```
c-ask          c-plan         c-edit              c-agent
(Read-only) → (Read-only) → (Scoped write) → (Full autonomy)
  Haiku         Sonnet         Sonnet              Opus
  Fastest       Balanced       Balanced            Most powerful
  Cheapest      Medium cost    Medium cost         Most expensive
  Lowest risk   Low risk       Medium risk         Highest risk + approval gate
```

**Philosophy**: If you can solve a problem safely at a lower escalation level, do so. Only escalate when necessary.

#### 2. Modes as Organizational Signals

When delegating, modes communicate **expected complexity** to specialists. A specialist with high confidence might bypass the CLI wrapper entirely, while a specialist lacking expertise invokes the exact mode you suggested.

**Key insight**: Modes guide decision-making, not direct execution. Specialists have autonomy to execute directly if they're confident.

#### 3. Scope as Boundary Control

Both **c-edit** and the `--scope` flag demonstrate how **boundaries create safety**. c-edit requires a `--scope` flag pointing to an **actual directory**. Modifications are prevented from exceeding that boundary.

**Pattern**: When you can't safely declare a scope, you can't safely use c-edit. Escalate to c-agent instead.

#### 4. Approval Gates as Governance

The c-agent confirmation gate isn't purely technical—it's **social control**. It forces conscious approval before autonomous execution and creates an audit trail. High-risk keywords (delete, deploy, push) trigger double-confirmation.

---

## Mode Overview

### c-ask: Fast Advisory (Read-Only Analysis)

**Best for**: Quick answers, explanations, diagnostics. Expected output time: < 5 minutes.

**Capabilities**: Code explanation, error diagnosis, architecture assessment, security review, quick decisions.

**Model**: Haiku 4.5 (fastest, cheapest)

**Safety**: Read-only by design—no files modified, no commands executed.

**Use when**: You need explanation or diagnostic, not implementation.

**Example**: `c-ask -p "What's wrong with this error stack trace?"` or `c-ask -p "Should we use Redis or Memcached for caching?"`

✅ **Use c-ask for**: Understanding problems, quick diagnostics, explaining code, decision guidance
❌ **Don't use if**: Task requires planning/structure (→ c-plan) or implementation (→ c-edit / c-agent)

---

### c-plan: Strategic Design (Structured Analysis)

**Best for**: Roadmaps, architecture design, breaking down complex problems. Structured output.

**Capabilities**: Implementation planning, phase breakdown, risk assessment, dependency identification, effort estimation.

**Model**: Sonnet 4.6 (balanced reasoning, higher cost than Haiku)

**Safety**: Read-only by design—no files modified, no commands executed.

**Use when**: You need to structure a complex task before execution, or design a solution.

**Example**: `c-plan -p "Create a refactoring roadmap for moving from sync to async/await"` or `c-plan -p "Design a CI/CD pipeline architecture"`

✅ **Use c-plan for**: Design decisions, refactoring roadmaps, feature planning, architecture proposals
❌ **Don't use if**: Simple answer suffices (→ c-ask) or ready to implement now (→ c-edit / c-agent)

---

### c-edit: Scoped File Editing (Bounded Write)

**Best for**: File modifications within a declared scope. Requires `--scope` flag pointing to actual directory.

**Capabilities**: Docstrings, type annotations, bug fixes, refactoring within bounds, documentation updates.

**Model**: Sonnet 4.6 (same level as c-plan)

**Safety**: Write permission limited to `--scope` directory. No shell execution, no commands.

**Critical rule**: `--scope` flag is **mandatory** and must point to an **existing directory**.

**Use when**: Modifications fit within a bounded scope and no shell commands are needed.

**Example**: `c-edit -p "Add docstrings to functions" --scope src/api/` or `c-edit -p "Fix type annotations in auth module" --scope src/auth/`

✅ **Use c-edit for**: Contained file edits, documentation updates, scoped refactoring
❌ **Don't use if**: Changes span multiple unrelated directories, scope path doesn't exist, or shell execution needed (→ c-agent)

---

### c-agent: Full Autonomy (Complex Workflows)

**Best for**: Multi-step workflows, complex orchestration, full tool access, state management.

**Capabilities**: Autonomous problem-solving, build systems, test runners, CI/CD setup, complex decision-making.

**Model**: Opus 4.6 (most powerful, highest cost)

**Safety**: Full tool access **except deny-list** (sudo, read-secrets, apt install, systemctl, etc.). **Approval gate required** before execution—user must explicitly approve.

**Critical rule**: Every c-agent invocation requires user approval. High-risk keywords (delete, deploy, push, chmod) trigger double-confirmation.

**Use when**: Task requires multi-step execution with conditional logic, or can't be decomposed into c-edit calls.

**Example**: `c-agent -p "Run test suite with coverage analysis and report results"` or `c-agent -p "Set up GitHub Actions workflow for CI/CD"`

✅ **Use c-agent for**: Multi-step orchestration, test automation, CI/CD setup, complex autonomous workflows
❌ **Don't use if**: Simple task solvable with c-ask/c-plan (→ use simpler mode) or can be safely scoped with c-edit (→ use c-edit)

---

## How to Use

### Mode Selection Decision Tree

```
START: What's your task?
│
├─ Need ANALYSIS ONLY (no execution)?
│  │
│  ├─ Simple, quick answer expected?
│  │  └─ YES → c-ask (Haiku)
│  │           Examples: explain code, diagnose error, quick decision
│  │
│  └─ Complex, needs decomposition/structure?
│     └─ YES → c-plan (Sonnet)
│              Examples: refactoring roadmap, CI/CD design, feature plan
│
└─ Need EXECUTION?
   │
   ├─ Can you declare a safe scope?
   │  │
   │  ├─ YES → c-edit (Sonnet, --scope REQUIRED)
   │  │        Conditions: scope path must exist, modifications contained
   │  │        Examples: add docstrings, fix type annotations, contained refactor
   │  │
   │  ├─ NO: Does execution require full autonomy + conditional logic?
   │  │  └─ YES → c-agent (Opus, approval-gated)
   │  │           Conditions: user must approve, high-risk keywords flagged
   │  │           Examples: test automation, CI/CD setup, complex workflow
   │  │
   │  └─ Can you split into multiple smaller c-edit calls?
   │     └─ YES → Use multiple c-edit calls (safer, more auditable)
   │     └─ NO → c-agent for full orchestration
```

### Quick Selection Rules

| Situation | Mode | Why |
|-----------|------|-----|
| Explain error or review code | c-ask | Quick diagnostic, read-only |
| Design refactoring strategy | c-plan | Structured planning, read-only |
| Add docstrings to src/api/ | c-edit | Scoped, safe, contained |
| Run multi-step test suite | c-agent | Multi-step autonomy needed |
| Diagnostic analysis for decision | c-ask | No implementation required |
| Feature planning with roadmap | c-plan | Structure and decomposition |
| Fix bugs in src/handlers/ | c-edit | Scoped, auditable changes |
| Set up CI/CD pipeline | c-agent | Complex orchestration, approval gate |

### Model Selection by Task Complexity

```
Speed/Cost Priority?        → Haiku (c-ask)
  Use when: Quick answer needed, cost matters, ~5min tasks

Balanced Reasoning Needed?   → Sonnet (c-plan or c-edit)
  Use when: Planning or scoped edits, structured output, medium complexity

Complex Autonomy Required?   → Opus (c-agent)
  Use when: Multi-step workflows, state management, full reasoning needed

Huge Context (>600K tokens)? → Gemini 3.1 Pro (escalate)
  Use when: Input exceeds Opus token limit, auto-escalation triggered
```

---

## Common Patterns

### Pattern 1: Analysis → Plan → Implementation

Complex tasks follow a three-phase approach:

1. **Phase 1: Analyze** (`c-ask`)
   - Understand current state, identify problems
   - Quick diagnostic, high-level assessment
   - Example: `c-ask -p "What are the current error handling gaps in auth module?"`

2. **Phase 2: Plan** (`c-plan`)
   - Design structured approach, decompose into steps
   - Identify risks, estimate effort, document dependencies
   - Example: `c-plan -p "Create refactoring roadmap for error handling improvements"`

3. **Phase 3: Implement** (`c-edit` or `c-agent`)
   - Execute plan using appropriate mode (scoped edits or full autonomy)
   - Example: `c-edit -p "Implement error handling improvements" --scope src/auth/`

**When to use**: Complex refactors, architecture changes, new feature development—anything requiring both planning and implementation.

### Pattern 2: Delegation with Mode Context

When orchestrators (like @ben) delegate to specialists:

```
Delegate to @SPECIALIST:

[Task statement with measurable success criteria]

Mode context (choose based on complexity):
- c-ask: Use for quick diagnostic of [aspect]
- c-plan: Use to structure [planning step]
- c-edit: Use to modify [specific files/scope]
- c-agent: Use for autonomous execution of [steps]

Deliverable: [Explicit output expected]
Success criteria: [Measurable outcomes]
```

**Specialist interpretation**: A specialist with high confidence executes directly (preferred). A specialist lacking expertise invokes the suggested CLI wrapper. Modes communicate expected complexity, not direct commands.

### Pattern 3: Safety Through Escalation

When a task is unclear, start with a lower escalation level and escalate only if needed:

1. Start with **c-ask**: Quick diagnostic, understand the problem
2. If answer is unclear, escalate to **c-plan**: Get structured analysis
3. If plan is complex and clear, use **c-edit**: Implement scoped pieces
4. If pieces can't be scoped safely, escalate to **c-agent**: Full orchestration

This approach minimizes risk by starting safely and escalating intentionally.

---

## Reference

### Approval Gate Protocol (c-agent Only)

**Single Confirmation** (low-risk keywords):
```bash
c-agent -p "Run test suite"
→ Approval prompt: "Proceed? (yes/no)"
→ User types: yes
→ [Executes]
```

**Double Confirmation** (high-risk keywords):
```bash
c-agent -p "Delete old log files"
→ Confirmation 1: "Proceed? (yes/no)"
→ User types: yes
→ Confirmation 2: "CONFIRM: Destructive operation (delete). Proceed? (yes/no)"
→ User types: yes
→ [Executes]
```

High-risk keywords: **delete, remove, destroy, drop, truncate** (data loss); **deploy, push, production** (impact); **chmod, chown** (permissions); **sudo** (escalation)

### c-edit Scope Rules

✅ **Valid**: `c-edit -p "Add docstrings" --scope src/api/`  
❌ **Invalid**: `c-edit -p "Add docstrings"` (no --scope)  
❌ **Invalid**: `c-edit -p "Add docstrings" --scope nonexistent/path/`  
✅ **Verify**: Run `ls -la src/api/` first to confirm path exists

### Safety Profiles Summary

| Mode | Read-Only? | Write-Only? | Scope | Model | Approval? |
|------|-----------|-----------|-------|-------|-----------|
| c-ask | ✅ Yes | ❌ No | N/A | Haiku | No |
| c-plan | ✅ Yes | ❌ No | N/A | Sonnet | No |
| c-edit | ❌ No | ✅ Yes | Required | Sonnet | No |
| c-agent | ❌ No | ❌ No (full access) | None | Opus | **Yes** |

---

## Delegation Patterns (For Orchestrators)

### When to Use Mode Hints in Delegation

**Mode hints communicate task complexity** to specialists:

- **c-ask hint**: "Quick diagnostic needed on [aspect]"—specialist does fast, read-only analysis
- **c-plan hint**: "Structure this complex task"—specialist creates roadmap with phases, risks, estimates
- **c-edit hint**: "Safe, scoped modification needed"—specialist executes changes within --scope boundary
- **c-agent hint**: "Full orchestration required"—specialist handles multi-step autonomy with explicit approval

**Specialist autonomy rule**: A specialist with high expertise executes directly (bypasses CLI wrapper). A specialist without specific expertise invokes the mode you hinted at.

### Pre-Delegation Checklist (For @ben)

Before delegating a c-agent task:
- [ ] Are high-risk keywords disclosed? (delete, deploy, push, chmod, sudo)
- [ ] Is user ready to approve? (understand approval gate will trigger)
- [ ] Are success criteria measurable? (clear when task completes)
- [ ] Is fallback strategy documented? (recovery if execution fails)
- [ ] Are dangerous operations avoided? (no sudo, read-secrets, unauthorized network access)

Before delegating any c-edit task:
- [ ] Does scope path exist? (verify with `ls -la`)
- [ ] Is scope tight? (not overly broad, specific directory)
- [ ] Are modifications contained? (don't spill outside scope)

---

## See Also

**Comprehensive Guide**: For detailed workflows, deep dives per mode, troubleshooting scenarios, and extended examples, see [CLI Mode Patterns & Orchestration Heuristics: Comprehensive Skill Guide](../../../../docs/guides/cli-modes-comprehensive-guide.md) (~25-30 min read).

**Research Backing**: For technical analysis of mode patterns and design rationale, see [Research: CLI Mode Patterns & Orchestration Heuristics](../../../../docs/research/cli-mode-patterns-research.md).

**Related Skills**:
- Agent orchestration and delegation patterns
- Task decomposition and planning
- Safety and approval workflows

**Related Documentation**:
- GitHub Copilot CLI mode specifications
- Ben (orchestrator) delegation guidelines
- Specialist agent execution patterns

---

## Document Information

| Field | Value |
|-------|-------|
| **Skill Name** | cli-modes-skill |
| **Version** | 1.0.0 |
| **Status** | Production |
| **Last Updated** | March 31, 2026 |
| **Audience** | Orchestrators, specialists, power users |
| **Read Time** | 20 minutes |
| **Word Count** | ~2,000 words |
