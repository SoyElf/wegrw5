# Instruction Engineering Best Practices

## Overview

Instruction engineering is the craft of writing agent instructions that guide behavior, quality standards, decision-making, and error handling. Well-engineered instructions produce high-quality agent behavior; poorly-engineered instructions produce unreliable results.

**Core Principle**: Instructions should be specific, structured, and prioritized. Use language carefully to signal importance levels.

---

## Structure and Organization

### Recommended Instruction Structure

```markdown
# [Agent Name]

## Role

"You are a [specialist type]..."
[One sentence defining primary focus]

## Responsibilities

[Bulleted list of what agent is accountable for]

## Constraints

[Bulleted list of what agent cannot/should not do]

## Quality Standards

[Specific criteria for success in this agent's domain]

## Tool Usage Guidance

[How to use tools effectively; include examples]

## Escalation Paths

[When and how to ask for help]

## Decision Framework

[How to think about tradeoffs and decisions]
```

**Why Structure Matters**: Agents process structured text more reliably than prose. Clear sections enable quick navigation and understanding.

---

## Role Definition

### Writing Effective Role Statements

**Good Examples**:
```
✓ "You are a documentation specialist. Your primary job is writing clear,
   well-structured technical documentation with accurate examples."

✓ "You are a code review agent. Your role is to identify bugs, suggest
   improvements, and ensure code meets project standards."

✓ "You are a research specialist. Your job is investigating complex topics,
   synthesizing findings with sources, and identifying knowledge gaps."
```

**Poor Examples**:
```
✗ "You are a helpful assistant"
  (Too generic; doesn't constrain behavior)

✗ "You are a documentation and coding and testing agent"
  (Too broad; violates specialization principle)

✗ "You help with documentation"
  (Vague; agent might not understand scope)
```

### Role Statement Guidelines

- ✓ Specific (documentation specialist, not "helper")
- ✓ Narrow (one primary focus, not multiple domains)
- ✓ Actionable (describes work the agent actively does)
- ✗ Generic (avoiding words like "helpful", "excellent", "smart")
- ✗ Broad (covering too many domains)

---

## Responsibility Statements

### Clear Responsibility Definition

**Format**: Bulleted list of specific, accountable tasks

```yaml
Responsibilities:
- Write clear API documentation with request/response schemas
- Create usage examples that compile and run correctly
- Maintain documentation style consistent with existing docs
- Update documentation when implementations change
- Verify cross-references and links are correct
```

**Each responsibility should**:
- ✓ Be specific (not just "improve documentation")
- ✓ Be measurable ("write documentation" → "write with examples and schemas")
- ✓ Include success indicators ("compile and run correctly")

---

## Constraint Statements

### Explicit Scope Boundaries

**Format**: "Cannot" statements that prevent overreach

```yaml
Constraints:
- Cannot modify application code (documentation only)
- Cannot delete existing documentation
- Cannot make architectural decisions
- Cannot run arbitrary shell commands
- Cannot deploy changes
```

**Why Constraints Matter**:
- Prevent agent from overstepping role
- Keep agent focused on specialization
- Reduce risk of agent making unwanted changes
- Make role boundaries clear

**Example Usage in Practice**:
```
Agent encounters uncertainty: "Should I also update the code comments
in the implementation?"

Agent refers to constraints: "Cannot modify application code"

Agent decision: "I'll document this in the API guide only, not in code comments"
```

---

## Quality Standards

### Domain-Specific Quality Criteria

**Documentation Agent**:
```
Quality Standards:

Documentation is well-written when:
✓ Syntax is valid (passes markdown linting)
✓ Examples compile and execute without errors
✓ Examples cover: success case, error case, edge cases
✓ Tone is clear and active voice (not passive)
✓ Style matches existing documentation
✓ All cross-references work
✓ No typos or grammatical errors

Documentation is NOT complete if:
✗ Just has text but no examples
✗ Examples don't actually work
✗ Style doesn't match rest of docs
✗ Missing critical use cases
```

**Code Review Agent**:
```
Quality Standards:

Code review is thorough when:
✓ Identifies real bugs or design issues
✓ Suggests specific improvements (not vague)
✓ Considers performance implications
✓ Checks adherence to style guide
✓ Verifies test coverage
✓ Spots subtle issues (not just obvious ones)

Code review is NOT sufficient if:
✗ Just has comments but no real issues
✗ Suggestions are vague ("improve this")
✗ Doesn't consider performance
✗ Overlooks obvious bugs
```

**Research Agent**:
```
Quality Standards:

Research findings are useful when:
✓ Include sources and citations
✓ Synthesized into clear structure
✓ Cover stated research scope completely
✓ Identify knowledge gaps and follow-up questions
✓ Complexity matches domain requirements

Research findings are NOT complete if:
✗ Make claims without sources
✗ Are just raw information (not synthesized)
✗ Miss important topics from scope
✗ Lack structure (hard to use for documentation)
```

---

## Tool Usage Guidance

### Example-Based Tool Instruction

**Pattern for File Modifications**:
```
When you need to modify existing files:

1. Read the file first
   use read_file to get current content and context

2. Identify exact replacement text
   Note: include 3-5 lines before/after target
   This prevents mismatches

3. Use replace_string_in_file with full context
   oldString: [3-5 lines before] + [target] + [3-5 lines after]
   newString: [3-5 lines before] + [updated target] + [3-5 lines after]

4. Verify changes
   use get_errors to check for any syntax issues

5. Report what changed
   Explain what you modified and why

Example:
  Old: "function processPayment(amount) {\n  validate(amount);\n  return charge(amount);\n}"
  New: "function processPayment(amount) {\n  validate(amount);\n  const result = charge(amount);\n  return result;\n}"
```

**Why Examples Work**: Agents follow by-example better than by-instruction.

### Tool Ordering Guidance

**Pattern for Multi-Step Tasks**:
```
When researching a feature:

1. Search for existing documentation
   → file_search in docs/
   → semantic_search for related concepts

2. Read implementation code
   → read_file to understand how feature works

3. Check tests for usage patterns
   → read_file on test files

4. Write documentation
   → create_file with content

5. Verify output
   → get_errors for syntax validation

Order matters: Search before reading, read before writing, write before verifying
```

---

## Language for Priorities

Use specific language to signal priority levels:

### Must (Highest Priority)

Use for non-negotiable requirements:
```
- Must include working examples
- Must verify changes before reporting success
- Must cite sources for research findings
```

### Should (High Priority)

Use for strong preferences:
```
- Should follow project style guide
- Should check for edge cases
- Should ask if unclear
```

### Consider (Medium Priority)

Use for suggestions:
```
- Consider whether examples should cover pagination
- Consider whether to update related documentation
- Consider performance implications
```

### Can/May (Optional)

Use for nice-to-haves:
```
- Can include additional examples if time permits
- May add cross-references to related topics
```

---

## Decision Frameworks

### Help Agents Make Good Decisions

**Documentation Example**:
```
When deciding how much to document:

Consider:
- Is this commonly used? → Document thoroughly
- Is this rarely used? → Document briefly
- Is this deprecated? → Mark clearly as deprecated, discourage use

If uncertain, ask: "Would a new developer understand how to use this?"
If answer is no, add more documentation.
```

**Code Review Example**:
```
When deciding whether to flag an issue:

Ask yourself:
- Could this cause a bug in production? → YES: Must flag
- Could this cause performance issues? → YES: Flag with reasoning
- Does this violate style guide? → YES: Flag
- Is this subjective opinion? → NO: Don't flag without objective reason

Only flag issues you can justify with code examples or style guide references.
```

---

## Error Handling Guidance

### Graceful Degradation Patterns

```
If reference files don't exist:
- Search for similar files you can use as reference
- Report which files you found instead
- Let orchestrator know if search unsuccessful
- Don't proceed with assumptions

If examples don't compile:
- Identify which example is broken and why
- Report the specific error to orchestrator
- Don't document broken examples
- Ask orchestrator to fix implementation first

If implementation details unclear:
- Document what you can understand
- Note what's unclear in your output
- Escalate to orchestrator for clarification
- Don't guess at behavior
```

---

## Common Instruction Mistakes

### ❌ Too Vague

```
✗ "Write good documentation"
✓ "Write documentation with: description, request/response schema,
   2-3 examples covering success and error cases"

✗ "Make sure the code is good"
✓ "Verify: syntax is valid, tests pass, performance is acceptable"
```

### ❌ Contradictory

```
✗ "Write concise documentation. Cover all edge cases."
  (Contradictory: thorough documentation isn't concise)

✓ "Write clear, focused documentation. Emphasize common use cases.
   Include edge cases in a separate 'Advanced' section."
  (Clear: what's emphasized vs. supplemental)
```

### ❌ Assumes Shared Knowledge

```
✗ "Follow the conventions"
  (What conventions? Which ones matter most?)

✓ "Follow conventions from docs/standards/style-guide.md:
   - Use active voice
   - Include 2-3 examples per concept
   - Format code with syntax highlighting"
```

### ❌ No Verification Step

```
✗ "Update the code"
  (No verification; agent might introduce bugs)

✓ "Update the code, then run get_errors to verify no syntax issues"
  (Explicit verification step)
```

---

## Instruction Template

```markdown
You are a [domain specialist]. Your role is [primary focus].

## Responsibilities

[Bulleted list of accountable deliverables]

## Constraints

[Explicit scope boundaries]

## Quality Standards

[Domain-specific "what good looks like"]

## Tool Usage

[Example-based guidance on using tools]

## Decision Framework

[How to think about tradeoffs]

## Escalation

[When and how to ask for help]

## Examples

[2-3 concrete examples of your work]
```

---

## References

- **Related**: [Agent Creation Checklist](<./agent-creation-checklist.md>) — checklist includes instruction quality checks
- **Related**: [Agent Definition and Fundamentals](<./agent-definition-and-fundamentals.md>) — agent configuration and structure
- **Related**: [Tool Composition and Design](<./tool-composition-patterns.md>) — detailed tool usage patterns
