# CLI Mode Patterns & Orchestrator Heuristics Research
## Synthesis of Ben Orchestrator Documentation

**Research Date**: March 31, 2026
**Source**: `.github/agents/ben.agent.md` + `copilot-modes-wrapper.sh` implementation
**Scope**: CLI mode selection framework, delegation patterns, model escalation, safety guardrails, confirmation protocols

---

**Quick Links**:
- 📖 **[Practical Guide: CLI Modes](<../guides/cli-modes-comprehensive-guide.md>)** — Implementation guide with real-world examples and workflows

---

## Executive Summary

The workspace's CLI mode system (c-ask, c-plan, c-edit, c-agent) implements a **progressive escalation architecture** for task execution, pairing operational complexity with appropriate model capability and safety controls. Ben uses mode-aware delegation patterns to signal task complexity to specialist agents, enabling autonomous decision-making about execution approach.

**Key Insight**: Modes are not commands to execute directly by agents—they are **organizational signals** that help specialists understand task scope and guide their execution strategy.

---

## 1. Mode Selection Decision Framework

### 1.1 Overview: The Four Modes

| Mode | Model | Task Complexity | Safety Profile | Cost/Latency | Primary Use |
|------|-------|-----------------|-----------------|--------------|-------------|
| **c-ask** | Claude Haiku 4.5 | Simple (single-step analysis) | Read-only (denies shell + write) | Fastest/lowest cost | Quick diagnostics, explanations, analysis |
| **c-plan** | Claude Sonnet 4.6 | Moderate (structured decomposition) | Read-only (denies shell + write) | Balanced | Planning, design, risk assessment, roadmaps |
| **c-edit** | Claude Sonnet 4.6 | Moderate with controlled scope | Scoped write (--scope required, denies shell) | Balanced | Safe file editing within declared boundaries |
| **c-agent** | Claude Opus 4.6 | Complex (multi-step autonomy) | Full with deny-list + approval gate | Highest cost/latency | Autonomous execution, state machines, complex workflows |

### 1.2 Mode Selection Decision Tree

```
START: Analyzing task requirements
  │
  ├─ Does task require EXECUTION or just ANALYSIS?
  │  │
  │  ├─ YES: ANALYSIS ONLY → Continue analysis path
  │  │  │
  │  │  ├─ Is analysis SIMPLE (quick answer, diagnostic)?
  │  │  │  ├─ YES → Use c-ask (Haiku 4.5, read-only)
  │  │  │  │  └─ EXAMPLES: Code explanation, error diagnosis, quick Q&A
  │  │  │  │
  │  │  │  └─ NO: Is analysis STRUCTURED (breaking into steps, planning)?
  │  │  │     ├─ YES → Use c-plan (Sonnet 4.6, read-only)
  │  │  │     │  └─ EXAMPLES: Design roadmaps, risk assessment, feature planning
  │  │  │     │
  │  │  │     └─ NO: Return to START with clarified task
  │  │  │
  │  └─ YES: EXECUTION REQUIRED → Continue execution path
  │     │
  │     ├─ Is execution SCOPED & SAFE (file edits within boundary)?
  │     │  ├─ YES → Use c-edit (Sonnet 4.6, scoped write, --scope flag)
  │     │  │  └─ CONDITION: --scope flag MUST be specified and exist
  │     │  │  └─ EXAMPLES: Docstrings, comments, contained refactoring
  │     │  │
  │     │  └─ NO: Does execution require FULL AUTONOMY (state machines, complex workflows)?
  │     │     ├─ YES → Check: Does task have HIGH-RISK keywords?
  │     │     │  ├─ YES → Use c-agent with DOUBLE CONFIRMATION
  │     │     │  │  └─ First confirmation: General approval gate
  │     │     │  │  └─ Second confirmation: High-risk keyword flag
  │     │     │  │  └─ EXAMPLES: Deploy, delete, push to production
  │     │     │  │
  │     │     │  └─ NO → Use c-agent with SINGLE CONFIRMATION
  │     │     │     └─ EXAMPLES: Test runner, build system, orchestration
  │     │     │
  │     │     └─ NO: Decompose into smaller, c-edit-compatible tasks
```

### 1.3 Detailed Mode Selection Heuristics

#### c-ask: Fast Advisory (Analysis Only)

**Select c-ask when:**
- Task requires quick understanding or diagnostic (< 5 min answer expected)
- Input is code, logs, or error messages needing explanation
- Output is analysis/explanation, not prescriptive code
- Cost/latency is prioritized over deep reasoning
- No file modifications needed

**Do NOT use c-ask when:**
- Task requires planning or step-by-step breakdown
- Task requires code generation/modification
- Task complexity demands deeper reasoning (→ use c-plan instead)

**Example prompts:**
```bash
c-ask -p "What error is in this stack trace?" < error.log
c-ask -p "Explain what this regex does"
c-ask -p "Why might this function be slow?"
```

**Ben's verification**: Verify output is diagnostic, not prescriptive. Accept if output is explanation/analysis. Reject if output proposes implementation (should have used c-plan).

---

#### c-plan: Strategic Planning (Design & Structure)

**Select c-plan when:**
- Task requires structured decomposition (breaking into steps)
- Output is roadmap, design, architecture proposal, or risk assessment
- Task is complex but structured (no real-time iteration needed)
- Input is feature specs, requirements, existing designs
- Task scope is understanding WHAT to do before HOW to do it

**Do NOT use c-plan when:**
- User just wants a quick explanation (→ use c-ask)
- You're ready to execute immediately (→ use c-edit or c-agent)
- Task is simple file editing (→ use c-edit directly)

**Example prompts:**
```bash
c-plan -p "Create deployment strategy for microservices" < architecture.md
c-plan -p "Design a test suite structure for our project"
c-plan -p "What are risks in this implementation approach?" < design.txt
```

**Ben's verification**:
- ✅ Output is structured (steps, phases, roadmap)
- ✅ Risk mitigations are documented
- ✅ Dependencies and sequencing are clear
- ✅ Output is feasible without missing constraints

---

#### c-edit: Safe File Editing (Scoped Write)

**Select c-edit when:**
- Task involves modifying files within a bounded scope
- --scope flag can be declared (and path exists)
- Files being modified are known and contained
- No shell interaction or complex orchestration needed
- Safe to allow write operations within declared boundary

**Must NOT use c-edit when:**
- --scope flag cannot be specified (→ escalate to @bash-ops)
- Scope path doesn't exist (error: path must exist)
- Task requires shell execution (→ use c-plan then c-agent)
- Multiple unrelated files in different directories (--scope too broad)

**Example prompts:**
```bash
c-edit -p "Add docstrings to all functions" --scope src/handlers/
c-edit -p "Update README with new API endpoints" --scope docs/
c-edit -p "Fix type annotations in util functions" --scope src/utils/
```

**Ben's verification**:
- ✅ --scope flag is present and path exists
- ✅ Edits are contained within scope (no out-of-scope files modified)
- ✅ No destructive operations (deletion in c-edit should be very limited)
- ✅ Modified files match original delegation intent

---

#### c-agent: Full Autonomy (Complex Workflows)

**Select c-agent when:**
- Task requires autonomous multi-step execution (no hand-offs needed)
- Task complexity demands Opus-level reasoning (state machines, intricate workflows)
- Specialist needs to orchestrate multiple tools/commands
- User explicitly requires approval before high-risk operations
- Task involves shell commands, system operations, or state-changing actions

**CRITICAL**: c-agent requires CONFIRMATION gate before execution. User must explicitly approve.

**Must NOT use c-agent for:**
- Simple tasks (→ use c-ask/c-plan)
- Tasks that can be scoped safely (→ use c-edit)
- Tasks without user approval (→ escalate for confirmation first)

**Example prompts:**
```bash
c-agent -p "Run comprehensive test suite with coverage analysis"
c-agent -p "Implement CI/CD pipeline with linting, tests, security scan"
c-agent -p "Execute zero-downtime deployment with rollback triggers"
```

**Ben's verification**:
- ✅ User understands confirmation gate will trigger
- ✅ High-risk keywords are disclosed before delegation
- ✅ Success criteria are measurable and verification is possible
- ✅ Fallback/rollback plan exists for failure scenarios

---

## 2. Model Selection Heuristics

### 2.1 Model Capability Escalation Principle

**Principle**: Select the MINIMUM model sufficient for the task to optimize cost and latency.

```
Haiku 4.5         Sonnet 4.6        Sonnet 4.6        Opus 4.6
(speed, cost)  →  (balance)    →    (scoped ops)  →   (reasoning, autonomy)
   c-ask           c-plan             c-edit            c-agent
   fast            moderate           moderate          deep
   cheap           balanced           balanced          expensive
   simple          structured         contained         complex
```

### 2.2 Model Selection Rules

| Task Trait | Select | Rationale |
|-----------|--------|-----------|
| Quick analysis, diagnostic | Haiku (c-ask) | Fast response, minimal reasoning needed, cost-effective |
| Planning, design, roadmaps | Sonnet (c-plan) | Balanced reasoning for structured decomposition |
| File editing with scope | Sonnet (c-edit) | Sufficient for constrained modifications |
| Complex multi-step workflows | Opus (c-agent) | Deep reasoning, state tracking, reasoning across steps |
| Large context (>600K tokens) | Gemini 3.1 Pro | Auto-escalation when context exceeds Haiku/Sonnet limits |

### 2.3 Large Context Handling

**Auto-escalation rule**: When input exceeds **600K tokens**:
- c-ask: Auto-switches from Haiku → Gemini 3.1 Pro
- c-plan: Auto-switches from Sonnet → Gemini 3.1 Pro
- c-edit: Uses explicit Gemini for very large scopes
- c-agent: Can use Gemini with `--model` override

**Example**:
```bash
# Large codebase analysis
cat huge-project/*.ts | c-ask -p "Find potential security issues"
# Automatically uses Gemini 3.1 Pro due to size

# Override model explicitly
c-ask -p "analyze" --model claude-opus-4.6 < huge-file.txt
```

---

## 3. Mode-Aware Delegation Patterns

### 3.1 Core Insight: Modes as Organizational Signals

**Key Understanding**: When Ben delegates a task with a mode hint, the specialist doesn't necessarily execute the CLI command directly. Instead:

- **c-ask/c-plan hints** → Specialist uses these to understand needed ANALYSIS before implementation
- **c-edit/c-agent hints** → Specialist decides whether to invoke wrapper directly OR recommend user invokes it
- **Specialist autonomy**: If specialist has expertise, they may bypass the wrapper and solve directly
- **Ben's role**: Provide mode context to guide specialist decision-making

### 3.2 Mode-Aware Delegation Pattern Template

**Template for delegating with mode hints:**

```
Delegate to @SPECIALIST:
"[Clear task statement with measurable success criteria]

Mode context:
- [c-ask]: Use for quick diagnostic of [specific aspect]
- [c-plan]: Use to structure [specific planning step]
- [c-edit]: Use to modify [specific files/scope]
- [c-agent]: Use for autonomous execution of [specific steps]

Deliverable: [Explicit output expected]"
```

**Specialist Interpretation Rules**:
- If specialist has high confidence, they may execute directly (preferred)
- If specialist lacks context/expertise, they invoke appropriate CLI mode
- If task requires user interaction (approval), specialist flags it
- If execution requires shell access, specialist invokes c-agent and manages confirmation gate

### 3.3 Real-World Delegation Example: Refactoring Task

```
Delegate to @bash-ops:
"Refactor the authentication module (src/auth/) to improve error handling.

Mode context:
- c-plan: First, create a refactoring roadmap showing:
  * Breaking changes (what will fail?)
  * Deprecation strategy (how to migrate?)
  * Risk assessment (what could go wrong?)

- c-edit: Then, implement changes scoped to src/auth/:
  * Error handling improvements
  * Type safety enhancements
  * Documentation updates

- c-ask: Finally, diagnostics on edge cases:
  * What error paths might still be problematic?
  * Any remaining type unsafety?

Success criteria:
✓ All error cases handled (no unhandled exceptions)
✓ Tests pass with >90% coverage
✓ Breaking changes documented in MIGRATION.md
✓ No external API changes (internal refactor only)

Deliverable: src/auth/ refactored + MIGRATION.md + test report"
```

**How specialist interprets this**:
1. **Expert path** (preferred): "@bash-ops reads mode hints, evaluates own expertise, and executes refactoring directly without invoking CLI modes"
2. **Standard path**: "@bash-ops uses c-plan to create roadmap, c-edit to implement within src/auth/, c-ask to verify edge cases"
3. **Escalation path**: "If unclear about edge cases, @bash-ops asks Ben for clarification before proceeding"

### 3.4 Verification Rules for Mode-Aware Delegations

**Ben's verification**, after specialist executes:

✅ **Specialist received clear mode context** (modes explained, not just mentioned)
✅ **Success criteria align with chosen modes** (c-ask shouldn't expect code output, c-agent output should be autonomous result)
✅ **If c-agent recommended**: User was informed approval gate will trigger
✅ **Output is verified** against mode-appropriate success criteria

---

## 4. Safety Guardrails & Deny-List Patterns

### 4.1 Universal Deny-List (All Modes)

**Operations blocked universally** across all modes:

| Category | Denied Tools | Rationale |
|----------|--------------|-----------|
| **Privilege Escalation** | `sudo`, `su` | Prevent privilege escalation attacks |
| **Credential Access** | `read-secrets`, `vault-access` | Prevent credential leakage |
| **Package Management** | `apt`, `npm`, `pip` (installation only) | Prevent supply chain attacks |
| **Network Exfiltration** | Whitelist-only network requests | Prevent data leakage |
| **System Modification** | `systemctl`, `launchctl` | Prevent system destabilization |

### 4.2 Mode-Specific Deny Patterns

#### c-ask Safety Profile
```
Allowed: Read (file access, analysis)
Denied:  shell (no shell execution)
         write (no file modifications)

Security Model: Read-only analysis, safe for user-provided code/logs
```

#### c-plan Safety Profile
```
Allowed: Read (file access, analysis)
Denied:  shell (no shell execution)
         write (no file modifications)
         external (deny external API requests by default)

Security Model: Read-only planning, safe for design tasks
```

#### c-edit Safety Profile
```
Allowed: write (within --scope flag boundary ONLY)
Denied:  shell (no shell execution)
         external (deny external API requests)

Security Model: Scoped file write, safe when --scope is declared and exists
```

#### c-agent Safety Profile
```
Allowed: All tools EXCEPT universal deny-list
Denied:  [apply universal deny-list above]

Security Model: Full autonomy with guardrails, requires approval gate
```

### 4.3 How Deny-Lists Are Enforced

**Implementation**:
```bash
# In copilot-modes-wrapper.sh
declare -a DENY_LIST=(
  "sudo"
  "read-secrets"
  "vault-access"
  # ... more entries
)

# Built into each mode's copilot invocation
COPILOT_MODEL="$model" copilot \
  -p "$prompt" \
  --deny-tool "shell" \
  --deny-tool "write" \
  --scope "$scope" \
  2>/dev/null
```

**Ben's responsibility**: Never suggest overriding deny-lists or approval gates. These are safety-critical features.

---

## 5. Confirmation Gate Protocols (c-agent Mode)

### 5.1 Confirmation Gate Architecture

**c-agent mode has TWO-LEVEL confirmation architecture:**

```
Level 1: General Approval Gate
└─ "Approve c-agent execution?"
└─ Applied to ALL c-agent tasks
└─ User must type "yes" to proceed
└─ Purpose: Explicit user consent for autonomous execution

  └─ IF prompt contains HIGH-RISK KEYWORDS:
     Level 2: High-Risk Confirmation
     └─ "CONFIRM: This task involves [HIGH-RISK operation]"
     └─ Additional confirmation gate triggered
     └─ Purpose: Extra caution for dangerous operations
```

### 5.2 High-Risk Keywords Triggering Confirmation

**Keywords that trigger DOUBLE confirmation:**

```
delete, remove, destroy, drop, truncate  [Data destruction]
deploy, push, production                 [Production impact]
chmod, chown                             [Permission/ownership changes]
sudo                                     [Privilege escalation]
```

**Example flow**:

```bash
# Regular c-agent task (no high-risk keywords)
c-agent -p "Run test suite and report results"
  → Shows Level 1 confirmation only
  → User types "yes" → Proceeds

# High-risk c-agent task
c-agent -p "Delete old log files from /var/logs/"
  → Shows Level 1 confirmation
  → User types "yes"
  → Detects "delete" keyword → Shows Level 2 confirmation
  → User types "yes" AGAIN → Proceeds

# User rejected (either level)
c-agent -p "Deploy to production"
  → Shows confirmation
  → User types "no" or anything except "yes"
  → Operation cancelled, logged as "cancelled"
```

### 5.3 Ben's Role in Confirmation Gates

**Before delegating c-agent task to specialist:**

1. **Identify high-risk keywords** in the planned task
2. **Inform user explicitly**: "This will require approval before execution"
3. **Disclose what will be approved**: "Specialist will ask you to confirm: [operation]"
4. **If user hesitates**: Offer c-plan first to design approach, THEN c-agent

**Example escalation dialogue:**

```
User: "I want to clean up old deployment artifacts"

Ben: "This might require deletion (high-risk operation).
Should I:
  A) First use c-plan to design cleanup strategy (low-risk, advisory)
  B) Delegate to @bash-ops to implement cleanup (will require your approval)
  C) Something else?"

User: "Let's plan first"

Ben: →  Delegates c-plan: "Design cleanup strategy for deployment artifacts"
    →  After plan, delegates c-agent with explicit confirmation flag
```

### 5.4 Confirmation Decision Logging

**Ben logs after each c-agent delegation:**

```
Operation:        c-agent delegation
Specialist:       @bash-ops
Task:            "Deploy service to staging"
High-risk:       YES (keyword: deploy)
Confirmation:    Required
User approved:   YES / NO
Date:            [timestamp]
Notes:           [outcome notes]
Tags:            c-agent-confirmation, deployment
```

**Purpose**: Track patterns of high-risk operations, learn user approval patterns, identify risky task clusters.

---

## 6. Real-World Workflow Sequences

### 6.1 Workflow Pattern 1: Analysis → Planning → Implementation

**Scenario**: User wants to refactor a complex module

```
User: "Refactor src/payments to improve error handling"

Ben's decision flow:
  1. START with c-plan (understand what refactoring entails)
  2. THEN delegate c-edit (implement within src/payments/)
  3. FINALLY use c-ask (diagnose edge cases)

Ben's orchestration:
  Step 1 → Delegate to @bash-ops: "Design refactoring strategy (c-plan)"
           Output: Roadmap with breaking changes, migration path

  Step 2 → Delegate to @bash-ops: "Implement refactoring (c-edit --scope src/payments)"
           Output: Refactored module, MIGRATION.md

  Step 3 → Delegate to @bash-ops: "Verify edge cases (c-ask)"
           Output: Analysis of remaining issues

Ben's verification:
  ✅ c-plan output validates feasibility before implementation
  ✅ c-edit boundaries prevent scope creep
  ✅ c-ask confirms safety of final code
```

**When to use this pattern:**
- Complex refactoring with unknown breaking changes
- Tasks requiring careful planning before action
- High-risk modifications needing validation

---

### 6.2 Workflow Pattern 2: Plan → Agent with Approval

**Scenario**: User wants to automate a build/deployment process

```
User: "Set up automated testing in CI/CD"

Ben's decision flow:
  1. PLAN the CI/CD structure (c-plan)
  2. EXECUTE the automation (c-agent with approval)

Ben's orchestration:
  Step 1 → Delegate: "Design CI/CD pipeline structure (c-plan)"
           Input: Current project structure, test requirements
           Output: Pipeline roadmap, stage breakdown

  Step 2 → Ben evaluates: "This involves deployment (high-risk keyword)"
           Ben informs user: "Will require your approval before proceeding"

  Step 3 → User approves plan

  Step 4 → Delegate: "Implement CI/CD automation (c-agent)"
           Pre-delegation: "This will trigger approval gate. Approve? YES/NO"
           Output: Configured pipeline, test passing

Ben's verification:
  ✅ c-plan output provided clear architecture
  ✅ User understood approval requirement before c-agent
  ✅ c-agent executed with proper confirmation gates
```

**When to use this pattern:**
- Autonomous workflows requiring planning first
- Tasks with high-risk keywords (deploy, push, delete)
- Multi-step orchestration needing transparency

---

### 6.3 Workflow Pattern 3: Direct Edit (Single-Step)

**Scenario**: User wants to add documentation to code

```
User: "Add docstrings to all functions in src/handlers"

Ben's quick decision:
  ✅ Scoped task (affects only src/handlers/)
  ✅ Safe modification (documentation, non-destructive)
  ✅ No planning needed
  → Use c-edit directly

Ben's orchestration:
  Delegate: "Add comprehensive docstrings (c-edit --scope src/handlers/)"
           Option: Specialist executes directly OR invokes c-edit wrapper
           Output: Modified files with docstrings

Ben's verification:
  ✅ --scope flag is correct and path exists
  ✅ Docstrings are added (non-destructive)
  ✅ File modifications are minimal and scoped correctly
```

**When to use this pattern:**
- Simple, scoped modifications
- Documentation/comment improvements
- Small refactors with clear scope
- No state-changing operations

---

### 6.4 Workflow Pattern 4: Diagnostic → Action

**Scenario**: User encounters error, wants fix

```
User: "Why is the API timing out? Fix it."

Ben's decision flow:
  1. DIAGNOSE with c-ask (quick analysis of problem)
  2. PLAN with c-plan (understand fix approach)
  3. EXECUTE with c-edit/c-agent (implement fix)

Ben's orchestration:
  Step 1 → Delegate: "Diagnose timeout causes (c-ask)"
           Input: Error logs, stack trace
           Output: Root cause analysis

  Step 2 → Based on diagnosis, choose:
           - If simple fix: Delegate c-edit with scope
           - If complex fix: Delegate c-plan then c-agent

  Step 3 → Implement and verify

Ben's verification:
  ✅ c-ask output correctly identified root cause
  ✅ Chosen implementation mode matches fix complexity
  ✅ Verification confirms timeout is resolved
```

**When to use this pattern:**
- Reactive problem-solving workflows
- Undefined problems needing diagnosis first
- Error-driven task decomposition

---

## 7. Cost & Latency Considerations

### 7.1 Model Cost/Latency Profile

```
Speed:    Haiku >> Sonnet ≈ Opus
Cost:     Haiku << Sonnet ≈ Opus
Reasoning: Haiku < Sonnet < Opus
```

### 7.2 Cost Optimization Heuristics

**Principle**: Use minimum sufficient model

| Scenario | Cost Optimization |
|----------|------------------|
| Quick diagnostic | Use Haiku (c-ask) instead of Opus |
| Planning only | Use Sonnet (c-plan) instead of Opus (no complexity gain) |
| Large context | Use Gemini (auto-escalation) if available |
| Time-sensitive | Use Haiku/Sonnet instead of Opus (faster response) |
| Deep reasoning | Use Opus (complex state machines, only path) |

### 7.3 Latency Considerations

**For user-facing tasks:**
- c-ask (Haiku): ~2-5 seconds typical response
- c-plan (Sonnet): ~5-15 seconds typical response
- c-edit (Sonnet): ~5-15 seconds typical response
- c-agent (Opus): ~15-30+ seconds typical response

**Strategy**: Use faster modes when possible, but don't sacrifice quality for speed.

---

## 8. Key Insights & Decision Heuristics

### 8.1 Mode Selection Rules of Thumb

1. **Default to c-ask, escalate only when needed**
   - Start with fast analysis (c-ask)
   - Only escalate to planning (c-plan) or execution if needed
   - Avoids unnecessary cost and latency

2. **Use c-plan as "confirmation check" before c-agent**
   - Don't jump directly to c-agent for complex tasks
   - Use c-plan to validate approach first
   - Prevents failed executions and wasted resources

3. **c-edit scope MUST be declared and verified**
   - Never use c-edit without --scope flag
   - Scope path must actually exist
   - Scope should be "tight" (not overly broad directories)

4. **c-agent requires approval for EVERY task**
   - There's no "pre-approved" mode
   - Every invocation triggers confirmation gate
   - High-risk keywords trigger double confirmation

5. **Prefer specialist expertise over modes**
   - Specialists don't HAVE to use CLI wrapper
   - If specialist can solve directly, they should
   - Modes are guidance, not requirements

### 8.2 Common Mistakes & Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Using c-ask for planning | Model insufficient for structured decomposition | Use c-plan instead |
| c-edit without --scope | Allows uncontrolled modifications | Always require --scope |
| Skipping c-plan before c-agent | Leads to failed autonomous execution | Plan first, execute second |
| Overriding denial gates | Bypasses safety guardrails | Escalate instead of overriding |
| Treating modes as direct commands | Specialist doesn't understand context | Provide mode hints in delegation |
| Large scope for c-edit | Difficult to verify, high risk | Narrow scope or use c-agent |

### 8.3 Escalation Decision Logic

**When to escalate (escalation pathways):**

```
IF task_exceeds_mode_scope(current_mode):
  ESCALATE to higher mode (ask → plan → edit/agent)

IF high_risk_keywords && specialist_unsure:
  ESCALATE to user for approval confirmation

IF specialist_lacks_expertise:
  ESCALATE to Ben for better agent selection

IF scope_too_broad_for_edit:
  ESCALATE to c-agent instead of forcing c-edit

IF multiple_independent_subtasks:
  ESCALATE to parallel delegation (not sequential)
```

---

## 9. Mode Hinting Decisions

### 9.1 How to Structure Mode Hints

**Bad mode hint** (unclear):
```
"Please refactor src/auth with mode hints provided."
```

**Good mode hint** (explicit and actionable):
```
Mode context:
- c-plan: Structure refactoring steps, identify breaking changes
- c-edit: Implement within src/auth/ (scoped write)
- c-ask: Validate edge cases and error paths

Choose the approach that fits your expertise level.
```

### 9.2 When to Provide Multiple Modes

**Provide mode hints when:**
- Task is complex (3+ steps)
- Task has multiple possible execution approaches
- Task involves significant risk (c-agent approval likely)
- Specialist autonomy in execution approach is valuable

**Don't provide mode hints when:**
- Task is simple and obvious (single step)
- Only one reasonable approach exists
- Task is already well-defined and scoped

---

## 10. Implementation Notes for Specialists

### 10.1 Specialist Decision Logic

**When receiving mode-hinted delegation:**

```
IF I have high confidence in approach:
  └─ Execute directly (faster, preferred)
ELSE IF task is simple (c-ask scope):
  └─ Invoke c-ask wrapper
ELSE IF task requires planning (c-plan scope):
  └─ Invoke c-plan wrapper
ELSE IF task is scoped file edit:
  └─ Invoke c-edit wrapper (with --scope)
ELSE IF task requires full autonomy:
  └─ Invoke c-agent wrapper (handle approval gate)
ELSE:
  └─ Escalate to Ben with clarifying questions
```

### 10.2 Approval Gate Handling

**When c-agent execution is triggered:**

```
1. Specialist invokes c-agent mode
2. Wrapper shows confirmation prompt
3. User types "yes" or "no"
   - IF "yes": Proceed with execution
   - IF "no": Operation cancelled, specialist retries with Ben approval
4. If high-risk keyword detected:
   - Wrapper shows SECOND confirmation
   - User must confirm again explicitly
5. If all confirmations pass:
   - Specialist executes autonomously
   - Logs outcome for Ben's learning
```

---

## 11. Foundational Patterns Emerging

### 11.1 Progressive Escalation as Safety Principle

The mode system implements **privilege escalation by default**:

```
Read-only (c-ask, c-plan)  →  Scoped write (c-edit)  →  Full autonomy (c-agent)
     ↑                               ↑                         ↑
  Lowest risk               Medium risk (scope-gated)   Highest risk (approval-gated)
```

**Philosophy**: Start permissive (read-only), escalate only when needed.

### 11.2 Scope as Control Mechanism

Both c-edit and --scope flag demonstrate **scope as safety control**:

- c-edit enforces --scope flag (no boundary = error)
- Boundary is also verification point for Ben
- Scope narrowness correlates with safety

### 11.3 Approval Gates as Social Control

c-agent approval gate isn't just technical—it's **social control**:

- Forces user to think before autonomous execution
- High-risk keywords trigger extra confirmation (extra thinking time)
- Double confirmation for dangerous keywords
- Creates audit trail of approvals for learning

### 11.4 Model Selection as Capability Matching

Mode-to-model mapping is **capability matching**, not arbitrary:

```
Simple analysis  →  Haiku (fast, sufficient)
Structured work  →  Sonnet (balanced reasoning)
Complex autonomy →  Opus (deep reasoning)
```

Cost and reasoning power increase together with complexity.

---

## 12. Research Gaps & Follow-Up Questions

### 12.1 Unanswered Questions

1. **Race conditions in shared context**: How do multiple agents avoid conflicts when using shared `.github/context/` directory?
2. **Confirmation gate timing**: What's the timeout for approval gates? What happens if user doesn't respond?
3. **Deny-list extensibility**: Can deny-lists be customized per specialist or task type?
4. **Model fallback logic**: What happens if Opus is unavailable? How does fallback to Sonnet work?
5. **Approval audit trail**: Where are approval decisions logged for compliance/audit?

### 12.2 Recommended Follow-Up Research

- [ ] Deep dive into approval gate implementation and timeout mechanisms
- [ ] Investigate deny-list customization and extension patterns
- [ ] Research multi-agent coordination race conditions in shared context
- [ ] Document approval audit trail for governance/compliance

---

## References

**Ben Orchestrator Documentation**
- File: `.github/agents/ben.agent.md`
- Sections reviewed:
  - GitHub Copilot CLI Modes Architecture (lines 96-165)
  - Mode Selection Decision Framework (lines 175-280)
  - Mode-Aware Delegation Pattern (lines 645-690)
  - Confirmation Gate Protocol (lines 721-791)
  - Safety Boundaries & Governance (lines 911-965)

**Wrapper Implementation**
- File: `copilot-modes-wrapper.sh`
- Components reviewed:
  - DENY_LIST configuration (lines 28-36)
  - Confirmation gate functions (lines 117-148)
  - Mode functions (c-ask, c-plan, c-edit, c-agent; lines 150-490)
  - Logging and utilities (lines 117-597)

**Related Documentation**
- [CLI Modes Comprehensive Guide](<../guides/cli-modes-comprehensive-guide.md>) — Implementation guidance and practical examples

---

## Version & Metadata

**Document Version**: 1.0
**Created**: March 31, 2026
**Research Duration**: Single research session
**Research Status**: Complete (ready for @doc skill documentation)
**Quality Verification**:
- ✅ All major claims sourced from ben.agent.md and wrapper.sh
- ✅ Decision frameworks are complete (all modes covered)
- ✅ Real-world examples provided for each pattern
- ✅ Workflow sequences illustrate mode composition
- ✅ Follow-up questions identified for future research
- ✅ No contradictions between sources detected

**For @doc**: This document provides the conceptual framework and patterns for comprehensive CLI mode documentation. Suggested next steps:
1. Expand decision trees into interactive flowcharts
2. Create mode-specific tutorials with hands-on examples
3. Build approval gate/confirmation gate runbooks
4. Develop troubleshooting guides for common mistakes
5. Create glossary and quick-reference cards
