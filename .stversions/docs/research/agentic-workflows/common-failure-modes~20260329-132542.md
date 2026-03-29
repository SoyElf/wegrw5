# Common Failure Modes

## Overview

Understanding common failure modes in agentic workflows enables prevention through better design. Research shows 79% of failures stem from specification/coordination gaps, not capability limitations.

**Key Insight**: Most failures are PREVENTABLE through better planning and communication, not sophisticated error handling.

---

## Specification Failures (45% of Total)

### Failure 1: Overly Broad Agent Scope

**Symptom**: Single agent produces mediocre documentation AND code AND DevOps setup

**Root Cause**: Agent attempts to be generalist instead of specialist

**Prevention**:
- ✓ Create focused agents per domain (doc specialist, code specialist, DevOps specialist)
- ✓ Delegate complex tasks to multiple specialists sequentially
- ✓ Ensure agent instructions are focused on ONE domain

**Recovery**:
1. Identify where quality dropped (documentation? code? operations?)
2. Create new specialist agent for that domain
3. Re-delegate using specialist agent

**Example**:
```
✗ FAILURE: "Create documentation AND implement feature AND setup CI/CD"
  → General-purpose agent tries all three, fails at all three

✓ PREVENTION:
  Task 1: @ben analyzes → determines 3 sub-tasks
  Task 1a: @doc creates documentation
  Task 1b: @developer implements feature
  Task 1c: @devops sets up CI/CD
  → Each specialist succeeds in their domain
```

---

### Failure 2: Insufficient Context in Delegation

**Symptom**: Agent creates output that doesn't match project style/conventions

**Root Cause**: Orchestrator didn't provide style guides, examples, or context

**Prevention**:
- ✓ Always include style guides / references
- ✓ Provide specific file examples ("see docs/api/existing.md for format")
- ✓ Set explicit conventions ("use Oxford commas, active voice")

**Recovery**:
1. Ask agent to revisit output with correct context
2. Delegate with complete style guide references
3. Have agent verify against reference documents

**Example**:
```
✗ FAILURE: "Write documentation"
  → Agent writes good documentation that doesn't match project style

✓ PREVENTION: "Write documentation matching style in docs/api/existing.md.
  Use: Active voice, Oxford commas, 2-3 examples per concept."
```

---

### Failure 3: Unclear Success Criteria

**Symptom**: Agent delivers output, but it doesn't meet expectations

**Root Cause**: Agent and orchestrator have different definitions of "done"

**Prevention**:
- ✓ Define explicit, measurable success criteria
- ✓ Use checkboxes and quantifiable standards
- ✓ Include examples of "done" vs "not done"

**Recovery**:
1. Provide success criteria now
2. Have agent self-validate against criteria
3. Re-delegate with clear standards

**Example**:
```
✗ FAILURE:
  Orchestrator: "Write good documentation"
  Agent: Writes documentation
  Orchestrator: "This isn't what I wanted"
  → Expectation mismatch

✓ PREVENTION:
  "Documentation is complete when:
   ✓ All 5 endpoints documented
   ✓ Request/response schemas included
   ✓ 2-3 examples per endpoint
   ✓ Examples compile and run
   ✓ Markdown passes linting
   ✗ Just having text is not enough"
```

---

## Coordination Failures (34% of Total)

### Failure 4: Tool Misuse or Missing Tools

**Symptom**: Agent can't complete task despite having capability

**Root Cause**: Agent doesn't have right tools OR uses wrong tool sequence

**Prevention**:
- ✓ Include tool composition examples in instructions
- ✓ Specify tool order ("search first, then modify, then verify")
- ✓ Restrict agent to appropriate tools (not too many options)

**Recovery**:
1. Review tool composition: did agent use best tool for each step?
2. Provide examples of correct tool sequences
3. If tool missing, grant access or delegate elsewhere

**Example**:
```
✗ FAILURE:
  Agent tries to modify file without reading context first
  Result: Replacement string doesn't match, file not modified

✓ PREVENTION:
  "When modifying files:
   1. read_file to get current content
   2. Identify exact string to replace (with 3-5 lines context)
   3. replace_string_in_file with full oldString/newString
   4. get_errors to verify syntax"
```

---

### Failure 5: Dependency Not Satisfied

**Symptom**: Agent B starts work before Agent A completes prerequisite

**Root Cause**: Orchestrator didn't explicitly state dependencies

**Prevention**:
- ✓ Explicitly state task dependencies
- ✓ Sequence tasks: don't start B until A completes
- ✓ State which tasks can run in parallel

**Recovery**:
1. Identify missing prerequisite
2. Complete prerequisite task
3. Re-delegate dependent task with full context from prerequisite

**Example**:
```
✗ FAILURE:
  @doc starts writing API documentation
  But @research hasn't completed findings yet
  Result: @doc guesses at design, creates incorrect documentation

✓ PREVENTION:
  Step 1: Delegate to @research
  Step 1 completed: receive findings
  Step 2: Delegate to @doc with findings as input
  Explicit sequencing prevents out-of-order execution
```

---

### Failure 6: Context Loss Mid-Task

**Symptom**: Agent starts strong, loses context partway through, produces inconsistent output

**Root Cause**: Very long task; agent loses initial context

**Prevention**:
- ✓ Break long tasks into smaller, re-delegated subtasks
- ✓ Use checkpoints: complete subtask, return to orchestrator for next subtask
- ✓ For complex workflows, plan before delegating

**Recovery**:
1. Identify where consistency breaks
2. Re-delegate second half of task with explicit context from first half
3. Merge outputs

**Example**:
```
✗ FAILURE:
  @doc: "Write comprehensive guide covering 50 topics" (single delegation)
  Result: Topics 1-10 are great, topics 40-50 are inconsistent

✓ PREVENTION:
  Delegation 1: @doc - "Write sections 1-15, cite style guide"
  Completion 1: return to orchestrator
  Delegation 2: @doc - "Continue sections 16-30, maintain tone from 1-15"
  Completion 2: return to orchestrator
  Delegation 3: @doc - "Finish sections 31-50, maintain consistency throughout"
```

---

## Tool Composition Failures (15% of Total)

### Failure 7: Insufficient Verification

**Symptom**: Agent modifies code/docs, doesn't verify, introduces bugs

**Root Cause**: No verification step in tool composition

**Prevention**:
- ✓ Always include verification: get_errors after modifications
- ✓ Example checks: syntax, linting, type checking
- ✓ Semantic checks: do examples still work with modifications?

**Recovery**:
1. Identify what wasn't verified
2. Run verification (get_errors, test examples, etc.)
3. Fix issues

**Example**:
```
✗ FAILURE:
  Agent replaces function signature
  Doesn't check for compilation errors
  Code is now broken but agent reports "success"

✓ PREVENTION:
  "1. Identify functions using old signature with grep_search
   2. Update all call sites with replace_string_in_file
   3. Run get_errors to check for type errors
   4. Report: 'Updated X functions, verified no type errors'"
```

---

### Failure 8: Hidden Assumptions

**Symptom**: Agent assumes file locations, naming conventions, or project structure

**Root Cause**: Agent didn't search/verify before using

**Prevention**:
- ✓ Always search before assuming ("find files with semantic_search")
- ✓ Verify structure ("list_dir to confirm project layout")
- ✓ Don't assume standard project names/locations

**Recovery**:
1. Have agent search for assumed resources
2. If not found, escalate to orchestrator for clarification
3. Complete task with discovered structure

**Example**:
```
✗ FAILURE:
  Agent assumes: "Config is in src/config.ts"
  Reality: Config is in config/app.config.ts
  Result: Agent can't find file, task fails

✓ PREVENTION:
  "First, search for config files: file_search 'config.*'
   Then use whatever files were found
   Don't assume naming or locations"
```

---

## Recovery and Prevention Summary

| Failure Type | Prevention | Recovery | Likelihood |
|---|---|---|---|
| Broad scope | Specialize agents | Create specialist agent | High |
| Insufficient context | Include style guides, examples | Provide context, re-delegate | High |
| Unclear success criteria | Explicit, measurable standards | Define criteria, re-validate | High |
| Tool misuse | Include tool composition examples | Provide tool order examples | Medium |
| Unmet dependencies | Explicit sequencing, state dependencies | Complete prerequisite, re-delegate | Medium |
| Context loss | Break long tasks into subtasks | Re-delegate with checkpoints | Medium |
| Unverified changes | Always verify after modifications | Run verification, fix | Medium |
| Hidden assumptions | Search/verify before using | Search for actual structure | Low |

---

## Prevention Checklist

Before delegating, verify:

- [ ] **Scope is narrow and well-defined** (not too broad)
- [ ] **Context is complete** (style guides, examples, references provided)
- [ ] **Success criteria are explicit** (measurable, checkable)
- [ ] **Tool composition guidance** (if task involves modifications, include verification step)
- [ ] **Dependencies stated** (what must complete first?)
- [ ] **Task is appropriately sized** (can specialist complete in one focused sequence?)
- [ ] **Escalation paths clear** (when should specialist ask for help?)
- [ ] **Assumptions minimal** (no hidden assumptions about structure/naming)

---

## Learning from Failures

When a failure occurs:

1. **Identify failure type** (was it scope? context? coordination? tool use?)
2. **Determine root cause** (not just symptom)
3. **Implement prevention** (don't just fix this instance, prevent next occurrence)
4. **Update agent instructions** (if tool composition fix needed)
5. **Document pattern** (so team learns)

---

## References

- **Related**: [Agent Definition and Fundamentals](<./agent-definition-and-fundamentals.md#common-pitfalls>) — detailed pitfalls within VS Code agents
- **Related**: [Debugging Multi-Agent Systems](debugging-multi-agent-systems.md) — how to diagnose failures
- **Related**: [Tool Composition and Design](<./tool-composition-patterns.md>) — best tool usage patterns
- **Related**: [Effective Delegation Strategies](<./effective-delegation-strategies.md>) — prevention through good delegation
