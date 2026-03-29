# VS Code Agent Architecture

## Overview

VS Code agent architecture describes how agents integrate with the editor, interact with its UI, and participate in the VS Code extension ecosystem.

**Architecture Level**: Agents exist within VS Code's GitHub Copilot Chat integration; agents are specialized versions of Copilot configured via `.agent.md` files.

---

## Agent Integration Points

### Chat Interface Integration

**Where Agents Appear**:
- Copilot Chat sidebar in VS Code
- Agent selection dropdown
- Chat input history
- Inline suggestions

**Agent Invocation Methods**:

1. **Explicit Selection**
   - User types `@agent-name` to invoke specific agent
   - Example: `@doc write documentation for this function`
   - User explicitly picks agent from UI

2. **Orchestrator Delegation**
   - Orchestrator agent (e.g., @ben) invokes specialist agents
   - Internal to multi-agent system
   - Not visible as separate chat invocations

3. **Context-Based Suggestion** (When configured)
   - VS Code suggests relevant agent based on file type/context
   - Example: Editing `.md` file suggests `@doc` agent
   - Requires agent configuration: `infer: true`

---

## Agent Metadata Discovery

### Agent Registration

VS Code discovers agents from `.agent.md` files in:

1. **Workspace Level** (Highest Priority)
   ```
   .github/agents/*.agent.md
   ```
   - Applies to entire workspace
   - Recommended for team collaboration
   - Version controlled in repository

2. **User Level** (Lower Priority)
   ```
   ~/.copilot/agents/*.agent.md
   ```
   - Personal agents available everywhere
   - User-specific customization

3. **Configuration via Settings**
   - Agent definitions via VS Code settings
   - `copilot.agents` setting

### Agent Discovery Metadata

**What VS Code Reads**:
```yaml
name: Agent Name
description: Clear description of what agent does
tags:
  - keyword1
  - keyword2

infer: true  # VS Code auto-suggests when appropriate
```

**Usage of Metadata**:
- `name`: How agent appears in UI
- `description`: Shown in agent selection tooltip
- `tags`: Used for agent search and categorization
- `infer`: Whether to auto-suggest based on context

---

## Context and Environment

### Context Provided to Agents

When an agent is invoked, VS Code provides context:

**File Context**:
- Currently open file path
- Currently visible file range
- Selected text (if any)
- File language/type

**Workspace Context**:
- Workspace root directory
- Open folders/projects
- Git repository information
- Project structure

**Editor State**:
- Cursor position (line, column)
- Visible range in editor
- Terminal output (when relevant)

**Environment Variables**:
- VS Code workspace settings
- Envionment variables set in VS Code
- DEBUG, NODE_ENV, etc.

### Accessing Context in Agent Instructions

```yaml
instructions: |
  You have access to the workspace and file context.

  Use this context:
  - Current file under cursor: Consider file type and content
  - Selected text: Focus on what user selected if available
  - Workspace root: Understand project structure
  - Open files: Consider what's visible to user

  Always reference workspace files using relative paths from root.
```

---

## Tool Availability in VS Code

### Built-in VS Code Agent Tools

**File Operations**:
- file_search: Find files by glob pattern
- create_file: Create new files
- read_file: Read file contents
- replace_string_in_file: Edit existing files
- delete_file: Remove files

**Search and Analysis**:
- semantic_search: Find related code/concepts
- grep_search: Text/regex search
- get_errors: Compile/lint errors

**Git Integration**:
- get_changed_files: See git diffs

**Language Support**:
- get_errors: Language-specific error information
- Language-specific analysis (depends on VS Code language support)

### MCP Server Tools

**In Addition to Built-in Tools**, agents can access MCP server tools:
- GitHub API operations
- Web search
- Custom domain tools
- Database queries

---

## Agent Routing and Orchestration

### How Orchestrator Agents Work

```
User invokes @ben:
  "Help me with documentation"

@ben receives context:
  - Current file
  - Workspace structure
  - User's intent

@ben analyzes and routes:
  - Calls @doc: "Write documentation for this feature"
  - Monitors execution
  - Gathers output

@ben presents results to user:
  - "Documentation created at docs/..."
```

**Key Architectural Point**: Orchestration happens within VS Code's Copilot Chat; users don't see internal delegation, just final result.

---

## Lifecycle and State

### Agent Session Lifecycle

```
User invokes agent
    ↓
VS Code initializes context
    ↓
Agent receives input + context
    ↓
Agent executes using tools
    ↓
Agent completes / reports status
    ↓
Output shown to user
    ↓
Session can continue (multi-turn)
```

### Multi-Turn Conversations

**VS Code Agents Support**:
- Multiple exchanges in single chat
- Agent remembers conversation history within session
- User can ask follow-up questions
- Agent can clarify or refine

**Context Considerations**:
- Earlier conversation context is included
- Very long conversations may exceed context window
- Agent may need to summarize or checkpoint

### Agent Termination

**Agents Automatically Terminate When**:
- Task is complete (agent reports done)
- Timeout reached (agent took too long)
- User stops the conversation
- Error encountered (unrecoverable)

**Graceful Termination**:
- Agent should report final status
- Summarize what was completed
- Identify any blockers
- Clean up any temporary state

---

## Message Protocol

### Agent Input

**Format**: Natural language in Copilot Chat

```
Example user input:
"@doc Write API documentation for the payment module"
```

**Agent Receives**:
- User's message
- Workspace context
- File context (if relevant)
- Conversation history

### Agent Output

Agents report progress via messages:

```
Agent reports:
"I found the payment module at src/payment/index.ts.
I'm writing documentation based on the implementation...

Documentation created at docs/api/payment.md
Examples compiled and verified.
Documentation is complete."
```

**Good Output Includes**:
- What agent understood (confirms understanding)
- What agent did (transparent process)
- What agent created/modified (deliverables)
- How to verify success (enable user validation)

---

## Error Handling in VS Code Context

### When Agents Fail in VS Code

**User-Visible Errors**:
- Agent reports error clearly
- Explains what went wrong
- Suggests remediation

**Example**:
```
Agent reports:
"I couldn't find implementation for auth module.
Searched: src/auth/, src/authentication/, src/login/
None of these exist.

Possibilities:
1. Auth functionality is in different location
2. Auth not yet implemented
3. Different naming convention

Next step: Please clarify where auth logic is, or I can
help implement authentication from scratch."
```

### Escalation Within VS Code

**Agent Escalation Pattern**:
```
Agent: "I found a potential bug but need input:

The authentication flow looks correct but I'm uncertain
about edge case: what if token refresh fails?

This needs to be clarified with the author. Should I:
A) Document the current behavior as-is
B) Flag this as a known limitation
C) Other?

Please advise before I finalize documentation."
```

User can provide feedback, and agent continues.

---

## VS Code Settings for Agents

### Relevant VS Code Settings

**Copilot Agent Settings**:
```json
{
  "copilot.agents": {
    "enabled": true,
    "customAgents": true
  },
  "copilot.agentDirectories": [
    ".github/agents"
  ]
}
```

**Chat Settings**:
```json
{
  "github.copilot.chat.experimental.new": true,
  "github.copilot.chat.monitoringEnabled": true
}
```

**Extension Development** (for agent creators):
```json
{
  "github.copilot.debug": true,
  "[agent-development]": {
    "editor.formatOnSave": true
  }
}
```

---

## Performance Considerations

### Agent Execution in VS Code

**Performance Expectations**:
- Simple tasks (< 10 seconds): Real-time feedback
- Moderate tasks (10-60 seconds): Keep user engaged with progress
- Long tasks (> 60 seconds): Checkpoint and re-delegate

**Optimization**:
- Use caching where appropriate
- Pre-generate common outputs
- Defer heavy operations when not critical
- Stream results for long-running tasks

### Context Window Management

**VS Code Agents Have**:
- VS Code-provided context (files, state)
- Conversation history (current session)
- Agent instructions
- User input

**Token Budget**:
- vs code context: ~1,000-2,000 tokens
- Conversation history: Variable
- Remaining: Available for task work

**Best Practice**:
- Check token usage for large file operations
- Summarize long conversations when needed
- Break large tasks into subtasks if reaching limits

---

## Extensibility Patterns

### Custom Agent Creation

**Standard Pattern**:
1. Create `.agent.md` file in `.github/agents/`
2. Define role, responsibilities, constraints
3. List available tools
4. Write comprehensive instructions
5. Test in VS Code Chat
6. Iterate based on experience

### Advanced: Workspace Configuration

**Customize Agent Behavior via Workspace Settings**:
```json
{
  "copilot.agents.custom": {
    "myCustomAgent": {
      "enabled": true,
      "priority": "high"
    }
  }
}
```

---

## Comparison to VS Code Extensions

### Agents vs. Extensions

| Aspect | Agents | Extensions |
|--------|--------|-----------|
| Complexity | Simpler (configuration) | More complex (code) |
| Language | Markdown + YAML | TypeScript/JavaScript |
| Scope | Copilot Chat only | Full VS Code API |
| Development | Minutes to hours | Hours to days |
| Distribution | In repository | VS Code Marketplace |
| Use Case | Workflow specialization | UI/feature customization |

**When to Use Agents**: Specialized behavior for Copilot Chat

**When to Use Extensions**: Custom VS Code features, UI changes

---

## Security and Permissions

### Agent Tool Restrictions

VS Code enforces tool access:
- Agents can only use allowed tools
- Tool restrictions are enforced
- User must approve dangerous operations

**No Dangerous Defaults**:
- Agents can't execute arbitrary code
- Agents can't access user credentials (beyond provided env vars)
- Agents can't modify system outside workspace

### User Control

- Users can revoke agent permissions
- Users can see what agents are installed
- Users can disable specific agents

---

## References

- **Related**: [Agent Definition and Fundamentals](agent-definition-and-fundamentals.md) — core agent structure
- **Related**: [VS Code Custom Agents Overview](vscode-custom-agents-overview.md) — how to use agents in VS Code
- **Related**: [VS Code Agent File Specification](vscode-agent-file-specification.md) — `.agent.md` format
