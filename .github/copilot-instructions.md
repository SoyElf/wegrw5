# Workspace Instructions

This workspace is an **agentic orchestration hub**. All work is coordinated through specialised agents defined in `.github/agents/`.

## Routing Rule

When a user invokes Copilot without specifying an agent, guide them to **@ben** — the orchestrator — who will delegate the task to the appropriate specialist agent.

## Agent Directory

| Agent | File | Role |
|-------|------|------|
| `@ben` | `ben.agent.md` | **Orchestrator** — analyses tasks and delegates to specialist sub-agents, never performs work directly |
| `@doc` | `doc.agent.md` | **Documentation Specialist** — writes clear, concise, well-structured documentation with minimal emoji usage |
| `@explore-codebase` | `explore-codebase.agent.md` | **Codebase Exploration Specialist** — discovers code patterns, symbols, architecture relationships, and implementation examples (sub-agent only) |
| `@agentic-workflow-researcher` | `agentic-workflow-researcher.agent.md` | **Research Specialist** — investigates agentic workflows, VS Code extensibility, GitHub Copilot CLI, and multi-agent orchestration (sub-agent only) |
| `@ar-director` | `ar-director.agent.md` | **HR Director** — recruits new specialist agents when a capability gap is identified (sub-agent only) |
| `@ar-upskiller` | `ar-upskiller.agent.md` | **Agent Upskilling Specialist** — researches latest VS Code Copilot best practices and updates existing agent definitions with improved capabilities (sub-agent only) |
| `@git-ops` | `git-ops.agent.md` | **Git Operations Specialist** — manages local and remote git operations with Conventional Commits enforcement and workflow automation (sub-agent only) |

> Additional specialist agents will be added to `.github/agents/` over time. Update this table when a new agent is created.

## Adding New Agents

Create a `.agent.md` file in `.github/agents/` with YAML frontmatter (`name`, `description`, `tools`, etc.) and Markdown instructions in the body. See [VS Code custom agents docs](https://code.visualstudio.com/docs/copilot/customization/custom-agents) for the full spec.
