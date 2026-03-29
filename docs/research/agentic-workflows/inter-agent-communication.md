# Inter-Agent Communication

## Overview

Inter-agent communication patterns determine how information flows between agents in a multi-agent system. The method chosen affects coordination clarity, debugging ease, state consistency, and error recovery.

**Most Common Pattern**: Orchestrator-mediated communication (all communication flows through the orchestrator agent). This preserves visibility and accountability.

---

## Communication Patterns

### Pattern 1: Orchestrator-Mediated Communication

**Flow**: Agent A → Orchestrator → Agent B

**Implementation**:
```
1. Agent A completes work and reports to orchestrator
2. Orchestrator analyzes results and determines next step
3. Orchestrator delegates to Agent B with A's output as context
4. Agent B completes work using A's results
5. Orchestrator coordinates further execution
```

**Strengths**:
- Clear, observable communication flow
- Orchestrator has full visibility into state
- Easy to debug: can see what each agent received
- Centralized error handling and recovery
- Clear accountability: orchestrator "owns" the workflow

**Weaknesses**:
- Orchestrator becomes communication bottleneck on very large systems
- Orchestrator must understand all domains to pass context correctly
- Slow for high-frequency communication

**Best For**: Most development workflows; recommended default

**Example**:
```
User: "Create API documentation for new payment feature"

1. @ben (orchestrator) analyzes request
   - Determines: @research needed (understand feature)
   - Then: @doc needed (write documentation)

2. @ben delegates to @research:
   "Study the payment feature implementation, provide findings"

3. @research reports findings to @ben

4. @ben delegates to @doc:
   "Write API documentation using these findings as input..."

5. @doc creates documentation
```

---

### Pattern 2: Shared Memory Communication

**Flow**: Agent A writes to shared location → Agent B reads from shared location

**Implementation**:
```
1. Agent A completes work
2. Agent A writes output to shared location (.tmp/, workspace files, etc.)
3. Orchestrator notifies Agent B that data is available
4. Agent B reads shared location and proceeds
5. Optional: agents verify data freshness before using
```

**Strengths**:
- Asynchronous; agents don't need to wait for each other
- Works well for independent parallel tasks
- Scales better than orchestrator-mediated
- Clear "contract" between agents (file format, location)

**Weaknesses**:
- Requires explicit coordination on file locations/formats
- Harder to debug: unclear if agent found expected data
- Risk of stale data (Agent B reads outdated Agent A output)
- No automatic error handling if data isn't found

**Best For**: Loosely-coupled parallel work

**Example**:
```
@ben orchestrates documentation updates:

1. @research writes findings to .tmp/research-findings.json
2. @ben reads and validates findings exist
3. @doc reads findings from .tmp/research-findings.json
4. @doc creates documentation

Advantage: @research and @doc could theoretically run in parallel
          with careful orchestration of when files are ready
```

---

### Pattern 3: Direct Agent-to-Agent Communication

**Flow**: Agent A directly invokes Agent B

**Implementation**:
```
1. Agent A completes work
2. Agent A directly invokes Agent B (like: `take these findings, write docs`)
3. Agent B executes and returns results to Agent A
4. Agent A continues with results
```

**Strengths**:
- No intermediary needed; direct communication
- Potentially fast for sequential dependent tasks
- Feels natural for hierarchical relationships

**Weaknesses**:
- Breaks orchestrator visibility (orchestrator doesn't know what A told B)
- Very hard to debug: hidden communication channels
- Violates clear separation of concerns
- Couples agents together; can't swap Agent B for alternative

**Best For**: Extremely rare; not recommended for most systems

**Example (Not Recommended)**:
```
@research directly invokes @doc:
"@doc, using these findings, write documentation"

Problem: @ben (orchestrator) doesn't know this communication happened
         If @doc fails, @research doesn't know how to handle it
         If @research needs to coordinate with another agent, communication becomes complex
```

---

### Pattern 4: Event-Based Communication

**Flow**: Agents subscribe to events; event bus routes messages

**Implementation**:
```
1. Agent A publishes event: "findings_complete { data... }"
2. Event bus routes to subscribed agents
3. @doc (subscribed to "findings_complete") receives event
4. @doc processes findings
5. @doc publishes event: "documentation_complete { data... }"
```

**Strengths**:
- Highly decoupled; agents don't know about each other
- Scales to many agents and events
- Reactive; agents respond to events as needed

**Weaknesses**:
- Difficult to debug: hidden event flows
- Non-deterministic ordering: hard to guarantee order
- Overcomplication for simple workflows
- Harder to implement reliable error recovery

**Best For**: Large-scale systems with many agents; reactive workflows

**Rarely needed in development workflows**

---

## Context Passing Strategies

### Strategy 1: Explicit Context in Delegation

**Approach**: Orchestrator passes full context to next agent

```
Orchestrator to @doc:
"Write API documentation for the new payment feature.

Background context:
- Feature adds Stripe integration for recurring payments
- Removes legacy PayPal integration
- Payment endpoint signature changed to accept PaymentConfig object
- See codebase for implementation details

Success criteria:
- Document new endpoint with request/response schemas
- Include migration guide from old to new endpoint
- Add 2-3 usage examples
- Verify examples compile without errors"
```

**Advantages**:
- Complete context; no assumptions
- Agent doesn't need to search for context
- Clear success criteria

**Disadvantages**:
- Can be verbose
- Assumes orchestrator knows what context matters

### Strategy 2: Shared Workspace Memory

**Approach**: Agents read context from shared locations

```
Orchestrator passes path references instead of full content:

"Write documentation using:
- Feature specification: docs/spec/payment-feature.md
- Implementation: src/payment/index.ts
- Findings: .tmp/research-findings.json

Success criteria:
- [same as above]"

Agent reads files as needed when writing docs
```

**Advantages**:
- Less verbose delegation message
- Agents can access full context when needed
- Single source of truth for context

**Disadvantages**:
- Requires explicit file locations
- Agent needs to search/read files
- More round-trips if agent needs multiple context items

### Strategy 3: File-Based Dropbox Pattern

**Approach**: Agents write results to agreed-upon locations

```
1. @research writes to: .tmp/findings/payment-feature.json
2. @doc reads from: .tmp/findings/payment-feature.json
3. @doc writes documentation to: docs/api/
4. @ben reads results from: docs/api/

Agreement: Data format in .tmp/findings/ is known and consistent
```

**Advantages**:
- Asynchronous; agents don't wait for each other
- Clear "contract" between agents

**Disadvantages**:
- Requires upfront agreement on data format/location
- Validation work (checking if data exists, is valid)

---

## State Management

### Checkpoints in Orchestrator

Best practice: Orchestrator maintains awareness of state checkpoints

```
Orchestrator state tracking:

request_received: "Create documentation for payment feature"
step_1_research:
  agent: @research
  status: completed
  output: .tmp/findings/payment-feature.json
step_2_documentation:
  agent: @doc
  status: in_progress
  input: .tmp/findings/payment-feature.json
  output_expected: docs/api/payment-api.md
```

**Benefits**:
- Clear visibility into workflow progress
- Can retry failed steps from last checkpoint
- Easy to report status to user

### Avoiding Shared State in Agents

**Anti-Pattern**: Agents maintain shared mutable state

```
✗ WRONG:
Agent A writes to: .tmp/shared-state.json
Agent B reads and modifies: .tmp/shared-state.json
Agent A re-reads expecting original content
→ Confusion; race conditions; unpredictable behavior
```

**Correct Pattern**: Agents write new outputs, don't modify shared inputs

```
✓ Correct:
@research writes to: .tmp/research/findings.json (immutable)
@doc reads from: .tmp/research/findings.json
@doc writes to: docs/api/doc.md (new output, doesn't modify findings)
```

---

## Error Handling in Communication

### Handling Missing Data

**Scenario**: Agent B expects data from Agent A, but can't find it

**Recovery**:
```
1. @doc looks for .tmp/findings/payment-feature.json
2. File doesn't exist
3. @doc escalates to @ben: "Expected research findings not found"
4. @ben can:
   - Re-run @research
   - Provide findings manually
   - Ask user for clarification
5. @ben re-delegates to @doc once data is available
```

### Handling State Inconsistency

**Scenario**: Agent B reads Agent A's output, output is partially complete

**Recovery**:
```
1. @doc reads .tmp/findings/payment-feature.json
2. File exists but is missing critical sections
3. @doc reports to @ben: "Research findings incomplete: missing implementation details"
4. @ben can:
   - Re-run @research with specific instructions
   - Ask @research to complete findings
   - Ask user for input
5. Proceed once data is complete
```

---

## Recommendation Matrix

| Scenario | Recommended Pattern | Why |
|----------|-------------------|-----|
| Sequential dependent tasks | Orchestrator-mediated | Clear handoff points; easy to debug |
| Parallel independent tasks | Shared memory | Async; agents work concurrently |
| Unknown task scope (exploratory) | Orchestrator-mediated | Orchestrator learns and adapts routing |
| Very large agent teams (20+) | Hierarchical + event-based | Scales better than central orchestrator |
| Simple linear workflow 3-5 agents | Orchestrator-mediated | Simplest; best visibility |
| Complex with many possible paths | Orchestrator-mediated | Easier than event routing |

---

## References

- **Related**: [Multi-Agent Orchestration Principles](<./multi-agent-orchestration-principles.md>) — orchestration patterns that use these communication strategies
- **Related**: [Effective Delegation Strategies](<./effective-delegation-strategies.md>) — how orchestrator delegates with proper context
- **Related**: [Debugging Multi-Agent Systems](<./debugging-multi-agent-systems.md>) — using communication patterns to debug failures
