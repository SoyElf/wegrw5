# Agentic Orchestration Hub

A VS Code workspace designed to coordinate work through specialized custom agents, creating a structured system for task delegation and execution.

## Purpose

This workspace is an **agentic orchestration hub** — a centralized system where work is coordinated through specialized agents rather than handled directly. Each agent is a VS Code custom agent with specific expertise designed to handle particular types of tasks. By routing requests through specialized agents, the workspace ensures that work is handled by the right expert with the right tooling at the right time.

## How It Works

The workspace uses a delegation model:

1. **User submits a request** — Pass your task to the workspace without specifying an agent
2. **Ben (Orchestrator) analyzes** — Ben receives the request and determines what type of work is needed
3. **Ben delegates** — The orchestrator forwards the work to the appropriate specialist agent(s)
4. **Specialist agents execute** — Each agent completes their portion of the work using their designated tools and expertise
5. **Results are coordinated** — When multiple agents are involved, Ben coordinates their outputs and delivers final results

This structure separates concerns, allows agents to specialize, and makes the system scalable — new agents can be added without changing the core workflow.

## Available Agents

| Agent | Role | When to Use |
|-------|------|------------|
| **Ben** (`@ben`) | Orchestrator | Always the first contact — analyzes your request and delegates to specialists |
| **Doc** (`@doc`) | Documentation Specialist | Creating, updating, or improving documentation (READMEs, API docs, guides, etc.) |
| **ar-director** (`@ar-director`) | HR Director | Identifying capability gaps and recruiting new specialist agents |

## Getting Started

**For any task:** Simply describe what you need to accomplish. The workspace will automatically route your request to Ben, who will analyze it and delegate to the appropriate specialist.

Example requests:
- "Write a README for the authentication module"
- "Document the database schema and API endpoints"
- "Create a new agent for database migrations"

You don't need to specify an agent — Ben handles the routing.

## Adding New Agents

As the workspace grows and new capability gaps are identified, follow this process:

1. **Gap Identification** — Ben recognizes that a requested task doesn't fit existing agent capabilities
2. **Recruitment** — Ben invokes ar-director (HR Director) to recruit a new specialist agent
3. **Agent Creation** — Create a new `.agent.md` file in `.github/agents/` with:
   - YAML frontmatter specifying agent metadata (`name`, `description`, `tools`, `agents`, `model`)
   - Markdown instructions defining the agent's responsibilities and workflow
4. **Registration** — Update `.github/copilot-instructions.md` to register the new agent in the Agent Directory table

For detailed specifications, see the [VS Code custom agents documentation](https://code.visualstudio.com/docs/copilot/customization/custom-agents).

## Workspace Structure

Key directories and files:

- `.github/copilot-instructions.md` — Central routing logic; defines all available agents and integration rules
- `.github/agents/` — Directory containing all agent definitions
  - `ben.agent.md` — Orchestrator agent (task analysis and delegation)
  - `doc.agent.md` — Documentation specialist agent
  - `ar-director.agent.md` — Recruiter agent
- `README.md` — This file

## Design Principles

- **Separation of concerns** — Each agent handles a specific domain
- **Scalability** — New agents can be added without restructuring existing workflows
- **Clear delegation** — Users interact with one interface (Ben); work is automatically routed to specialists
- **Tool-scoped expertise** — Each agent has access only to the tools needed for their domain
