# Effective Delegation Strategies

## Overview

Effective delegation is how an orchestrator agent assigns work to specialists and ensures they have everything needed to succeed. Poor delegation creates failure; good delegation enables high-quality outputs.

**Core Principle**: Provide complete context, clear success criteria, and failure recovery options.

---

## Delegation Framework

### Element 1: Clear Task Statement

**What**: Specific description of what needs to be done

**Good Example**:
```
"Write API documentation for the new payment endpoint.
The endpoint is in src/payment/endpoints.ts (function: createPaymentIntent).
Include: endpoint description, request schema, response schema, error cases,
2-3 usage examples. Keep the tone consistent with docs/api/existing-api.md."
```

**Poor Example**:
```
"Document the payment stuff"
```

**Why Good Version Works**:
- Specific file reference (specialist knows where to look)
- Specific output format expectations
- Reference to related documentation (maintain consistency)
- Example count clarifies scope

### Element 2: Background Context

**What**: Why is this work important? What problem does it solve?

**Good Example**:
```
"This payment feature is part of our Q2 roadmap to enable recurring subscriptions.
Users are asking for clear documentation on how to integrate this into their
applications. Currently, we have poor API docs which is blocking adoption."
```

**Poor Example**:
```
(No context provided)
```

**Why Context Matters**:
- Specialist understands importance
- Can make good quality/scope tradeoffs
- If blocked, understands what to escalate
- Increases agent investment in quality

### Element 3: Success Criteria

**What**: Explicit, measurable standards for success

**Good Example**:
```
Success criteria:
✓ Documentation syntax is valid (passes markdown lint)
✓ All examples compile and run correctly
✓ Examples cover: basic usage, error handling, pagination
✓ Tone and formatting match docs/api/existing-api.md
✓ Cross-referenced from main API documentation index
✗ Document just exists (too low a bar)
```

**Poor Example**:
```
"Make documentation good"
(Too vague; specialist doesn't know what "good" means)
```

**Why Explicit Criteria**:
- Specialist knows when task is done
- Removes ambiguity
- Enables self-validation
- Creates measurable quality standards

### Element 4: Relevant Context and Resources

**What**: Files, examples, references specialist should use

**Good Example**:
```
Reference files:
- Implementation: src/payment/endpoints.ts
- Tests: tests/payment.test.ts (shows usage patterns)
- Similar docs: docs/api/orders-api.md (reference style)
- Style guide: CONTRIBUTING.md (voice/formatting)

Related feature is in: docs/features/subscription.md
```

**Poor Example**:
```
(No references provided; specialist has to search)
```

**Why Resource Lists Matter**:
- Specialist doesn't waste time searching
- Knows exactly what they need to understand
- Can find consistent examples
- Reduces guesswork about conventions

### Element 5: Scope Boundaries

**What**: What is IN scope? What is OUT of scope?

**Good Example**:
```
In Scope:
- API endpoint documentation
- Usage examples
- Integration with existing SDK

Out of Scope:
- SDK internal implementation details
- Database schema documentation
- Frontend usage patterns (covered elsewhere)
```

**Poor Example**:
```
(Specialist decides what's in/out of scope; often wrong)
```

**Why Scope Matters**:
- Prevents scope creep
- Specialist knows what NOT to do
- Clear definition of done
- Prevents "but what about..." questions

### Element 6: Failure Recovery Options

**What**: If task encounters blockers, what should specialist do?

**Good Example**:
```
If you encounter blockers:
1. Implementation details unclear?
   → Check tests/payment.test.ts for usage patterns
   → If unclear, escalate to orchestrator for clarification

2. API behavior different than expected?
   → Ask me (orchestrator) to verify with engineering
   → Don't assume; document what you find and ask

3. Examples don't compile?
   → Report which example fails and why
   → Don't skip examples; let orchestrator fix implementation first
```

**Poor Example**:
```
(No guidance; specialist either guesses or silently fails)
```

**Why Escalation Matters**:
- Specialist knows when to ask for help
- Prevents wrong assumptions
- Enables visible failure recovery
- Better than silent failure + bad output

---

## Delegation Quality Checklist

Before delegating, verify:

- [ ] **Task is specific**: Could another specialist understand exactly what's needed?
- [ ] **Background explains why**: Does specialist understand importance?
- [ ] **Success criteria are explicit**: Could specialist self-validate completion?
- [ ] **Resources are listed**: Has specialist all references needed?
- [ ] **Scope is clear**: Does specialist know what's NOT included?
- [ ] **Escalation paths exist**: Does specialist know when to ask for help?
- [ ] **Examples provided**: For complex tasks, did you show an example?
- [ ] **Dependencies stated**: Are any dependencies on other agents/tasks clear?

---

## Delegation Patterns by Complexity

### Pattern 1: Simple, Well-Scoped Task

**Delegation Style**: Focused, concise

```
@doc:
"Document the 'listPayments' endpoint in src/payment/endpoints.ts

Include: description, request params, response schema, 2 examples.
Reference style from docs/api/orders-api.md.

Success: Examples compile, syntax valid, matches existing doc style.

If blocked: Escalate to orchestrator."
```

**Token Efficiency**: ~80 tokens; very focused

---

### Pattern 2: Moderately Complex Task

**Delegation Style**: Detailed context + clear structure

```
@research:
"Research agentic workflows for multi-agent systems.

Background: We're building an agent orchestration hub. Need to understand
best practices for VS Code agents, Copilot CLI extensions, and multi-agent
orchestration patterns.

Output: Structured findings document (~2000 words) covering:
- Foundational concepts
- Implementation patterns
- Real-world successful examples
- Common failure modes
- Tools and frameworks

Format: Create .tmp/2026-03-29-agentic-workflows-comprehensive-research.json
Include sources and citations.

Success:
✓ Covers all stated topics
✓ Provides sources for key claims
✓ Usable by @doc for documentation creation
✓ Identifies follow-up research questions

If unclear: Escalate for scope confirmation"
```

**Token Efficiency**: ~150 tokens; includes context, resources, success criteria

---

### Pattern 3: Complex Multi-Step Task

**Delegation Style**: Detailed context + step-by-step guidance + multiple checkpoints

```
@doc:
"Create comprehensive zettelkasten documentation for agentic workflows.

Background: Framework document for best practices. Atomic/interconnected notes.
Input research: .tmp/2026-03-29-agentic-workflows-comprehensive-research.json

Output Structure:
1. INDEX.md as MOC (map of contents)
   - All notes listed with brief descriptions
   - Cross-references between related notes

2. Atomic notes (flat hierarchy, semantic names):
   - agent-definition-and-fundamentals.md
   - vscode-custom-agents-overview.md
   - vscode-agent-file-specification.md
   - multi-agent-orchestration-principles.md
   - github-copilot-cli-capabilities.md
   [+ additional notes based on research findings]

3. Each atomic note:
   - Focused on one concept/topic
   - Includes forward/backward links
   - Real-world examples where appropriate
   - 500-1500 words

Success:
✓ All files created in docs/research/agentic-workflows/
✓ No numbered filenames; semantic naming
✓ Single MOC cross-references all notes
✓ Backlinks between related notes
✓ Markdown syntax valid
✓ Comprehensive per research findings

If blocked on:
- File structure? → Reference zettelkasten.de for examples
- What to include? → Determine from research.json contents
- Unclear prerequisites? → Escalate for clarification"
```

**Token Efficiency**: ~250 tokens; extensive detail but necessary for complex task

---

## Tailoring Delegation to Agent Type

### Delegating to Specialist (e.g., @doc)

**Context to Include**:
- Primary task focus
- Style/convention references
- Examples to maintain consistency
- Clear success standards for domain

**Context NOT to Include**:
- How to do their job (they're specialist!)
- Architectural decisions (outside their scope)
- Implementation details they don't need

**Example**:
```
✓ "Write documentation matching style from docs/api/existing.md"
✓ "Examples should show: success case, error case, pagination"
✗ "Update the docstring by modifying the JSDoc comment like this..."
  (Too prescriptive; specialist knows their domain better)
```

### Delegating to Generalist/Research Agent

**Context to Include**:
- Research scope and depth
- Sources to consult
- Expected output format
- What matters most

**Context NOT to Include**:
- How to discover sources (researcher is specialist)
- What they'll find (it's unknown!)
- Specific conclusions to reach

**Example**:
```
✓ "Research agentic workflow best practices, focus on VS Code + Copilot CLI"
✓ "Output: Structured JSON with findings, sources, follow-up questions"
✗ "You should research X, Y, Z and conclude..."
  (Research needs to be open-ended to be useful)
```

### Delegating to Task Runner (e.g., @git-ops)

**Context to Include**:
- Specific operation (create branch, commit, etc.)
- Naming conventions
- Approval requirements
- What to do on failure

**Context NOT to Include**:
- Why the operation matters (already decided)
- How to use git (they're CLI specialist!)

**Example**:
```
✓ "Create feature branch from main: feature/payment-api-docs
   Recommendation: use conventional commits for messages"
✗ "Create a branch by running: git checkout -b..."
  (Too prescriptive; specialist knows git)
```

---

## Effective Delegation in Practice

### Real Delegation: Complex Research + Documentation

```
Orchestrator@ben to @research:

"Research agentic workflows fundamentals and best practices.

Scope:
- VS Code custom agents and how they work
- GitHub Copilot CLI and its extensibility
- Multi-agent orchestration patterns
- Real-world examples and case studies
- Common failure modes and how to prevent them

Output: Create .tmp/research-findings.json with:
{
  research_topic: "...",
  findings: {
    section_1: { ... },
    section_2: { ... },
    ...
  },
  summary: "Key takeaway points",
  applicable_to_agents: ["@ben", "@doc", ...],
  follow_up_questions: [...]
}

Depth: Comprehensive - cover foundations, patterns, real-world, all levels
Time estimate: This will be substantial research, budget accordingly

Sources expected: VS Code docs, GitHub Copilot docs, academic papers on
agent systems, observed patterns from this workspace, real codebases on GitHub

If unclear: Ask for scope confirmation. Happy to narrow if needed.
If sources unavailable: Let me know what's hard to research.

Success: Usable by @doc to create comprehensive documentation framework"
```

Then, after research completes:

```
Orchestrator@ben to @doc:

"Create atomic zettelkasten documentation using research findings.

Input: .tmp/research-findings.json (from @research)

Output: Flat directory structure in docs/research/agentic-workflows/:
- INDEX.md as master index/MOC
- Semantic-named atomic notes (agent-specialization-patterns.md, etc.)
- No numbered files
- Each note: 500-1500 words, interconnected

Key Requirements:
✓ Atomic: Each file focuses on one concept
✓ Cross-referenced: Links between related notes
✓ Comprehensive: Cover all levels (foundation to advanced)
✓ Real-world examples from the research

If unclear on file organization: Reference Obsidian/zettelkasten.de patterns.
If research gaps: Note them in INDEX's follow-up section.

Success: Documentation framework is complete, well-organized, interconnected"
```

---

## Anti-Patterns in Delegation

### ❌ Vague Task Descriptions

```
✗ "Make documentation good"
✓ "Write API documentation including request/response schemas and 2-3 examples.
   Match the style of docs/api/existing.md. Examples must compile."
```

### ❌ Missing Success Criteria

```
✗ "Document the feature"
✓ "Documentation is complete when:
   ✓ All 4 endpoints documented
   ✓ Examples provided for each
   ✓ No broken internal links
   ✓ Markdown passes linting"
```

### ❌ No Escalation Paths

```
✗ (Agent gets stuck, doesn't know who to ask)
✓ "If implementation design unclear, escalate to orchestrator.
   If examples don't compile, let me know the error."
```

### ❌ Inconsistent Context

```
✗ Sometimes provide references, sometimes don't
✓ Every delegation consistently includes: background, resources, success criteria,
   escalation paths
```

---

## References

- **Related**: [Multi-Agent Orchestration Principles](<./multi-agent-orchestration-principles.md>) — orchestration framework
- **Related**: [Agent Specialization Patterns](<./agent-specialization-patterns.md>) — tailoring delegation to specialist types
- **Related**: [Inter-Agent Communication](<./inter-agent-communication.md>) — communication when delegating
- **Related**: [Orchestrator-Worker Case Study: Ben and Specialist Agents](<./orchestrator-worker-case-study.md>) — real examples of delegation
