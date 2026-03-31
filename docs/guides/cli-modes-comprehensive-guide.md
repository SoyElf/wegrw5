# CLI Mode Patterns & Orchestration Heuristics: Comprehensive Skill Guide

**Skill Version**: 1.0
**Last Updated**: March 31, 2026
**Target Audience**: Orchestrators, specialist agents, power users
**Difficulty Level**: Intermediate-Advanced
**Estimated Reading Time**: 25-30 minutes (reference: 50+ minutes)

---

**Quick Links**:
- 🔗 **[Quick Reference: CLI Modes Skill](<../../.github/agents/skills/cli-modes-skill/SKILL.md>)** — One-page skill reference for quick lookup
- 📊 **[Research Backing: Patterns & Heuristics](<../research/cli-mode-patterns-research.md>)** — Deep research synthesis and technical analysis

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
   ├─ Can scope safely? (bounded directory)
   │  └─ YES → Sonnet (c-edit) [scoped safety]
   └─ NO: Requires full autonomy?
      └─ YES → Opus (c-agent) [deep reasoning]

Input size > 600K tokens?
└─ Auto-escalate to Gemini (or use --model override)
```

---

## Real-World Workflow Sequences

### Workflow 1: Refactoring (Analysis → Plan → Execute → Verify)

**Scenario**: User wants to refactor authentication module to improve error handling and Type safety.

```
Step 1: Quick Diagnostic (c-ask)
────────────────────────────────
Ben delegates: "What are the main error handling gaps in src/auth/?"

@bash-ops:
  └─ Invokes c-ask
  └─ Reads auth module code
  └─ Identifies:
    • 5 unhandled exception paths
    • Inconsistent error response formats
    • Missing type guards

Step 2: Refactoring Roadmap (c-plan)
─────────────────────────────────────
Ben delegates, using c-ask output: "Design refactoring strategy for src/auth/ based on
identified gaps: [gaps from Step 1]. Include breaking changes, migration path, and
risk assessment."

@bash-ops:
  └─ Invokes c-plan (or solves directly)
  └─ Creates REFACTORING.md with:
    • Phase 1: Add missing error handling
    • Phase 2: Standardize error responses
    • Phase 3: Add type guards
    • Breaking changes: [list]
    • Migration path for clients
    • Risk assessment

Step 3: Implementation (c-edit)
───────────────────────────────
Ben delegates: "Implement refactoring strategy from [REFACTORING.md]. Scope to src/auth/."

@bash-ops:
  └─ Invokes c-edit --scope src/auth/
  └─ Implements:
    • Try/catch blocks
    • Standard error response format
    • Type guards
    • Error logging
  └─ Modifications confined to src/auth/

Step 4: Verification (c-ask)
──────────────────────────────
Ben delegates: "Verify refactoring: any remaining error paths? Any type unsafety?"

@bash-ops:
  └─ Invokes c-ask
  └─ Reviews refactored code
  └─ Confirms:
    ✓ All error paths handled
    ✓ Type annotations consistent
    ✓ Error responses standardized

Step 5: User Verification
──────────────────────────
User runs tests:
  ✓ All tests passing
  ✓ Coverage >90%
  ✓ No unhandled exceptions in logs
  ✓ Type checking passes
```

**Success Criteria Met**:
- ✅ Gaps identified and documented
- ✅ Refactoring strategy clear and reviewed
- ✅ Implementation complete and contained
- ✅ Edge cases verified
- ✅ Tests passing

---

### Workflow 2: CI/CD Implementation (Plan → Design → Execute)

**Scenario**: User wants to implement automated testing and deployment CI/CD pipeline.

```
Step 1: Design CI/CD Strategy (c-plan)
──────────────────────────────────────
Ben delegates: "Design CI/CD pipeline strategy for our monorepo:
  • Current: Manual testing and deployment
  • Target: Automated testing on every commit, staged deployment
  • Constraints: [list]"

@bash-ops invokes c-plan:
  └─ Produces ARCHITECTURE.md with:
    • Tool selection (GitHub Actions? Jenkins?)
    • Pipeline stages: lint → unit → integration → deploy-staging
    • Secret management approach
    • Rollback strategy
    • Success metrics

Step 2: Implementation (c-agent)
────────────────────────────────
Ben reviews architecture, then delegates: "Implement CI/CD pipeline per ARCHITECTURE.md:
  1. Create workflow files
  2. Configure secrets (service account keys, etc.)
  3. Set up deploy triggers
  4. Implement rollback automation
  5. Test pipeline with dry-run"

⚠️ Ben informs user: "This involves 'deploy' (high-risk keyword).
Approval gate will require your confirmation."

User confirms: "Yes, proceed"

@bash-ops invokes c-agent:
  └─ [Confirmation 1]: "Proceed with c-agent execution?" → User: YES
  └─ [Detects 'deploy' keyword]
  └─ [Confirmation 2]: "CRITICAL: This task involves production deployment.
     Proceed?" → User: YES
  └─ Executes autonomously:
    • Creates .github/workflows/
    • Configures GitHub secrets
    • Sets up deployment targets
    • Creates rollback triggers
    • Validates pipeline

Step 3: Verification
────────────────────
User deploys test commit:
  ✓ Linting runs automatically
  ✓ Tests run and pass
  ✓ Deploy-to-staging triggered
  ✓ Rollback available if needed

Step 4: User Documents
──────────────────────
Ben delegates: "Document CI/CD process in docs/: how to trigger deploys,
check pipeline status, rollback if needed."

@doc:
  └─ Creates docs/ci-cd/
  └─ Writes process documentation
  └─ Includes troubleshooting guide
```

**Success Criteria Met**:
- ✅ Pipeline designed and documented
- ✅ Automated testing working
- ✅ Staging deployment functional
- ✅ Rollback mechanism verified
- ✅ Team can operate CI/CD independently

---

### Workflow 3: Documentation (Direct Execution)

**Scenario**: User wants comprehensive documentation for new API module.

```
Step 1: Delegate to @doc
────────────────────────
Ben delegates: "Write complete API documentation for src/payments/:
  • Overview
  • Endpoint reference
  • Type definitions
  • Working code examples
  • Security considerations
  • Error codes and handling

Scope to docs/api/payments/. Examples must be verified against actual
implementation."

@doc:
  └─ Reads src/payments/ implementation
  └─ Searches for existing tests/examples
  └─ Creates docs/api/payments/:
    ├─ README.md (overview)
    ├─ endpoints.md (API reference)
    ├─ examples.md (working code)
    ├─ security.md (security guide)
    └─ errors.md (error codes)
  └─ Verifies all examples compile/run
  └─ Cross-references validate
  └─ Markdown linting passes

[c-edit not necessary here—@doc has expertise and writes directly]

Step 2: User Verification
──────────────────────────
User reviews documentation:
  ✓ All examples work as documented
  ✓ Security considerations comprehensive
  ✓ Examples cover success and error cases
  ✓ Ready to publish
```

**Success Criteria Met**:
- ✅ Documentation complete and accurate
- ✅ Examples verified against implementation
- ✅ Cross-references validated
- ✅ Style consistent with existing docs

---

### Workflow 4: Debugging (Diagnosis → Fix → Verify)

**Scenario**: User reports intermittent timeouts in API endpoint. Need to diagnose and fix.

```
Step 1: Diagnose Root Cause (c-ask)
──────────────────────────────────
Ben delegates: "Analyze timeout issue in /api/users/:
  • Error logs: [provided]
  • Recent changes: [provided]
  • What's the root cause?"

@bash-ops invokes c-ask:
  └─ Analyzes logs and code
  └─ Identifies:
    • N+1 database queries in user endpoint
    • Missing query optimization
    • Cache not implemented
    → Recommendation: Add query optimization + caching

Step 2: Design Fix Strategy (c-plan)
───────────────────────────────────
Ben delegates, using diagnosis: "Design fix for N+1 query issue in /api/users/:
  1. What query optimization needed?
  2. Should we add caching? Where?
  3. Implementation phases?
  4. Risks?"

@bash-ops invokes c-plan:
  └─ Produces FIX-STRATEGY.md with:
    • Join optimization (fetch related data efficiently)
    • Redis caching (TTL: 5 min)
    • Invalidation strategy
    • Phase 1: Query optimization
    • Phase 2: Add caching
    • Phase 3: Monitor and verify

Step 3: Implement Fix (c-edit)
─────────────────────────────
Ben delegates: "Implement query optimization and caching per FIX-STRATEGY.md.
Scope to src/api/users/."

@bash-ops invokes c-edit --scope src/api/users/:
  └─ Optimizes database queries (add JOINs)
  └─ Adds Redis caching layer
  └─ Implements cache invalidation
  └─ All changes in src/api/users/

Step 4: Test Fix (c-agent)
──────────────────────────
Ben delegates: "Verify fix: run load test, verify timeout resolved,
check cache hit rates."

@bash-ops invokes c-agent:
  └─ Confirms execution
  └─ Executes:
    • Run load test against endpoint
    • Measure response times (should be <100ms)
    • Check cache hit rates (should be >80%)
    • Verify no regressions in other endpoints
    • Generate test report

Step 5: Deploy & Monitor
────────────────────────
User deploys fix to staging:
  ✓ Timeout resolved (response times <100ms)
  ✓ Cache hit rates >80%
  ✓ No regressions
  ✓ Ready for production deployment
```

**Success Criteria Met**:
- ✅ Root cause identified
- ✅ Fix designed and documented
- ✅ Implementation complete
- ✅ Testing verified improvement
- ✅ Ready for production

---

## Troubleshooting & Recovery

### "Mode Rejected My Request"

**Symptom**: Mode wrapper rejected your request or threw an error.

#### Error: "c-edit requires --scope flag"
```bash
# ❌ What you did:
c-edit -p "Add docstrings"

# ❌ Error:
Error: --scope flag is required

# ✅ Fix:
c-edit -p "Add docstrings" --scope src/handlers/

# Explanation:
c-edit Safety requires explicit scope boundaries.
Verify path exists: ls -la src/handlers/
```

#### Error: "Scope path does not exist"
```bash
# ❌ What you did:
c-edit -p "Fix types" --scope nonexistent/directory/

# ❌ Error:
Error: Scope path 'nonexistent/directory/' does not exist

# ✅ Fix:
# List available directories
ls -la src/

# Use existing directory
c-edit -p "Fix types" --scope src/api/

# Explanation:
--scope must point to actual filesystem location.
Can't use scopes that don't exist.
```

#### Error: "Operation blocked by deny-list"
```bash
# ❌ What you did:
c-agent -p "Install dependencies: npm install"

# ❌ Error:
Error: Operation 'npm install' is blocked by safety deny-list

# ✅ Fix:
# Option 1: Use a different approach
c-agent -p "Update package.json with new dependencies (don't install)"
# Then user runs: npm install locally

# Option 2: Document as limitation
# If installation required, escalate to Ben for architectural decision

# Explanation:
Package installation blocked to prevent supply chain attacks.
c-agent can't install packages automatically (intentional safety feature).
```

#### Error: "c-agent requires approval"
```bash
# ❌ Expectation: c-agent runs immediately

# ❌ Actual behavior:
Approve c-agent execution? (yes/no): _

# ✅ Fix:
# Type 'yes' and press Enter to approve
# Proceed when ready (no way to skip approval)

# Explanation:
c-agent approval gate is mandatory, not optional.
Every c-agent task requires explicit user confirmation.
```

### "Specialist Can't Interpret the Mode Hint"

**Symptom**: Specialist is unsure what mode hint means or how to proceed.

#### Situation: Ambiguous Mode Hint
```
❌ Poor hint:
"Implement feature X with c-plan/c-agent"

✅ Good hint:
"Implement feature X:
  1. c-plan: Design approach, identify risks
  2. c-agent: Execute implementation autonomously

  Deliverable: Working feature + test suite"
```

**Solution**:
- Make mode context explicit and actionable
- Specify what each mode should produce
- Include success criteria for each phase

#### Situation: Specialist Lacks Context
```
❌ Unclear delegation:
"Use c-edit to fix type errors"

✅ Clear delegation:
"Fix type errors in src/api/ (c-edit --scope src/api/):
  • Add missing type annotations
  • Fix any 'any' types
  • Ensure TypeScript strict mode passes

  Verification: tsc --strict src/api/ should pass"
```

**Solution**:
- Provide context about project/codebase
- Explain success criteria explicitly
- Include verification steps

### "Confirmation Gate Is Blocking Me"

**Symptom**: c-agent approval gate requires confirmation before proceeding.

#### Situation: Forgot to Approve
```
✓ Normal flow:
c-agent -p "Run tests"
→ Approval prompt appears
→ User types "yes"
→ Execution proceeds

✗ How approval can block you:
→ User types "no" or anything except "yes"
→ Operation rejected
```

**Solution**:
- Review task requirements carefully
- When ready to approve, type "yes" exactly
- Don't assume approval will happen automatically

#### Situation: High-Risk Keyword Triggers Double Confirmation
```
First confirmation:
→ "Approve c-agent execution?"
→ User types "yes"

Second confirmation (if high-risk keyword detected):
→ "CRITICAL: This involves [delete/deploy/push]. Confirm again?"
→ User must type "yes" AGAIN

Both must pass, or operation rejected.
```

**Solution**:
- Understand that dangerous operations need extra confirmation
- Expect multiple prompts for risky tasks
- Approve both gates if task is necessary

#### Situation: Approval Timeout
```
If user doesn't respond to approval prompt:
→ System waits indefinitely
→ Or times out after N seconds (depends on implementation)
→ Task is cancelled if timeout
```

**Solution**:
- Be ready to approve when invoking c-agent
- Don't invoke c-agent if you might be away
- Understand confirmation is not delayed—it's immediate

### "Need to Escalate Between Modes"

**Symptom**: Started with one mode, but task turned out to require another.

#### Situation: c-ask Insufficient, Need c-plan
```
Started with:
c-ask -p "How should we structure error handling?"

Realized:
Output is generic—need structured planning

Solution:
Delegate c-plan -p "Design error handling strategy for [specific context]"
(use c-ask output to inform c-plan prompt)
```

**Pattern**:
```
c-ask (diagnostic) → insufficient → escalate → c-plan (planning)
```

#### Situation: c-plan Complete, Need c-edit
```
Started with:
c-plan -p "Design refactoring strategy"

Realized:
Plan is great—ready to implement

Solution:
Delegate c-edit -p "Implement refactoring per [plan]" --scope [directory]
(use plan output as implementation guide)
```

**Pattern**:
```
c-plan (planning) → complete → escalate → c-edit (scoped implementation)
```

#### Situation: c-edit Insufficient, Need c-agent
```
Attempted:
c-edit -p "Set up test automation" --scope src/tests/

Problem:
c-edit can't execute shell commands (no test runner invocation)

Solution:
Escalate to c-agent:
Ben delegates: "Implement test automation (c-agent):
  1. Create test structure
  2. Run tests to verify
  3. Set up CI integration"
```

**Pattern**:
```
c-edit (scoped write) → insufficient → escalate → c-agent (autonomy + shell)
```

### "Implementation Exceeded Declared Scope"

**Symptom**: c-edit modified files outside declared --scope boundary.

**This is a safety violation.** Verification checkpoint:

```
c-edit -p "Fix types in src/handlers/" --scope src/handlers/

After execution:
- Ben verifies: Were only files in src/handlers/ modified?
- If yes: ✓ Scope respected
- If no: ✗ Scope violation - investigate why

Examples of violations:
- Modified src/middleware/ when scope was src/handlers/
- Modified src/handlers/index.ts (in scope) but also src/utils/ (out of scope)
```

**Response if Scope Violated**:
```
1. Document which files were unexpectedly modified
2. Revert changes that were out-of-scope
3. Investigate why specialist exceeded scope
4. Re-delegate with clearer scope boundaries OR use c-agent instead
```

**Prevention**:
- Make --scope boundaries tight and specific
- Verify after execution that changes respect scope
- If scope is ambiguous, use c-agent + approval instead

### "Task Kept Failing Despite Retries"

**Symptom**: Delegated task failed, specialist retried, still failing.

#### Diagnosis Steps
```
1. What was the task?
   - Does it fit the chosen mode?
   - Is mode appropriateness the problem?

2. What was the actual error?
   - Error message specific?
   - Reproducible?

3. Can the task be decomposed?
   - Break into smaller steps?
   - Use different modes?

4. Are prerequisites missing?
   - Does specialist have needed context?
   - Does specialist have needed access?
```

#### Common Failure Patterns

| Pattern | Cause | Solution |
|---------|-------|----------|
| c-ask insufficient | Question too complex | Escalate to c-plan |
| c-plan output ignored | Implementation skipped design | Create handoff checklist |
| c-edit exceeds scope | Boundaries too ambitious | Use c-agent instead |
| c-agent approval denied | User not ready | Plan first (c-plan), then ask approval |
| Missing context | Specialist unclear on requirements | Provide more detail in delegation |

#### Recovery Strategy
```
IF single_retry_failed:
  1. Pause and assess
  2. Is mode choice correct?
  3. Is scope realistic?
  4. Is context complete?
  5. Re-delegate with improvements

IF multiple_retries_failed:
  1. Escalate to Ben
  2. Task may need architectural change
  3. May require different specialist
  4. May require different approach entirely
```

---

## Best Practices & Patterns

### Progressive Escalation Principle

**Core Principle**: Always start with the minimum mode required, escalate only when necessary.

```
Escalation ladder (least to most intrusive):
  1. Can c-ask solve this? (Start here)
     → If yes: use c-ask
     → If no: escalate to step 2

  2. Can c-plan solve this?
     → If yes: use c-plan
     → If no: escalate to step 3

  3. Can c-edit solve this? (requires --scope)
     → If yes: use c-edit
     → If no: escalate to step 4

  4. Only use c-agent when absolutely necessary
     → Full autonomy required
     → Can't be decomposed into safer modes
     → User understands approval & risks
```

**Why Escalate?**
- Cost increases: Haiku << Sonnet ≈ Opus
- Latency increases: Haiku << Sonnet ≈ Opus
- Risk increases: Read-only << Scoped write << Full autonomy
- Approval burden increases: None → None → Gate required

### Scope as Control Mechanism

**Principle**: Narrow scope = better safety and more confident verification.

```
❌ Over-broad scope:
c-edit -p "Fix all type errors" --scope src/
→ Can't verify all files modified correctly
→ High risk of unintended changes
→ Difficult to review

✅ Appropriate scope:
c-edit -p "Fix all type errors in type definitions" --scope src/types/
→ Small, reviewable boundary
→ Clear intent (types only)
→ Easy to verify completeness
```

**Scope Selection Rules**:
1. **Atomic scope**: Can be reviewed in single pass
2. **Intentional scope**: Scope aligns with task intent
3. **Tight scope**: No unnecessary directories included
4. **Verifiable scope**: Easy to check all files in scope were treated

### Breaking Complex Tasks into Smaller Pieces

**When to use this strategy**: Task is complex, undefined, or risky.

```
Complex task:
"Refactor payment processing system"

❌ Wrong approach:
Delegate c-agent -p "Refactor entire payment system"
→ Too large, too risky, too much autonomy

✅ Right approach:
1. c-plan: "Design payment refactoring strategy"
2. c-edit: "Implement error handling" --scope src/payments/errors/
3. c-edit: "Implement transaction logic" --scope src/payments/transactions/
4. c-edit: "Update API interfaces" --scope src/payments/api/
5. c-ask: "Verify security and edge cases"

Benefits:
- Each step is manageable
- Risk is distributed across smaller scopes
- Verification happens at each step
- Can pivot or adjust after each phase
```

**Decomposition Framework**:
```
How to break a task:
1. Is the task complex (>3 substeps)?
2. Does it span multiple domains (auth, payments, etc.)?
3. Does it require planning before implementation?
4. Does automation add significant risk?

If YES to any: break into smaller tasks using progression above
```

### Structuring Multi-Step Workflows

**Pattern: Sequential Refinement**

```
Phase 1. Diagnostic    (c-ask)
         ↓
Phase 2. Planning      (c-plan)
         ↓
Phase 3. Implementation (c-edit or c-agent)
         ↓
Phase 4. Verification  (c-ask or testing)
```

**Pattern: Parallel Execution**

When tasks are independent:
```
Main task: Implement authentication module

Parallel subtasks:
  A. Design auth architecture (c-plan)
  B. Design database schema (c-plan)
  C. Design API endpoints (c-plan)

After A, B, C complete in parallel:
  D. Implement architecture (c-edit + c-agent)
  E. Implement schema (c-edit)
  F. Implement endpoints (c-edit)
  G. Test integration (c-agent)
```

**Pattern: Conditional Escalation**

```
IF simple_fix:
  → Use c-edit directly

ELSE IF complex_fix:
  → Start with c-plan
  → Then c-edit or c-agent based on plan
  → Then verify with c-ask

ELSE IF undefined_problem:
  → Start with c-ask (diagnose)
  → Then c-plan (design approach)
  → Then c-edit/c-agent (implement)
  → Then verify
```

### Lessons Learned from Real-World Usage

#### Lesson 1: Plan Before You Act
```
❌ Mistake: Delegate directly to implementation
   → Specialist executes, creates tech debt, poor design

✅ Practice: Always c-plan first
   → Validate approach before implementation
   → Surface risks early
   → Design reviewed before code written
```

#### Lesson 2: Scope is Your Safety Boundary
```
❌ Mistake: Use c-edit with --scope src/
   → Can't verify all changes
   → Scope too large

✅ Practice: Keep scopes tight
   Use --scope src/api/handlers/ not --scope src/
   → Verification manageable
   → Risk proportional
```

#### Lesson 3: Approval Gates Prevent Disasters
```
❌ Mistake: Expect people to remember to approve
   → They don't, accidents happen

✅ Practice: Make approval explicit
   → Tell user approval will be needed upfront
   → Give them time to review
   → Be present when they approve
```

#### Lesson 4: Break Complex Tasks Early
```
❌ Mistake: Delegate single mega-task
   → Fails partway through
   → Hard to retry or fix partial progress

✅ Practice: Break into 2-3 smaller tasks
   → Each can succeed/fail independently
   → Progress is visible
   → Easier to debug failures
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
10. **Troubleshoot**: Troubleshooting & Recovery section

---

## Document Version & Metadata

**Document**: CLI Mode Patterns & Orchestration Heuristics Comprehensive Guide
**Version**: 1.0
**Date**: March 31, 2026
**Status**: Production-ready
**Audience**: Orchestrators, specialists, power users
**Format**: Markdown (for SKILL.md packaging)
**Word Count**: ~9,200 words

---

**End of Comprehensive Guide**
