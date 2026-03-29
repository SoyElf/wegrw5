# GitHub Copilot CLI Capabilities

## What is GitHub Copilot CLI?

GitHub Copilot CLI extends Copilot capabilities to the terminal environment, enabling agentic workflows for development tasks. Unlike VS Code's visual experience, the CLI is designed for scripted automation, CI/CD integration, and programmatic task execution. The CLI brings the same LLM capabilities and agent architecture to command-line workflows.

The GitHub Copilot CLI represents a shift toward terminal-first development, where agents can be invoked programmatically, scripted in shell workflows, and integrated into automated pipelines.

## Core Capabilities

**Interactive Sessions**: Copilot CLI sessions maintain context across multiple commands, enabling multi-step workflows without re-context.

**Tool Use with Approval Controls**: Agents can invoke tools (file operations, terminal commands) with explicit user approval. Approval can be interactive, pre-approved via flags, or fully automatic.

**Programmatic Invocation**: Scripts and automation tools can invoke Copilot CLI agents programmatically, enabling CI/CD integration and workflow automation.

**Workspace Awareness**: CLI agents understand workspace structure, recent changes, and project conventions—same as VS Code agents.

**Slash Command System**: Terminal commands prefixed with `/` steer agent behavior (e.g., `/agent research`, `/allow-all-tools`).

## Comparison: CLI vs VS Code Agents

| Aspect | VS Code | CLI |
|--------|---------|-----|
| **Context** | Visual file explorer, editor state | Terminal environment, workspace root |
| **Invocation** | Click, `@mention` in chat | Command-line invocation, programmatic |
| **Approval Model** | Implicit (most tools auto-approved) | Explicit (tools require approval) |
| **Workflow** | Interactive exploration | Scripted automation |
| **Best For** | Code writing, immediate feedback | CI/CD, batch processing, automation |

## Extensibility Mechanisms

GitHub Copilot CLI is extensible through multiple mechanisms:

**Skills**: Markdown files containing instructions that Copilot uses in relevant contexts. Skills are discovered and automatically applied when appropriate.

**Custom Agents**: Specialized agent definitions similar to VS Code agents, configured in `.agent.md` files with CLI-specific tool sets.

**MCP Servers**: Model Context Protocol servers provide tool access to external services (GitHub API, databases, monitoring systems).

**Hooks**: Operations executed at specific moments (session start, tool execution, session end) for setup, cleanup, and logging.

**Instructions**: Large, task-specific instructions that guide Copilot behavior for particular workflows.

## Tool Approval Controls

The CLI implements explicit tool approval patterns:

**Interactive Approval**: Copilot asks permission before executing each tool. User approves or rejects real-time.

**Approval Flags**: Pre-approve tools via CLI flags:
- `--allow-all-tools`: approve all tools for session
- `--allow-tool <name>`: approve specific tool
- `--yolo`: fully automatic (no prompts)

**Runtime Approval**: Use slash commands to change approval mode mid-session:
- `/allow <tool>`: approve specific tool
- `/allow-all`: approve all tools
- `/yolo`: enable automatic mode

This design balances security (preventing unintended operations) with usability (avoiding approval fatigue).

## Session Management

CLI sessions are designed for multi-step workflows:

**Session Persistence**: Single session maintains context across multiple commands.

**Context Refresh**: Agents can refresh context mid-session to pick up workspace changes.

**State Variables**: Sessions can maintain variables and state across commands (current directory, recent results, configuration).

**Infinite Sessions**: Long-running sessions enable complex workflows without context resets.

## Integration Points

**Shell Scripting**: CLI agents invoked from shell scripts for workflow automation.

**CI/CD Pipelines**: GitHub Actions or other CI systems invoke Copilot CLI agents as pipeline steps.

**IDE Integration**: Some IDEs can invoke Copilot CLI as background tasks.

**Git Workflows**: Pre-commit hooks, post-merge hooks can use CLI agents for validation and cleanup.

## Workflow Patterns

**Terminal-First Development**: Developer uses CLI agent for tasks (refactoring, testing, documentation) while keeping VS Code open for editing.

**Automated Quality Gates**: CI pipeline uses CLI agents to auto-review, validate, and improve code before merge.

**Batch Processing**: CLI agents process directories or repositories for refactoring, migration, or standardization.

## Key Differences from Conversational Chat

Copilot CLI is not just "Copilot Chat in the terminal." Key differences:

- **Tool Use First**: Agents use tools proactively to accomplish work, not just provide advice
- **Approval Explicit**: Tools require explicit approval, not implicit assumptions
- **Scripted Intent**: Designed for automation, not exploration
- **Batch Capable**: Can process large codebases, multiple files, entire repositories

## Related Concepts

- [Copilot CLI Extensibility Mechanisms](copilot-cli-extensibility-mechanisms.md) — Skills, custom agents, MCP servers
- [Copilot CLI Slash Command System](copilot-cli-slash-command-system.md) — Steering agent behavior in terminal
- [Copilot CLI Tool Approval Controls](copilot-cli-tool-approval-controls.md) — Security and usability
- [GitHub Copilot CLI Skills System](copilot-cli-skills-system.md) — Creating reusable knowledge modules
