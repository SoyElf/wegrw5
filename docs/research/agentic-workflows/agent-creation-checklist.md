# Agent Creation Checklist

## Overview

This checklist guides the creation of new VS Code agents from conception to deployment. Use this for creating new specialist agents or improving existing ones.

---

## Phase 1: Planning

### Define Agent Role

- [ ] **Domain is narrow and well-defined**
  - What specific area does this agent specialize in?
  - Example GOOD: Documentation specialist
  - Example BAD: Does coding and DevOps

- [ ] **Problem statement is clear**
  - What problem does this agent solve?
  - Why does team need this specialist?
  - What tasks fail without this agent?

- [ ] **Success criteria defined**
  - How do we measure if agent is working well?
  - What quality standards apply?
  - What would constitute agent failure?

### Define Responsibilities

- [ ] **Primary responsibilities listed**
  - Create bullet list of 3-5 core responsibilities
  - Example: "Write clear API documentation with working examples"

- [ ] **Constraints clearly stated**
  - What is this agent explicitly NOT supposed to do?
  - Example: "Cannot modify application code beyond comments"
  - Prevents scope creep and role confusion

- [ ] **Escalation paths defined**
  - When/how does agent escalate to orchestrator?
  - What blockers warrant escalation?
  - Example: "Escalate if unclear whether behavior is bug or feature"

### Define Tool Set

- [ ] **Tools necessary for primary responsibilities**
  - What tools specifically does agent need?
  - What tools is agent explicitly NOT getting (and why)?

- [ ] **Tool restrictions documented**
  - Are there safe-mode variants (e.g., read-only file search)?
  - Do restrictions align with agent role?

- [ ] **Tool composition examples included**
  - How should agent combine tools?
  - What order should tools be used?

---

## Phase 2: Implementation

### Create Agent Definition File

- [ ] **YAML frontmatter complete**
  ```yaml
  name: [Agent Name]
  description: [Clear, concise purpose and core capabilities]
  tools:
    - name: [tool name]
      description: [what this tool does for this agent]
    - ...
  instructions: |
    [Comprehensive instructions follow]
  ```

- [ ] **Required fields present**
  - name: Descriptive, unique name
  - description: Clear purpose and capabilities
  - tools: Array of tool configurations
  - instructions: Detailed Markdown instructions

- [ ] **Optional fields considered**
  - version: Semantic version (1.0)
  - tags: Array of keywords for discovery
  - scope: "user" or "workspace"

### Write Clear Instructions

- [ ] **Agent role explicitly stated**
  - "You are a documentation specialist..."
  - Clear articulation of primary focus

- [ ] **Responsibilities section**
  - List what agent is responsible for
  - Make explicit what success looks like

- [ ] **Constraints section**
  - List what agent cannot/should not do
  - Explain reasoning briefly

- [ ] **Tool usage guidance**
  - Include examples of tool composition
  - Specify tool order for multi-step tasks
  - Example: "Always read_file before replace_string_in_file"

- [ ] **Quality standards documented**
  - What makes a good documentation? (specify!)
  - What makes good code review feedback?
  - Provide examples of desired behavior

- [ ] **Escalation guidance**
  - When should agent ask for help?
  - How should agent escalate?
  - Example: "If implementation design unclear, ask orchestrator"

- [ ] **Example workflows provided**
  - Include 2-3 examples of correct agent behavior
  - Show expected input → processing → output
  - Demonstrates quality expectations

### Handle Special Cases

- [ ] **Context-specific guidance**
  - If workspace-specific agent, reference workspace conventions
  - If tool-specific, include tool-specific best practices

- [ ] **Security considerations**
  - No credentials in instructions
  - Proper tool restrictions for safety
  - Call out risky operations

- [ ] **Performance expectations**
  - Acceptable time for task completion
  - When to break long tasks into subtasks

---

## Phase 3: Testing

### Unit Testing

- [ ] **Single-agent invocation works**
  - Agent can be invoked directly
  - Agent understands target task
  - Agent completes task successfully

- [ ] **Tool availability verified**
  - Each tool in agent definition is accessible
  - Tool restrictions are enforced
  - Agent can actually use tools it claims to have

- [ ] **Instructions are clear**
  - Another person can read instructions and understand them
  - Instructions contain sufficient examples
  - No ambiguous or contradictory guidance

### Integration Testing

- [ ] **Agent works with orchestrator**
  - Orchestrator can delegate to agent
  - Agent receives delegations correctly
  - Agent reports back results clearly

- [ ] **Multi-agent workflow works**
  - Agent works well with other specialists
  - Hand-offs between agents are smooth
  - Context passing works (if sequential)

### Quality Testing

- [ ] **Output quality meets standards**
  - Run agent on sample tasks
  - Verify output meets documented success criteria
  - Check style consistency (if applicable)

- [ ] **Error handling works**
  - When blockers encountered, agent escalates appropriately
  - Agent doesn't silently fail
  - Error messages are clear

- [ ] **Tool composition is correct**
  - Agent uses tools in right order
  - Agent verifies outputs (when applicable)
  - Tool chain handles partial failures gracefully

---

## Phase 4: Documentation

### Agent-Level Documentation

- [ ] **Agent definition file is well-commented**
  - Explain non-obvious restrictions
  - Clarify why agent was scoped this way
  - Document any nuances

- [ ] **README or guide for using agent created** (if workspace agent)
  - How to invoke agent (@name syntax)
  - What types of tasks it's good for
  - What tasks to route to other agents

- [ ] **Examples documented**
  - Sample tasks agent handles well
  - What to expect as output
  - How to verify agent succeeded

### Team Documentation

- [ ] **Agent purpose documented**
  - Where does this agent fit in team workflow?
  - When should people use this agent?
  - When should work go to human specialists instead?

- [ ] **Limitations documented**
  - What can't this agent do?
  - When will it fail or produce poor output?
  - What's not yet implemented?

---

## Phase 5: Deployment

### Pre-Deployment Checklist

- [ ] **Agent file in correct location**
  - Workspace agents: `.github/agents/[name].agent.md`
  - User agents: `~/.copilot/agents/[name].agent.md`

- [ ] **File format is valid**
  - YAML frontmatter valid (can parse as YAML)
  - No syntax errors in frontmatter
  - Markdown instructions properly formatted

- [ ] **Agent is discoverable**
  - Can invoke with @name in VS Code
  - Shows up in agent selection
  - Correct name and description

- [ ] **All tests passing**
  - Unit tests successful
  - Integration tests successful
  - Quality benchmarks met

### Monitoring Post-Deployment

- [ ] **Usage tracking identified**
  - How will you know if agent is being used?
  - How will success be measured?
  - What metrics matter? (quality, speed, reliability)

- [ ] **Feedback mechanism in place**
  - How will team report issues?
  - How will improvement requests be tracked?

- [ ] **Iteration plan defined**
  - How often will agent be reviewed?
  - What improvements are planned?
  - Who owns agent maintenance?

---

## Phase 6: Iteration

### Regular Review (Monthly or As-Needed)

- [ ] **Gather feedback**
  - How is agent performing?
  - What's working well?
  - What's not working?

- [ ] **Analyze failure patterns**
  - Are there common failure modes?
  - Are they specification issues or capability issues?

- [ ] **Plan improvements**
  - Which instructions should be clarified?
  - Which tools need adding/removing?
  - Should agent be split into multiple specialists?

- [ ] **Update agent definition**
  - Make needed improvements
  - Document changes in version bump
  - Re-test after changes

---

## Pre-Flight Checklist (Before Deployment)

Copy this checklist and verify all items before deploying:

```
PLANNING
- [ ] Domain is narrow and well-defined
- [ ] Problem statement is clear
- [ ] Success criteria defined
- [ ] Responsibilities listed
- [ ] Constraints stated
- [ ] Escalation paths defined
- [ ] Tool set determined
- [ ] Tool restrictions align with role

IMPLEMENTATION
- [ ] YAML frontmatter complete
- [ ] Required fields present
- [ ] Role explicitly stated in instructions
- [ ] Responsibilities section clear
- [ ] Constraints section explicit
- [ ] Tool usage examples included
- [ ] Quality standards documented
- [ ] Escalation guidance included
- [ ] Example workflows provided
- [ ] Credentials not in instructions
- [ ] Tool restrictions for safety applied

TESTING
- [ ] Single-agent invocation works
- [ ] All tools accessible
- [ ] Instructions are clear
- [ ] Orchestrator delegation works
- [ ] Multi-agent workflow works
- [ ] Output meets quality standards
- [ ] Error handling works correctly
- [ ] Tool composition is correct

DOCUMENTATION
- [ ] Agent definition well-commented
- [ ] Usage guide created
- [ ] Examples documented
- [ ] Team documentation complete
- [ ] Limitations documented

DEPLOYMENT
- [ ] Agent file in correct location
- [ ] File format valid (YAML/Markdown)
- [ ] Agent is discoverable
- [ ] All tests passing
- [ ] Usage tracking identified
- [ ] Feedback mechanism in place
- [ ] Iteration plan defined
```

---

## Common Mistakes to Avoid

- ❌ Making agent too broad (too many responsibilities)
- ❌ No clear success criteria (agent doesn't know when task is done)
- ❌ Tools without examples (agent doesn't know how to use tools)
- ❌ No constraints (agent overreaches into other domains)
- ❌ No escalation guidance (agent gets stuck silently)
- ❌ Credentials in instructions (security risk)
- ❌ Insufficient testing (broken agent deployed)
- ❌ No documentation (team doesn't know when to use agent)

---

## References

- **Related**: [Agent Definition and Fundamentals](<./agent-definition-and-fundamentals.md>) — agent structure and specification
- **Related**: [Agent Specialization Patterns](<./agent-specialization-patterns.md>) — how to define agent roles
- **Related**: [Instruction Engineering Best Practices](<./instruction-engineering-best-practices.md>) — how to write agent instructions
- **Related**: [Tool Composition and Design](<./tool-composition-patterns.md>) — how agents should use tools
