# Debugging Multi-Agent Systems

## Overview

Debugging multi-agent systems requires different approaches than debugging single agents or traditional code. You're debugging communication flows, state transitions, and interdependencies, not just code execution.

**Core Approach**: Make the invisible visible by instrumenting coordination and communication points.

---

## Debugging Levels

### Level 1: Communication Level (Easiest)

**Focus**: What messages passed between agents and orchestrator?

**Key Questions**:
- What did orchestrator ask of Agent A?
- What did Agent A report back?
- What did orchestrator then ask of Agent B?
- Did Agent B receive full context from A's output?

**Tools**:
- Read agent output messages
- Review delegation text
- Check file-based context passing (.tmp/ files)
- Trace sequence of agent invocations

**Example Debugging Session**:
```
Problem: @doc documentation was inconsistent across sections

Debugging steps:
1. Review what @ben delegated to @doc:
   → "Document sections 1-50 of framework"

2. Check @doc's output:
   → Sections 1-20: High quality, consistent style
   → Sections 21-50: Different style, inconsistent referencing

3. Root cause: Single long delegation → context loss midway

4. Fix: Have @ben re-delegate with checkpoints:
   → Phase 1: @doc sections 1-25 (completed)
   → Phase 2: @doc sections 26-50 (with reference to phase 1 outputs)
```

---

### Level 2: State Level

**Focus**: What state changed? When? Why?

**Key Questions**:
- What files existed before task?
- What files exist after task?
- Did output files appear in expected locations?
- Did expected intermediate files get created?

**Tools**:
- `ls -la` to check file existence/modification times
- `git status` to see what changed
- File content inspection (do files have expected content?)

**Example Debugging Session**:
```
Problem: @research created findings but @doc couldn't find them

Debugging steps:
1. Check what @research reported:
   → ".tmp/research-findings.json created"

2. Verify file exists:
   → ls -la .tmp/ → YES, file exists with recent timestamp

3. Check file content validity:
   → cat .tmp/research-findings.json | head → Valid JSON

4. Verify @doc was told correct path:
   → Delegation to @doc said: ".tmp/research-findings.json"

5. Check if @doc actually read it:
   → @doc report said: "File not found: .tmp/research-findings.json"

Root cause: Subtle path discrepancy or @doc not searching current working directory

Fix: Have @doc use absolute path or run from correct directory
```

---

### Level 3: Coordination Level

**Focus**: Did task sequencing work correctly?

**Key Questions**:
- Did Agent A complete before Agent B started (if sequential)?
- Did agents run in parallel (if parallel intended)?
- Where did sequential task "wait" for prerequisite?
- Did orchestrator properly coordinate handoff?

**Tools**:
- Timestamps on file creation
- Agent execution logs
- Orchestrator's task tracking

**Example Debugging Session**:
```
Problem: @doc created documentation but @research's findings incomplete

Debugging steps:
1. Check timestamps:
   @doc report time: 14:32
   @research report time: 14:35
   → @doc finished BEFORE @research!

2. Root cause: @ben delegated to both simultaneously
   → @doc didn't have research findings yet
   → @doc guessed at design, created incorrect documentation

3. Fix: Sequence tasks
   → Delegate to @research FIRST
   → Wait for completion
   → THEN delegate to @doc with research findings as input
```

---

### Level 4: Agent Behavior Level (Hardest)

**Focus**: Why did agent make specific decision or take specific action?

**Key Questions**:
- Why did agent choose this tool?
- Why did agent interpret instructions this way?
- Why did agent escalate this as blocker?
- Did agent actually read the reference files I provided?

**Tools**:
- Review agent's full reasoning/output
- Check what files agent actually read
- Verify agent followed instruction sequence
- Test agent instructions in isolation

**Approach**:
```
1. Extract agent's exact input (delegation text)
2. Review agent's output/reasoning
3. Trace through instruction steps
4. Identify where agent diverged from expected behavior
5. Check if instructions were ambiguous or clear
6. Test updated instructions
```

**Example Debugging Session**:
```
Problem: @doc created API documentation but didn't include error cases

Debugging steps:
1. Review delegation:
   Delegation included: "Include: endpoint description, request schema,
                        response schema, error cases, examples"

2. Review @doc output:
   → Sections: description ✓, request schema ✓, response schema ✓
   → Missing: error cases, examples

3. Check if @doc's instructions mention error cases:
   → Yes: "Document error cases that API can return"

4. Hypothesis: @doc didn't understand what "error cases" means

5. Fix: Make instructions more specific:
   "Include error cases:
    - 404 when resource not found
    - 400 when validation fails
    - 429 when rate limited
    Include 1 example for each error case"

6. Re-delegate with explicit examples
```

---

## Debugging Workflow

### Step 1: Understand the Problem

**What's observable?**
- Unexpected output (quality issue? missing content? wrong format?)
- Missing output (files not created?)
- Cascading failure (task A failed → Task B blocked?)
- Inconsistent behavior (sometimes works, sometimes doesn't?)

**Document**:
- What was expected?
- What actually happened?
- When did it happen?
- Which agent(s) were involved?

---

### Step 2: Locate the Failure Point

**Is the failure in**:
- Communication? (orchestrator didn't tell agent something important)
- Agent execution? (agent couldn't do what was asked)
- Dependencies? (prerequisite task didn't complete)
- Tool use? (agent used wrong tool or wrong sequence)
- Specification? (instructions were unclear or wrong)

**Debug at communication level first**:
1. Review orchestrator delegation
2. Review agent response
3. Check hand-off to next agent
4. Look for gaps in context passing

---

### Step 3: Verify Preconditions

**If agent failed to produce output**:
```
1. Did agent have necessary context?
   → Review delegation text

2. Did agent have necessary tools?
   → Check agent configuration

3. Did agent have necessary reference files?
   → Verify file existence and readability

4. Were there unmet prerequisites?
   → Check if prior tasks completed
   → Verify outputs passed to current agent
```

---

### Step 4: Examine Agent Behavior

**If agent produced wrong output**:
```
1. Did agent understand the task?
   → Is task description ambiguous?
   → Are success criteria clear?

2. Did agent follow instructions?
   → Trace through instruction steps
   → Did agent take different path?

3. Did agent make assumptions?
   → Did agent assume file locations?
   → Did agent assume naming conventions?

4. Did agent verify its work?
   → Were verification steps included in instructions?
   → Did agent report verification results?
```

---

### Step 5: Fix and Test

**Fix options**:
1. **Communication fix**: Clarify delegation, add missing context
2. **Specification fix**: Make instructions clearer, less ambiguous
3. **Tool fix**: Add tool composition examples, guide sequence
4. **Reference fix**: Provide style guides, examples, conventions

**Test**:
```
1. If using same agent: Re-delegate with fix
2. If using new agent: Create test case to verify fix works
3. If cascading fix: Re-run dependent tasks
4. Verify all outputs
```

---

## Debugging Tools and Techniques

### Technique 1: Execution Traces

**What**: Record sequence of what agent did

```
Execution trace for @doc task:
1. Read delegation: "Write documentation for payment API"
   ✓ Understood task

2. Search for reference files: "doc /docs/api/"
   ✓ Found: docs/api/existing-api.md

3. Read reference: docs/api/existing-api.md
   ✓ Extracted style: active voice, 3-5 examples per section

4. Search for implementation: "find src/payment"
   ✗ Search failed / returned unexpected results

5. Escalate: "Cannot find implementation files"
   ✗ FAILURE POINT
```

Trace shows exactly where agent got stuck.

---

### Technique 2: Context Snapshots

**What**: Capture input/output at each agent boundary

```
Context snapshot at @doc handoff:

Input from @ben:
{
  task: "Write API documentation",
  reference_style: "docs/api/existing.md",
  reference_implementation: "src/payment/index.ts",
  expected_output: "docs/api/payment.md"
}

Output from @doc:
{
  status: "completed",
  file_created: "docs/api/payment.md",
  sections: ["description", "request-schema", "response-schema"],
  verified: "markdown linting passes"
}

Snapshot shows: @doc created output but didn't include error cases
→ Specification issue: "error cases" not in expected output list
```

---

### Technique 3: Tool Usage Logging

**What**: Record which tools agent used and in what order

```
Tool usage log for @doc task:

1. semantic_search ("payment API documentation style")
2. read_file ("docs/api/existing-api.md")
3. file_search ("src/payment/*")
4. read_file ("src/payment/index.ts")
5. create_file ("docs/api/payment.md")
6. get_errors ("markdown lint docs/api/payment.md")

Analysis:
- Good: Search → read → create → verify sequence
- Good: Verified output with linting
- Potential issue: Only read one reference file
  → Could have searched for more examples
```

---

## Debugging Checklist

**When something goes wrong**:

- [ ] **Communication level**: Is orchestrator asking clearly? Is agent receiving full context?
- [ ] **State level**: Do expected files exist? Were they created?
- [ ] **Coordination level**: Did tasks run in correct order? Did one task wait for prerequisite?
- [ ] **Agent level**: Did agent understand task? Follow instructions? Verify work?
- [ ] **Preconditions**: Did agent have necessary context? Tools? References?
- [ ] **Specification**: Were instructions clear? Success criteria explicit?

**Fix prioritization**:

1. **Communication issues** (highest impact): Fix unclear delegation
2. **Specification issues** (high impact): Make instructions more explicit
3. **Coordination issues** (medium impact): Fix task sequencing
4. **Tool usage issues** (medium impact): Provide tool composition examples
5. **Agent behavior issues** (lower impact): Tune instructions for specific agent behavior

---

## References

- **Related**: [Common Failure Modes](<./common-failure-modes.md>) — what typically fails and why
- **Related**: [Inter-Agent Communication](<./inter-agent-communication.md>) — communication patterns to understand
- **Related**: [Effective Delegation Strategies](<./effective-delegation-strategies.md>) — delegation best practices
- **Related**: [Orchestrator-Worker Case Study: Ben and Specialist Agents](<./orchestrator-worker-case-study.md>) — real failures encountered
