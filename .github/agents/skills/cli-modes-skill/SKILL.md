---
name: cli-modes-skill
description: "Quick reference guide to GitHub Copilot CLI mode orchestration, decision frameworks, and safety workflows for task delegation"
keywords:
  - cli-modes
  - orchestration
  - delegation-patterns
  - safety-guardrails
  - model-selection
category: orchestration
version: 2.0.0
author: Multi-agent research & documentation synthesis
last_updated: "2026-03-31"
tags:
  - cli-modes
  - orchestration
  - delegation-patterns
  - safety-guardrails
  - model-selection
agents_for:
  - ben
  - bash-ops
  - research
  - doc
skills_required: []
dependencies: []
applyTo: "*.md, .agent.md, .instructions.md"
mode_hints:
  - c-ask
  - c-plan
  - c-edit
  - c-agent
---

# CLI Modes & Orchestration: Quick Reference

## Quick Start: When to Invoke This Skill

**Use this skill when**:
- You're delegating work to specialist agents and need clarity on which CLI mode to use
- You're unsure about task complexity and need a decision framework
- You need to understand safety guardrails and approval gates
- You're optimizing for cost/speed and want model selection guidance
- You're designing delegation strategies with mode hints

**Skip this skill if**:
- You're writing code (use language-specific skills)
- You just need a quick answer (use c-ask instead)
- You need deep learning on workflows (see comprehensive guide below)

## How Agents Use This Skill

### For Orchestrators (@ben)
- Choose appropriate CLI modes when delegating tasks
- Communicate task complexity to specialists using mode hints
- Understand safety boundaries and approval requirements
- Verify specialist execution aligns with delegated mode

### For Specialist Agents (@bash-ops, @doc, @research)
- Interpret mode hints from delegators
- Decide whether to invoke CLI wrapper or execute directly
- Handle confirmation gates during high-risk operations
- Understand scope boundaries and safety constraints

### For Power Users & Builders
- Automate complex tasks using CLI modes effectively
- Leverage safety guardrails to prevent mistakes
- Understand escalation paths between modes

---

## Table of Contents

1. [Overview & Mental Models](<#overview--mental-models>)
2. [Quick Decision Guide](<#quick-decision-guide>)
3. [Mode Deep Dives](<#mode-deep-dives>)
4. [Delegation Patterns](<#delegation-patterns>)
5. [Safety & Confirmation Workflows](<#safety--confirmation-workflows>)
6. [Model Selection Heuristics](<#model-selection-heuristics>)
7. [Real-World Workflow Sequences](<#real-world-workflow-sequences>)
8. [Troubleshooting & Recovery](<#troubleshooting--recovery>)
9. [Best Practices & Patterns](<#best-practices--patterns>)
10. [Reference & Checklists](<#reference--checklists>)

---

## Overview & Mental Models

### What This Skill Teaches

This skill teaches you how to orchestrate AI-powered tasks using GitHub Copilot's CLI mode system. You'll learn to:

- **Select the right mode** for any task (c-ask, c-plan, c-edit, c-agent)
- **Understand safety guardrails** and approval workflows
- **Delegate effectively** to specialist agents using mode hints
- **Optimize cost and latency** by choosing appropriate models
- **Execute complex multi-step workflows** reliably
- **Troubleshoot failures** and recover gracefully

### Core Mental Models

#### 1. Progressive Escalation as Safety

The mode system implements **privilege escalation by default**. Start with read-only analysis, escalate to scoped writes, then to full autonomy only when necessary:

```
c-ask (Haiku)      c-plan (Sonnet)    c-edit (Sonnet)      c-agent (Opus)
  Read-only    →   Read-only       →  Scoped write    →    Full autonomy
  Analysis         Planning           Safe edits           Autonomous execution
  Lowest risk      Low risk           Medium risk          Highest risk + approval gate
```

**Philosophy**: Many tasks can be solved safely with read-only modes. Only escalate when execution is necessary. Only grant full autonomy when you can't achieve the goal otherwise.

#### 2. Modes as Organizational Signals

When delegating work, modes are **not direct commands** that agents must execute. Instead, modes are **organizational hints** that guide specialists' decision-making:

- A specialist with high confidence might bypass the CLI wrapper entirely
- A specialist lacking expertise might invoke the exact mode you suggested
- Ben (the orchestrator) uses modes to communicate task complexity to specialists
- Specialists use modes to understand scope and decide their approach

**Key insight**: The mode you choose signals your expected task complexity. Specialists interpret this signal and decide the best execution path.

#### 3. Scope as Control Mechanism

Both c-edit and --scope flag demonstrate how **boundaries create safety**:

- c-edit enforces a `--scope` flag (no boundary = error)
- The scope path must actually exist on the filesystem
- Scope narrow-ness correlates directly with safety
- Ben verifies that edits don't exceed declared scope

**Pattern**: When you can't safely bound a task, you can't safely use c-edit. Escalate to c-agent instead.

#### 4. Approval Gates as Social & Technical Control

The c-agent approval gate isn't purely technical—it's **social control**:

- Forces users to consciously approve before autonomous execution
- High-risk keywords trigger double-confirmation (pause for thinking)
- Creates an audit trail for learning and governance
- Prevents "fire and forget" mistakes with high-impact operations

### Who Should Use This Skill

**Orchestrators** (like @ben) who delegate work to specialists:
- Need to communicate task complexity using modes
- Must ensure safety guardrails are understood
- Verify specialist execution aligns with mode hints

**Specialist Agents** who receive delegations with mode hints:
- Must interpret mode signals to guide execution approach
- Decide when to invoke CLI wrapper vs. execute directly
- Handle confirmation gates during high-risk operations

**Power Users** managing complex, multi-step workflows:
- Automate task sequences using mode principles
- Optimize cost and latency by choosing right modes
- Leverage safety guardrails to prevent mistakes

---

## Quick Decision Guide

### Decision Tree: Which Mode to Use?

```
START: Analyzing task requirements
│
├─ Is execution required, or just analysis?
│  │
│  ├─ ANALYSIS ONLY
│  │  │
│  │  ├─ Simple (quick answer expected)?
│  │  │  └─ YES → c-ask (Haiku, fast, cheap, read-only)
│  │  │           Examples: error diagnostics, code explanation, quick Q&A
│  │  │
│  │  └─ Complex (requires structure/decomposition)?
│  │     └─ YES → c-plan (Sonnet, balanced, read-only, structured)
│  │              Examples: design roadmaps, risk assessment, feature planning
│  │
│  └─ EXECUTION REQUIRED
│     │
│     ├─ Can you bound scope in a safe directory?
│     │  │
│     │  ├─ YES → c-edit (Sonnet, scoped write, --scope REQUIRED)
│     │  │        Conditions: scope path must exist, modifications contained
│     │  │        Examples: docstrings, comments, contained refactoring
│     │  │
│     │  └─ NO: Does execution require full autonomy + multi-step logic?
│     │     │
│     │     └─ YES → c-agent (Opus, full autonomy, approval-gated)
│     │              Conditions: must handle confirmation gate, user must approve
│     │              Examples: CI/CD setup, test runners, complex workflows
│     │
│     └─ Can you decompose into smaller c-edit tasks?
│        └─ YES → Split into multiple c-edit calls
│        └─ NO → Use c-agent for complex orchestration
```

### One-Liner Decision Rules

| Situation | Mode | Why |
|-----------|------|-----|
| "Explain what this error means" | c-ask | Quick diagnostic, no execution |
| "Design a refactoring strategy" | c-plan | Structured decomposition needed |
| "Add docstrings to functions in src/handlers/" | c-edit | Scoped, safe (--scope src/handlers/) |
| "Set up CI/CD pipeline" | c-agent | Multi-step autonomy + approval needed |
| "Is this code secure?" | c-ask | Analysis only, no execution |
| "How should we handle authentication?" | c-plan | Planning/design, structured thinking |
| "Fix typos in README.md" | c-edit | Scoped (--scope docs/), safe |
| "Deploy to production" | c-agent | High-risk, requires approval |
| "What's the bottleneck in this algorithm?" | c-ask | Quick analysis, no execution |
| "Refactor error handling in src/auth/" | c-edit | Scoped refactor (--scope src/auth/) |

### Model Selection at a Glance

```
Task Type               Model            Speed      Cost      Best For
─────────────────────────────────────────────────────────────────────
Quick diagnostic        Haiku 4.5        ★★★★★      ★☆☆☆☆    c-ask
Structured planning     Sonnet 4.6       ★★★☆☆      ★★☆☆☆    c-plan
Scoped editing          Sonnet 4.6       ★★★☆☆      ★★☆☆☆    c-edit
Complex autonomy        Opus 4.6         ★★☆☆☆      ★★★★☆    c-agent
Huge context (>600K)    Gemini 3.1 Pro   ★★☆☆☆      ★★★☆☆    Auto-escalation
```

---

## Mode Deep Dives

### c-ask: Fast Advisory (Read-Only Analysis)

#### Purpose & Capabilities

c-ask is the **lightweight analysis mode**. Use it to understand, diagnose, and explain without any execution or modification.

**What it does well**:
- Rapid answers to specific questions
- Error diagnosis and troubleshooting
- Code explanation and review
- Architecture assessment
- Security/performance analysis
- Quick decision guidance

**What it cannot do**:
- Modify files (read-only)
- Execute shell commands
- Make external API calls
- Implement solutions (analysis-only)
- Run tests or builds

#### When to Use c-ask

✅ **Use c-ask when**:
- Expected answer time: < 5 minutes
- Output is explanation, not code
- Input is code, logs, documentation
- Quick diagnostic or review needed
- Your goal is understanding, not implementation
- Cost/latency is a priority

❌ **Don't use c-ask when**:
- Task requires planning or roadmap (→ c-plan)
- Task requires code generation (→ c-plan or c-edit)
- Problem is complex and needs deep analysis (→ c-plan)
- You need prescriptive recommendations (→ c-plan)

#### Examples & Patterns

##### Example 1: Error Diagnosis

```bash
# Prompt
c-ask -p "What's wrong with this stack trace?"

# Input (stdin)
[Error stack trace from application logs]

# Expected output
Explanation of:
- Root cause (e.g., "Null pointer dereference in line 42")
- Why it happened (e.g., "User data not validated at API boundary")
- Suggested investigation (e.g., "Check request validation middleware")
```

##### Example 2: Code Explanation

```bash
# Prompt
c-ask -p "Explain what this function does and identify potential issues"

# Input
function handleUserAuth(token) {
  const decoded = jwt_decode(token);
  return decoded.userId;
}

# Expected output
- Explanation: "Decodes JWT token and extracts userId"
- Issues: "No token validation, assumes JWT is valid, silent failure if malformed"
- Risks: "Could accept forged tokens"
```

##### Example 3: Quick Decision

```bash
c-ask -p "Should we use Redis or Memcached for caching user sessions?"

# Expected output
- Comparison of tradeoffs
- Recommendation based on typical use cases
- Questions to clarify your specific needs
```

#### Anti-Patterns & Mistakes

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| Using c-ask for solution design | Model reasoning insufficient for complex architecture | Use c-plan instead |
| Asking c-ask for step-by-step breakdown | Output lacks structure for implementation | Use c-plan for structured planning |
| Expecting c-ask to propose code changes | Mode is read-only, won't provide implementation | Follow up with c-plan or c-edit |
| Very large input (>100K tokens) | Model becomes slow/expensive | Use c-plan or c-agent with larger context |

#### Ben's Verification Checklist

✅ Output is **analysis, explanation, or diagnostic** (not prescriptive code)
✅ Output provides **clear reasoning** (explains "why", not just "what")
✅ Output is **actionable** (user can use it to make next decision)
✅ No file modifications attempted (read-only confirmed)
✅ No shell execution attempted (read-only confirmed)

---

### c-plan: Strategic Planning (Structured Design)

#### Purpose & Capabilities

c-plan is the **design and planning mode**. Use it to structure complex problems, create roadmaps, and make architectural decisions.

**What it does well**:
- Breaking down complex tasks into steps
- Creating implementation roadmaps
- Risk assessment and mitigation planning
- Architecture and design proposals
- Feature planning and prioritization
- Estimating effort and dependencies
- Identifying breaking changes

**What it cannot do**:
- Modify files (read-only)
- Execute implementations
- Run tests or builds
- Make external API calls

#### When to Use c-plan

✅ **Use c-plan when**:
- Task is complex and needs decomposition
- Output should be a roadmap or plan
- Input is high-level requirements or specifications
- You need to understand dependencies and risks before implementing
- Structured thinking/planning is the primary goal
- Task complexity requires Sonnet-level reasoning

❌ **Don't use c-plan when**:
- Quick explanation is all you need (→ c-ask)
- You're ready to implement immediately (→ c-edit)
- Task is simple and obvious (→ c-edit directly)
- You need to execute immediately (→ c-agent)

#### Examples & Patterns

##### Example 1: Refactoring Roadmap

```bash
c-plan -p "Create a refactoring roadmap for moving from sync to async/await in src/handlers/"

# Expected output structure:
- Overview: Current state → desired end state
- Phase 1: Identify affected code paths
- Phase 2: Create async wrapper functions
- Phase 3: Update call sites
- Phase 4: Remove old sync code
- Breaking Changes: [list]
- Risk Assessment: [risks and mitigations]
- Success Criteria: [measurable outcomes]
```

##### Example 2: CI/CD Implementation Plan

```bash
c-plan -p "Design a CI/CD pipeline for our monorepo with testing, linting, and deployment stages"

# Input
Project structure, current test suite, deployment target (staging + production)

# Expected output
- Pipeline architecture (stages, jobs)
- Tool recommendations (GitHub Actions vs Jenkins vs GitLab CI)
- Detailed stage breakdown
- Secret/credential management strategy
- Rollback and failure handling
- Estimated implementation effort
- Risk analysis
```

##### Example 3: Feature Planning

```bash
c-plan -p "Plan how to implement user authentication with OAuth2 in our existing API"

# Expected output
- Current state analysis
- Changes to API design
- Database schema updates needed
- Integration with third-party OAuth providers
- Security considerations
- Step-by-step implementation phases
- Backward compatibility concerns
- Testing strategy
```

#### Anti-Patterns & Mistakes

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| Using c-plan for simple tasks | Overkill, wastes analysis time/cost | Use c-ask for quick decisions |
| Expecting c-plan to implement | Mode is read-only, won't provide implementation | Use output as input to c-edit or c-agent |
| Not providing sufficient context | Plan is generic/ungrounded | Provide project structure, constraints, current state |
| Asking for everything in one plan | Output is overwhelming, hard to follow | Break planning into steps |

#### Ben's Verification Checklist

✅ Output is **structured with clear phases/steps**
✅ **Dependencies and sequencing** are explicit
✅ **Risk assessment** addresses major concerns
✅ **Success criteria** are measurable
✅ Output is **grounded** in provided context (not generic)
✅ No file modifications attempted (read-only confirmed)

---

### c-edit: Safe File Editing (Scoped Write)

#### Purpose & Capabilities

c-edit is the **bounded modification mode**. Use it for safe file edits within a declared scope, no shell execution.

**What it does well**:
- Editing files within a bounded scope (--scope required)
- Docstrings, comments, documentation updates
- Type annotations and small refactors
- Contained bug fixes
- Adding/removing code within a directory
- Format fixes and linting

**What it cannot do**:
- Execute shell commands
- Modify files outside --scope boundary
- Execute code or run tests
- Make external API calls
- Broad changes across multiple unrelated directories

#### When to Use c-edit

✅ **Use c-edit when**:
- Scope can be declared AND path exists (--scope required)
- Modifications are contained within that scope
- No shell execution needed
- Task is specific and well-defined
- You want write protection (scope boundary)

❌ **Don't use c-edit when**:
- Can't declare a scope (→ use c-agent)
- Scope path doesn't exist (error will occur)
- Task requires shell commands (→ c-agent)
- Changes span multiple unrelated directories
- Need temporary files or complex orchestration

#### Critical Rules for c-edit

**RULE 1: --scope flag is MANDATORY**
```bash
# ❌ INVALID - no --scope
c-edit -p "Add docstrings to functions"

# ✅ VALID - scope declared and exists
c-edit -p "Add docstrings to functions" --scope src/handlers/

# ❌ INVALID - scope path doesn't exist
c-edit -p "Add docstrings" --scope nonexistent/path/
```

**RULE 2: --scope must be tight (not too broad)**
```bash
# ❌ Scope too broad
c-edit -p "Fix all type errors" --scope src/

# ✅ Scope appropriate
c-edit -p "Fix type errors in API handlers" --scope src/api/handlers/
```

**RULE 3: Scope MUST exist on filesystem**
```bash
# Before using c-edit, verify:
ls -la src/handlers/  # Must succeed

# If error, reconsider scope or use c-agent instead
```

#### Examples & Patterns

##### Example 1: Documentation Updates

```bash
c-edit -p "Add comprehensive JSDoc comments to all exported functions" \
       --scope src/api/

# What this does:
# - Reads all .js/.ts files in src/api/
# - Adds docstrings to exported functions
# - Preserves all other code exactly
# - Stays within src/api/ boundary
```

##### Example 2: Type Annotation Improvements

```bash
c-edit -p "Add type annotations to function parameters and return types in payment module" \
       --scope src/payments/

# What this does:
# - Adds TypeScript type annotations
# - Updates .ts/.tsx files in src/payments/
# - Improves type safety in that module
# - Prevents changes outside src/payments/
```

##### Example 3: Bug Fix in Contained Scope

```bash
c-edit -p "Fix error handling in authentication functions: ensure all error paths are caught" \
       --scope src/auth/

# What this does:
# - Reviews all functions in src/auth/
# - Adds error handling where missing
# - No shell commands or external calls
# - Auditable, scoped changes
```

#### Anti-Patterns & Mistakes

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| No --scope flag | Defaults to current directory, unclear extent | Always specify --scope |
| --scope too broad | Can't verify all changes, high risk | Narrow scope to specific directory |
| Non-existent scope | Error occurs, task fails | Verify path exists first (ls -la) |
| Using c-edit for complex logic | Scope too limited for complex changes | Use c-agent for orchestration |
| Shell dependencies | Some edits need shell context | Use c-agent if shell needed |

#### Ben's Verification Checklist

✅ **--scope flag is present** in delegation
✅ **Scope path exists** on filesystem (verified with ls)
✅ **Scope is tight** (specific directory, not overly broad)
✅ **Modifications are within scope** (no out-of-bounds files changed)
✅ **No shell execution attempted** (read-only + write combo, no shell)
✅ **Changes align with original intent** (correct problem solved)

---

### c-agent: Full Autonomy (Complex Workflows)

#### Purpose & Capabilities

c-agent is the **full-autonomy mode**. Use it for complex, multi-step workflows requiring sophisticated reasoning and state management.

**What it does well**:
- Multi-step orchestration (calls to multiple tools sequentially)
- State machines and workflow execution
- Complex decision-making across multiple phases
- Build systems, test runners, CI/CD
- Autonomous problem-solving
- Full tool access (subject to deny-list)

**What it cannot do**:
- Run without user approval (confirmation gate required)
- Execute dangerous operations (deny-list blocks privilege escalation, credential access)
- Run without clear success criteria (should know when done)

#### When to Use c-agent

✅ **Use c-agent when**:
- Task requires multi-step autonomy (can't be decomposed into c-edit calls)
- Task complexity demands Opus-level reasoning
- Workflow involves state management or conditional logic
- Tasks need full tool access and shell capability
- User understands approval gate will trigger
- Task complexity cannot be simplified

❌ **Don't use c-agent when**:
- Simple task solvable with c-ask/c-plan (→ use simpler mode)
- Task can be scoped safely with c-edit (→ use c-edit)
- User cannot approve task (→ cannot proceed)
- Task has no clear success criteria

#### Critical: Approval Gate Protocol

**RULE 1: c-agent ALWAYS requires approval, no exceptions**
```bash
# Every c-agent invocation triggers confirmation:
c-agent -p "Run test suite and report coverage"
→ Approval prompt: "Proceed with c-agent execution? (yes/no)"

# User must explicitly type "yes" to proceed
# Anything else (no, enter, cancel) → operation rejected
```

**RULE 2: High-risk keywords trigger DOUBLE confirmation**
```bash
# Keywords triggering extra confirmation:
# delete, remove, destroy, drop, truncate (data destruction)
# deploy, push, production (production impact)
# chmod, chown (permission changes)
# sudo (privilege escalation)

# Example:
c-agent -p "Delete old log files from /var/logs/"
→ Confirmation 1: "Proceed with c-agent execution? (yes/no)"
→ [User types "yes"]
→ Confirmation 2: "CONFIRM: This task involves destructive operation (delete).
   Proceed? (yes/no)"
→ [User must type "yes" again]

# If either confirmation is rejected, task cancelled
```

**RULE 3: Deny-list blocks certain operations universally**
```bash
# These operations are blocked in c-agent mode:
sudo, su                  [Privilege escalation]
read-secrets, vault       [Credential access]
apt, npm, pip (install)   [Supply chain attacks]
Whitelisted-only network  [Data exfiltration]
systemctl, launchctl      [System modification]

# Ben must escalate if user request requires denied operation
```

#### Examples & Patterns

##### Example 1: Test Suite Automation

```bash
c-agent -p "Run comprehensive test suite with coverage analysis:
  1. Run linter (eslint)
  2. Run unit tests with coverage
  3. Generate coverage report
  4. Check minimum coverage threshold (80%)
  5. Report results with summary"

# What this does:
# - Autonomously runs multiple test commands
# - Manages state (coverage %, threshold check)
# - Generates comprehensive report
# - Requires user approval before execution
```

##### Example 2: CI/CD Setup

```bash
c-agent -p "Create GitHub Actions workflow for monorepo:
  1. Analyze project structure
  2. Define test stages (lint, unit, integration)
  3. Create workflow yaml
  4. Add deployment stage to staging
  5. Configure secrets handling
  6. Test workflow locally if possible"

# What this does:
# - Multi-step orchestration (analysis → design → implementation)
# - Creates complex YAML configuration
# - Manages multiple concerns (testing, deployment, secrets)
# - Requires approval due to "deploy" keyword → double confirmation
```

##### Example 3: Debugging & Fixing Issue

```bash
c-agent -p "Diagnose and fix intermittent timeout in API endpoint:
  1. Analyze endpoint implementation
  2. Review recent changes and logs
  3. Identify root cause
  4. Implement fix
  5. Create test case
  6. Verify fix works
  7. Generate fix summary"

# What this does:
# - Autonomous diagnosis and remediation
# - Multiple analysis phases
# - Code creation and testing
# - Requires understanding of entire codebase
# - Requires approval before implementation
```

#### Anti-Patterns & Mistakes

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| c-agent for simple tasks | Overkill, wastes reasoning/cost | Use c-ask/c-plan/c-edit |
| High-risk keywords without disclosure | User surprised by extra confirmation | Always mention risky operations beforehand |
| No success criteria | Can't tell when task succeeds | Define explicit success indicators |
| Ignoring approval gate | Expecting to "approve later" | Require explicit approval before delegation |
| Trying to bypass deny-list | Dangerous operations blocked for reason | Escalate on security-sensitive tasks |

#### Ben's Verification Checklist

✅ **User understands approval gate** will trigger before execution
✅ **High-risk keywords disclosed** (delete, deploy, push, chmod, etc.)
✅ **Success criteria are measurable** (know when task completes)
✅ **Fallback/rollback plan exists** (if execution fails)
✅ **Operation is not denied** by universal deny-list
✅ **User is ready to approve** before delegation

---

## Delegation Patterns

### Core Insight: Modes as Organizational Signals

When you (as orchestrator) delegate a task with a mode hint, remember:

- **Specialists don't necessarily invoke the CLI wrapper directly**
- Modes are **guidance**, not commands
- Specialists with high expertise **execute directly** (preferred)
- Specialists without expertise **invoke the wrapper**
- Modes communicate **expected complexity** to guide decision-making

### Mode-Aware Delegation Template

Structure your delegations with explicit mode context:

```
Delegate to @SPECIALIST:

[CLEAR TASK STATEMENT with measurable success criteria]

Mode context (choose based on task complexity):
- c-ask [Optional]: Use for quick diagnostic of [specific aspect]
- c-plan [Optional]: Use to structure [specific planning step]
- c-edit [Optional]: Use to modify [specific files/scope]
- c-agent [Optional]: Use for autonomous execution of [specific steps]

If high-risk operations involved:
  ⚠️ Note: This requires approval before execution (high-risk keyword: [keyword])

Deliverable: [Explicit output expected]
Success criteria:
  ✓ [Measurable criterion 1]
  ✓ [Measurable criterion 2]
  ✓ [Verification step 1]
```

#### Example 1: Refactoring Delegation

```
Delegate to @bash-ops:

Refactor error handling in authentication module (src/auth/) to improve
robustness and reduce unhandled exceptions.

Mode context:
- c-plan: First, create refactoring roadmap showing:
  * Current error handling gaps (what's unhandled?)
  * Proposed improvements (what should we add?)
  * Breaking changes (will anything need client updates?)
  * Risk assessment (what could fail?)

- c-edit: Then, implement improvements scoped to src/auth/:
  * Add try/catch blocks to unhandled paths
  * Create consistent error response format
  * Update error messages to be actionable
  * Add error logging where missing

- c-ask: Finally, validate edge cases:
  * What error scenarios are still uncovered?
  * Any remaining type unsafety?
  * Are error responses consistent across all paths?

Deliverable:
✓ REFACTORING-ROADMAP.md (from c-plan output)
✓ Updated src/auth/ with improved error handling
✓ Edge case validation report
✓ All tests passing with error handling coverage
```

#### Example 2: Documentation Delegation

```
Delegate to @doc:

Write comprehensive API documentation for new payment module (src/payments/).

Mode context:
- c-ask: Quick analysis of existing code structure
- c-edit: Write documentation scoped to docs/api/:
  * Overview and architecture
  * API endpoint reference
  * Code examples (working, runnable)
  * Error codes and handling
  * Security considerations

Deliverable:
✓ docs/api/payments/README.md (complete guide)
✓ docs/api/payments/endpoints.md (API reference)
✓ docs/api/payments/examples.md (working code examples)
✓ docs/api/payments/security.md (security guide)
✓ All examples verified against actual implementation
✓ All cross-references validated
```

#### Example 3: Testing Automation Delegation

```
Delegate to @bash-ops:

Implement comprehensive test automation for the project.

Mode context:
- c-plan: Design test automation strategy:
  * Test pyramid (unit/integration/e2e breakdown)
  * Tool selection (Jest, Cypress, etc.)
  * Coverage targets
  * CI/CD integration approach

- c-agent: Implement test automation:
  * Create test runner scripts
  * Set up CI/CD configuration
  * Configure coverage reporting
  * Set up pre-commit hooks
  * Document test execution process

⚠️ Note: May require approval for CI/CD platform configuration

Deliverable:
✓ Configured test runner with all test types
✓ CI/CD pipeline running on every commit
✓ Coverage reports generated automatically
✓ Documentation for running tests locally
```

### Specialist Interpretation Rules

When you receive a delegation with mode hints:

```
IF I (specialist) have high confidence in approach:
  ├─ Execute directly (fastest, preferred path)
  └─ Skip CLI wrapper unless needed for specific feature
ELSE IF task is simple (c-ask scope):
  ├─ Invoke c-ask wrapper for diagnostic
  └─ Use output to guide implementation
ELSE IF task requires planning (c-plan scope):
  ├─ Invoke c-plan wrapper for roadmap
  └─ Use roadmap as implementation guide
ELSE IF task is scoped file edit (c-edit scope):
  ├─ Invoke c-edit wrapper with --scope
  └─ OR execute edits directly if high confidence
ELSE IF task requires full autonomy (c-agent scope):
  ├─ Invoke c-agent wrapper
  ├─ Handle approval gate when triggered
  └─ Proceed with autonomous execution
ELSE:
  └─ Escalate to Ben with clarifying questions
```

### Verification Checklist: After Specialist Delivers

After specialist completes delegated work:

✅ **Task completed as delegated** (success criteria met)
✅ **If c-plan used**: Output is structured (steps, risks, estimates)
✅ **If c-edit used**: --scope flag was respected, changes contained
✅ **If c-agent used**: Specialist managed approval gate
✅ **Output quality meets expectations** (thorough, not rushed)
✅ **No scope creep** (delivered what was asked, not more)

---

## Safety & Confirmation Workflows

### Universal Deny-List

These operations are **blocked in all modes** for security reasons:

| Category | Blocked Operations | Why Blocked |
|----------|-------------------|-----|
| **Privilege Escalation** | `sudo`, `su`, `doas` | Prevent privilege level elevation |
| **Credential Access** | `read-secrets`, `vault-access`, `aws-credentials` | Prevent credential leakage |
| **Package Installation** | `apt install`, `npm install`, `pip install` | Prevent supply chain attacks |
| **System Modification** | `systemctl`, `launchctl`, `/etc/` changes | Prevent system destabilization |
| **Network Exfiltration** | Bulk outbound connections, whitelist-only | Prevent data exfiltration |

**Ben's Rule**: Never suggest overriding deny-lists. These exist for critical security reasons.

### Mode-Specific Safety Profiles

#### c-ask & c-plan: Read-Only Safety
```
Operations allowed:  File read, analysis, reasoning
Operations blocked:  shell execution, file modification, external requests
Risk level:          Very Low
Approval required:   No
```

Both c-ask and c-plan are safe by design—no modifications possible.

#### c-edit: Scoped Write Safety
```
Operations allowed:  File write (within --scope boundary only)
Operations blocked:  shell execution, external requests, out-of-scope write
Risk level:          Low-Medium (bounded by scope)
Approval required:   No (but --scope boundary is the approval mechanism)

Key safety mechanism: --scope flag acts as permission boundary
```

#### c-agent: Full Access + Deny-List
```
Operations allowed:  All tools EXCEPT deny-list
Operations blocked:  [Universal deny-list above]
Risk level:          Medium-High (full access, but guardrails apply)
Approval required:   YES, double-confirmation for high-risk keywords

Key safety mechanisms:
  1. User approval gate (mandatory)
  2. High-risk keyword detection (double confirmation)
  3. Deny-list (blocks dangerous operations)
  4. Audit trail (approval decisions logged)
```

### Confirmation Gate Workflows

#### Single-Confirmation Gate (c-agent, low-risk keywords)

```bash
$ c-agent -p "Run test suite and generate coverage report"

[System shows confirmation prompt]
Approve c-agent execution?
This will run autonomous tests with full tool access.
Type 'yes' to approve, anything else to cancel: _

$ yes
[Executing...]
✓ Tests ran to completion
✓ Coverage report generated
```

#### Double-Confirmation Gate (c-agent, high-risk keywords)

```bash
$ c-agent -p "Delete old backups older than 30 days from /backups/"

[System shows Level 1 confirmation]
Approve c-agent execution?
Type 'yes' to approve: _

$ yes

[System detects "delete" keyword, shows Level 2 confirmation]
⚠️ CRITICAL: High-risk operation detected
This task involves destructive operation: delete

Additional confirmation required.
Type 'yes' to proceed, anything else to cancel: _

$ yes
[Executing...]
✓ Old backups deleted
✓ Cleanup complete
```

#### Denied Confirmation (User Rejects)

```bash
$ c-agent -p "Deploy to production"

Approve c-agent execution? (yes/no): _

$ no
[Operation cancelled]
Operation rejected by user. Logging as 'cancelled'.

To proceed:
1. Review the task requirements
2. Confirm you're ready to approve
3. Invoke c-agent again
```

### Ben's Pre-Delegation Checklist for c-agent

Before delegating a c-agent task:

✅ **Does prompt contain high-risk keywords?**
  - [ ] No high-risk keywords → single confirmation sufficient
  - [ ] Contains high-risk keywords (delete, deploy, push, chmod, etc.) → inform user of double-confirmation

✅ **Is user ready to approve?**
  - [ ] Confirm user understands approval will be required
  - [ ] If uncertain, use c-plan to design approach FIRST, then c-agent to execute

✅ **Are success criteria clear?**
  - [ ] User knows when task succeeds
  - [ ] Task knows when to stop executing
  - [ ] Verification is possible

✅ **Is fallback strategy documented?**
  - [ ] If execution fails, what's the recovery path?
  - [ ] Can user rollback if needed?

✅ **Are denied operations absent?**
  - [ ] No `sudo`, `read-secrets`, unauthorized network access
  - [ ] If needed, escalate as architectural issue (not c-agent problem)

---

## Model Selection Heuristics

### Model Capability Ladder

```
Capability      Haiku 4.5      Sonnet 4.6      Sonnet 4.6      Opus 4.6       Gemini 3.1 Pro
            (speed/cost)   (balance)      (scoped)      (reasoning)    (large context)
─────────────────────────────────────────────────────────────────────────────────────
Speed           ★★★★★         ★★★☆☆        ★★★☆☆        ★★☆☆☆          ★★☆☆☆
Cost            ★☆☆☆☆         ★★☆☆☆        ★★☆☆☆        ★★★★☆          ★★★☆☆
Reasoning       ★★☆☆☆         ★★★☆☆        ★★★☆☆        ★★★★★          ★★★★☆
Context Size    ↓ 100K         ↑ 200K         ↑ 200K         ↑ 200K          ↑ 1M+
Best Mode       c-ask          c-plan         c-edit         c-agent         auto-escalate
```

### Selection Rules by Task Trait

| Task Characteristic | Select | Cost Impact | Speed Impact |
|-------|--------|-------|------|
| Simple analysis, quick answer | Haiku (c-ask) | ⬇️ Lowest | ⬆️ Fastest |
| Planning, design, roadmaps | Sonnet (c-plan) | ↔️ Medium | ↔️ Medium |
| Scoped file editing | Sonnet (c-edit) | ↔️ Medium | ↔️ Medium |
| Complex multi-step workflows | Opus (c-agent) | ⬆️ Highest | ⬇️ Slowest |
| Very large input (>600K tokens) | Gemini 3.1 Pro | ↔️ Medium+ | ⬇️ Slower |

### Cost-Performance Optimization Strategies

#### Strategy 1: Optimize for Speed

When latency matters (user-facing operations):

```
Prefer:    c-ask (Haiku) > c-plan (Sonnet) >> c-agent (Opus)
Typical:   2-5 sec       5-15 sec            15-60+ sec
Tradeoff:  Accept simpler analysis for faster response
```

#### Strategy 2: Optimize for Cost

When budget matters (background tasks, batch processing):

```
Prefer:    c-ask (Haiku) > c-plan (Sonnet) >> c-agent (Opus)
Cost:      Lowest        Medium             Highest
Tradeoff:  Accept longer latency for cheaper execution
```

#### Strategy 3: Optimize for Quality

When accuracy matters (critical decisions, high-risk tasks):

```
Prefer:    c-agent (Opus) >> c-plan (Sonnet) > c-ask (Haiku)
Reasoning: Deep            Structured        Quick
Tradeoff:  Accept higher cost/latency for best quality
```

### Large Context Handling (>600K tokens)

**Auto-Escalation Rule**: When input exceeds 600K tokens, models auto-escalate to Gemini 3.1 Pro:

```bash
# Example: Analyzing large codebase
cat huge-project/**/*.ts | c-ask -p "Find security vulnerabilities"

[System detects input>600K tokens]
[Auto-escalates: Haiku → Gemini 3.1 Pro]
✓ Processing with Gemini 3.1 Pro
[Response generated...]
```

**Manual Override**:
```bash
# Force specific model
c-ask -p "analyze" --model claude-opus-4.6 < large-file.txt

# Options: haiku-4.5, sonnet-4.6, opus-4.6, gemini-3.1-pro
```

### Model Selection Decision Tree

```
START: Task requires execution?
├─ NO: Pure analysis needed
│  ├─ Quick answer expected (<5 min)?
│  │  └─ YES → Haiku (c-ask) [fast, cheap]
│  └─ NO: Complex planning?
│     └─ YES → Sonnet (c-plan) [balanced reasoning]
│
└─ YES: Execution required
   ├─ Can scope be bounded safely? (bounded directory)
   │  └─ YES → Sonnet (c-edit) [scoped safety]
   └─ NO: Requires full autonomy?
      └─ YES → Opus (c-agent) [deep reasoning]

Input size > 600K tokens?
└─ Auto-escalate to Gemini (or use --model override)
```

---

## Reference & Checklists

### CLI Flags & Options Reference

```bash
# Mode selection (one per command):
-c ask      Select c-ask mode (Haiku, read-only)
-c plan     Select c-plan mode (Sonnet, read-only)
-c edit     Select c-edit mode (Sonnet, scoped write)
-c agent    Select c-agent mode (Opus, full autonomy)

# Prompt & input:
-p "prompt" Prompt text for Copilot
--file FILE Read prompt from file
<stdin>     Read input from stdin (pipe data)

# Configuration:
--model NAME        Override model (haiku-4.5, sonnet-4.6, opus-4.6, gemini-3.1-pro)
--scope /path/      [c-edit only] Boundary for file modifications (REQUIRED)
--dry-run           Preview changes without executing (for c-edit/c-agent)
--timeout N         Max seconds to wait for response (e.g., --timeout 60)
--max-tokens N      Limit output length
--temperature 0-1   Model creativity (0=deterministic, 1=creative)

# Approval/confirmation:
--no-confirm        [Dangerous] Skip approval gate (not recommended)
--force             Override safety checks (not recommended)

# Output control:
--json              Output in JSON format
--quiet             Suppress non-essential output
--verbose           Include debugging info
```

### Delegation Checklist

Use this before delegating work to a specialist:

**Clear Task Definition**:
- [ ] Task statement is specific and measurable
- [ ] Success criteria are explicit (how will we know it's done?)
- [ ] Acceptance criteria are documented
- [ ] Scope is bounded (what's IN scope, what's OUT)

**Appropriate Mode Selection**:
- [ ] Mode choice is justified (not defaulting)
- [ ] Mode hints provided if multiple options exist
- [ ] If c-edit: --scope flag required and path exists
- [ ] If c-agent: User understands approval required
- [ ] If high-risk: Double-confirmation acknowledged

**Context Provided**:
- [ ] Sufficient context for specialist to understand task
- [ ] Related files or documentation linked
- [ ] Constraints or limitations explained
- [ ] Dependencies identified

**Safety & Risk**:
- [ ] High-risk keywords identified
- [ ] Approval strategy explained (if c-agent)
- [ ] Fallback strategy documented (if c-agent)
- [ ] No denied operations in task description

**Verification Plan**:
- [ ] How will specialist verify success?
- [ ] How will you verify specialist's work?
- [ ] Testing strategy documented
- [ ] Rollback plan (if needed)

---

### Verification Checklist

After specialist delivers, verify:

**Completeness**:
- [ ] All success criteria met
- [ ] All deliverables provided
- [ ] No obvious gaps or TODOs

**Quality**:
- [ ] Code/documentation quality appropriate
- [ ] Style consistent with codebase
- [ ] No obvious technical debt introduced
- [ ] Examples/tests provided (if applicable)

**Safety (c-edit)**:
- [ ] No files modified outside --scope
- [ ] No unintended side effects
- [ ] Changes align with original intent

**Safety (c-agent)**:
- [ ] User approvals documented
- [ ] Approval gates respected
- [ ] No denied operations executed
- [ ] Outcome is as expected

**Handoff**:
- [ ] Documentation updated
- [ ] Team understands any breaking changes
- [ ] Deployment path clear (if applicable)

---

### Model Selection Quick Reference

```
Task              Recommended    Speed  Cost  Reasoning  Context
────────────────────────────────────────────────────────────────
Quick Q&A         Haiku (c-ask)   ★★★★★  ★☆☆    ★★       ↓100K
Diagnostics       Haiku (c-ask)   ★★★★★  ★☆☆    ★★       ↓100K
Analysis          Haiku (c-ask)   ★★★★★  ★☆☆    ★★       ↓100K

Planning          Sonnet (c-plan) ★★★☆☆  ★★☆    ★★★      ↑200K
Design            Sonnet (c-plan) ★★★☆☆  ★★☆    ★★★      ↑200K
Roadmaps          Sonnet (c-plan) ★★★☆☆  ★★☆    ★★★      ↑200K

Edit (scoped)     Sonnet (c-edit) ★★★☆☆  ★★☆    ★★★      ↑200K
Refactor          Sonnet (c-edit) ★★★☆☆  ★★☆    ★★★      ↑200K
Documentation     Sonnet (c-edit) ★★★☆☆  ★★☆    ★★★      ↑200K

Complex workflow  Opus (c-agent)  ★★☆☆☆  ★★★★   ★★★★★    ↑200K
Autonomy          Opus (c-agent)  ★★☆☆☆  ★★★★   ★★★★★    ↑200K
State machines    Opus (c-agent)  ★★☆☆☆  ★★★★   ★★★★★    ↑200K

Large context     Gemini 3.1 Pro  ★★☆☆☆  ★★★☆   ★★★★☆    ↑1M+
(>600K tokens)
```

---

### Safety Guardrails Checklist

**Universal Deny-List** (all modes):
- [ ] No `sudo` or `su` commands
- [ ] No `read-secrets` or credential access
- [ ] No package installation (`apt`, `npm install`, `pip install`)
- [ ] No system-level modifications (`systemctl`, `/etc/` changes)
- [ ] No bulk network exfiltration

**Mode-Specific Safety (c-edit)**:
- [ ] --scope flag present and verified
- [ ] Scope path exists on filesystem
- [ ] No shell execution attempted
- [ ] No external requests

**Mode-Specific Safety (c-agent)**:
- [ ] User approval obtained and logged
- [ ] High-risk keywords identified and disclosed
- [ ] Double-confirmation completed (if applicable)
- [ ] No denied operations attempted
- [ ] Audit trail available

---

### Decision Tree: When to Escalate

```
START: Task assigned?
├─ Can I solve this with high confidence?
│  ├─ YES → Execute directly (skip CLI wrapper)
│  └─ NO → Continue to mode selection
│
├─ Is task simple (single-step analysis)?
│  ├─ YES → Use c-ask (Haiku)
│  └─ NO → Continue
│
├─ Is task structured planning?
│  ├─ YES → Use c-plan (Sonnet)
│  └─ NO → Continue
│
├─ Can scope be bounded safely?
│  ├─ YES → Use c-edit (Sonnet, --scope required)
│  └─ NO → Continue
│
├─ Does task require full autonomy?
│  ├─ YES → Use c-agent (Opus, approval required)
│  └─ NO → Return to Ben for clarification
│
└─ BLOCKED: Can't proceed
   └─ Escalate to Ben with:
      • What mode were you attempting?
      • Why did it fail?
      • What additional context is needed?
```

---

## Key Takeaways

1. **Start simple, escalate when necessary** — Most tasks solvable with c-ask/c-plan. Only use c-agent when truly needed.

2. **Modes are organizational signals** — Not commands. Specialists use them to understand task complexity and guide their approach.

3. **Scope is safety** — c-edit safety depends entirely on --scope boundary being tight and verified.

4. **Approval gates prevent disasters** — c-agent requires explicit user confirmation. High-risk keywords trigger double-confirmation. This is intentional.

5. **Model choice matches task complexity** — Haiku for quick analysis, Sonnet for planning/editing, Opus for autonomous execution.

6. **Break complex tasks into steps** — Easier to verify, retry, and debug when tasks are smaller and sequential.

7. **Progressive escalation saves cost & time** — Cheaper modes (Haiku) often sufficient. Only escalate when c-plan/c-ask prove insufficient.

---

## Learning Path

**Recommended learning sequence** (25-30 minutes):

1. **Read**: Overview & Mental Models (5 min)
2. **Read**: Quick Decision Guide (3 min)
3. **Read**: Mode Deep Dives (10 min) — Focus on modes you'll use most
4. **Browse**: Real-World Workflow Sequences (5 min) — Find scenarios matching your work
5. **Reference**: Checklists & Quick Reference (2 min) — Bookmark for daily use
6. **Practice**: Apply one workflow sequence to your next task

**Advanced Learning** (additional 30+ minutes):

7. **Deep Dive**: Delegation Patterns section
8. **Master**: Safety & Confirmation Workflows
9. **Optimize**: Model Selection Heuristics
10. **Deep Dive**: Safety & Confirmation Workflows

---

## See Also

For comprehensive learning and detailed examples:

- **[CLI Modes Comprehensive Guide](<../../../../docs/guides/cli-modes-comprehensive-guide.md>)** — Deep dives on each mode, real-world workflows, troubleshooting, best practices
- **[CLI Mode Patterns Research](<../../../../docs/research/cli-mode-patterns-research.md>)** — Research backing for mode design, safety architecture, design decisions

---

## Document Information

**Skill Name**: cli-modes-skill
**Version**: 2.0.0
**Status**: Production-ready (consolidated reference)
**Last Updated**: March 31, 2026
**Audience**: Orchestrators, specialist agents, power users
**Format**: Markdown (SKILL.md format)
**Word Count**: ~2,000 words (quick reference)
**Read Time**: 15-20 minutes
**Author**: Multi-agent research & documentation synthesis

**Note**: For comprehensive tutorials, workflows, troubleshooting, and best practices, see the "See Also" section above. This consolidated version prioritizes quick reference over detailed learning.
