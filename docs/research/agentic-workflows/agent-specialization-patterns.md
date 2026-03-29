# Agent Specialization Patterns

## Overview

Agent specialization is the principle that agents should have narrow, well-defined expertise areas rather than attempting to be general-purpose problem solvers. Specialization improves quality, reliability, accountability, and token efficiency.

**Core Insight**: Specialists outperform generalists in multi-agent systems. A documentation specialist consistently produces better documentation than a general-purpose agent who also handles coding, research, and DevOps.

---

## Specialization Benefits

### Benefit 1: Higher Quality Outputs

Specialized agents produce better work within their domain:

- Documentation specialist writes clear, consistent, well-structured docs
- Code reviewer spots subtle bugs, design issues, style violations
- Research specialist synthesizes findings with proper context and citations

**Why**: Specialized instructions can focus on domain-specific quality criteria. A focused agent needs fewer tokens and context to understand expectations.

### Benefit 2: Clear Accountability

When something goes wrong, specialization makes diagnosis easier:

- If documentation is poor quality → documentation specialist's instructions/context need improvement
- If code review misses bugs → code review agent's analysis depth needs improvement
- NOT: "Something in the general agent's behavior broke"

### Benefit 3: Simpler Debugging

Focused agents are easier to test and improve:

- Document agent's test cases: does it follow style guide? Create clear examples? Add cross-references?
- Code review agent's test cases: does it find common bug patterns? Suggest performance improvements?
- Each agent has specific, measurable success criteria

### Benefit 4: Better Token Efficiency

Fewer instructions needed for specialists:

```
# Generalist agent (all in one):
- Instructions for documentation writing (detailed)
- Instructions for code review (detailed)
- Instructions for DevOps (detailed)
- Instructions for research (detailed)
- Total: 2,000+ tokens in instructions

# Specialist approach:
- Doc agent: 400 tokens of documentation-specific instructions
- Review agent: 400 tokens of code-review-specific instructions
- DevOps agent: 400 tokens of deployment-specific instructions
- Research agent: 400 tokens of research-specific instructions
- Total: 1,600 tokens, more focused per agent, higher quality per token
```

---

## Role Definition Framework

Define each agent using this framework:

### Element 1: Domain

**What specific area does this agent specialize in?**

```
✓ Documentation specialist (clear, narrow domain)
✗ Documentation and coding and DevOps (too broad)

✓ Code review for performance (specific focus)
✗ Code review (vague; could include style, architecture, security)
```

### Element 2: Responsibilities

**What is this agent accountable for delivering?**

Examples:

```yaml
Documentation Specialist:
  - Write clear READMEs for projects
  - Create API documentation with examples
  - Update guides when features change
  - Ensure documentation is discoverable and indexed

Code Review Agent:
  - Identify potential bugs and security issues
  - Suggest performance improvements
  - Check adherence to code style
  - Verify tests have good coverage

DevOps Agent:
  - Deploy approved changes to staging
  - Manage infrastructure as code
  - Monitor deployment health
  - Rollback failed deployments
```

### Element 3: Constraints

**What is this agent NOT allowed to do?**

**Why important**: Prevents agents from overstepping roles, maintains clear boundaries

Examples:

```yaml
Documentation Specialist:
  - Cannot modify application code
  - Cannot delete documentation
  - Cannot make deployment decisions
  - Cannot run arbitrary shell commands

Code Review Agent:
  - Cannot modify code directly (only suggests)
  - Cannot approve and merge PRs alone
  - Cannot run arbitrary tests (uses predefined test runners)
  - Cannot deploy code

Research Agent:
  - Cannot implement solutions (research only)
  - Cannot modify code (findings only)
  - Cannot execute code (analysis only)
```

### Element 4: Available Tools

**What specific tools does this agent have access to?**

Derives from domain + responsibilities + constraints

```yaml
Documentation Specialist:
  - file_search (docs/** only)
  - semantic_search
  - create_file (docs only)
  - replace_string_in_file (docs only)
  - read_file
  - get_errors (markdown lint)
  - NOT: run_in_terminal, delete_file

Code Review Agent:
  - semantic_search
  - grep_search
  - get_errors (linting, types, tests)
  - read_file
  - create_file (comments/suggestions only)
  - NOT: replace_string_in_file, run_in_terminal (arbitrary commands)
```

### Element 5: Success Criteria

**How do we know this agent succeeded?**

Explicit, measurable criteria:

```yaml
Documentation Specialist:
  ✓ Documentation is syntactically valid (passes markdown lint)
  ✓ Examples are complete and runnable
  ✓ Style matches project conventions (voice, formatting)
  ✓ Cross-references are correct (links work)
  ✗ Success if just "wrote something"

Code Review Agent:
  ✓ Identified real bugs or design issues
  ✓ Suggestions are actionable (include specific improvements)
  ✓ Found both obvious and subtle issues
  ✗ Success if just "found some problems"

Research Agent:
  ✓ Findings cite sources and evidence
  ✓ Complexity matches domain understanding
  ✓ Synthesis is clear and structured
  ✗ Success if just "did research"
```

### Element 6: Escalation Paths

**When and how does this agent escalate to orchestrator?**

Defines boundaries:

```yaml
Documentation Specialist:
  - Escalate if unclear what examples should do
  - Escalate if documentation style contradicts multiple examples
  - Escalate if breaking documentation (requests orchestrator guidance)

Code Review Agent:
  - Escalate if found critical security issue
  - Escalate if uncertain whether behavior is bug or feature
  - Escalate if performance issue is architectural (beyond scope)

Research Agent:
  - Escalate when findings are complete (analysis done, implementation needed)
  - Escalate if sources contradict (uncertain findings)
```

---

## Real-World Specialization Model: Ben Workspace Example

### Ben (Orchestrator)

**Domain**: Task orchestration and delegation

**Responsibilities**:
- Analyze user requests and extract key requirements
- Determine which specialist agents are needed
- Delegate work with full context
- Coordinate parallel/sequential execution
- Synthesize specialist outputs for user

**Constraints**:
- Never implements solutions directly
- Always delegates to specialists
- Cannot modify code/docs/infrastructure

**Tools**: Agent invocation, file reading, context passing

---

### @doc (Documentation Specialist)

**Domain**: Technical documentation and writing

**Responsibilities**:
- Write clear, well-structured READMEs and guides
- Create API documentation
- Update guides when features change
- Add helpful code comments

**Constraints**:
- Cannot modify code beyond comments
- Cannot make architectural decisions

**Tools**: File search, create, edit (docs only), semantic search

---

### @research (Research Specialist)

**Domain**: Investigation and synthesis of complex topics

**Responsibilities**:
- Research agentic patterns, VS Code APIs, infrastructure
- Synthesize findings into clear documentation
- Provide sources and evidence
- Identify gaps and follow-up questions

**Constraints**:
- Research only; doesn't implement
- Cannot modify code or deployment

**Tools**: Web search, semantic search, file reading, content extraction

---

### @git-ops (Development Operations)

**Domain**: Git operations and deployment workflow

**Responsibilities**:
- Create branches and manage commits
- Enforce conventional commit format
- Manage PR workflows
- Handle deployment orchestration

**Constraints**:
- Only manages git operations
- Cannot modify code directly (delegates to developers)
- Requires approval for deployments

**Tools**: Git operations, file creation (commits), shell (git commands only)

---

## Anti-Patterns to Avoid

### ❌ Over-Specialization

**Problem**: Agent so specialized it can't handle any variation

```
✗ "Document Writer - Only writes function documentation"
✓ "Documentation Specialist - Writes all forms of technical documentation"
```

**Balance**: Specialize by domain/responsibility, not by task type.

### ❌ Under-Specialization

**Problem**: Agent broad enough to be a generalist again

```
✗ "Codes, reviews, tests, deploys" (basically everything)
✓ "Implements features following code review feedback"
```

**Rule**: If instruction manual for agent exceeds 1,000 tokens, probably too broad.

### ❌ Conflicting Responsibilities

**Problem**: Specialization creates conflicts of interest

```
✗ Agent reviews its own code (conflict of interest)
✗ Agent approves its own deployments (conflict of interest)
✓ Separate: implementation agent writes code → review agent reviews → DevOps agent deploys
```

---

## Specialization Evolution

As systems grow, specialization can deepen:

**Phase 1** (Simple): 3-5 broad specialists (doc, code, research, DevOps, testing)

**Phase 2** (Growing): Break out specialized sub-agents within domains
- Documentation → technical writing specialist + API documentation specialist
- Code → implementation specialist + code review specialist
- DevOps → infrastructure specialist + deployment specialist

**Phase 3** (Mature): Domain teams with sub-orchestrators
- Documentation team (lead + specialists)
- Engineering team (lead + implementation/review specialists)
- Operations team (lead + infrastructure/deployment specialists)

---

## References

- **Related**: [Multi-Agent Orchestration Principles](<./multi-agent-orchestration-principles.md>) — how specialized agents coordinate
- **Related**: [Effective Delegation Strategies](<./effective-delegation-strategies.md>) — how orchestrator assigns work to specialists
- **Related**: [Agent Definition and Fundamentals](<./agent-definition-and-fundamentals.md>) — agent role definition
