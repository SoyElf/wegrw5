# Agentic Orchestration Hub

An intelligent workspace powered by GitHub Copilot custom agents. This hub coordinates specialized AI agents to handle documentation, research, development, and DevOps tasks through intelligent delegation and orchestration.

## Workspace Structure

This workspace is organized for clarity, automation, and agent navigation:

- **docs/** — Complete documentation (guides, research, testing reports, checklists)
- **scripts/** — Executable scripts and utilities (setup and CLI)
- **.github/agents/** — 11 specialist agent definitions plus custom skills
- **.github/context/** — Active working context and research files
- **.agents/skills/** — External skills from `npx skills` (e.g., Hindsight)
- **.tmp/** — Temporary shared files directory (not committed)

See [.github/WORKSPACE_STRUCTURE.md](<.github/WORKSPACE_STRUCTURE.md>) for complete hierarchy and file purposes.

See [.github/agents/skills/README-SKILLS-ORGANIZATION.md](<.github/agents/skills/README-SKILLS-ORGANIZATION.md>) for details on skill organization.

## Technology Stack

This workspace operates exclusively within the **GitHub Copilot ecosystem**. All agent infrastructure, tools, and models are scoped to Copilot capabilities:

| Component | Technology | Details |
|-----------|-----------|----------|
| **IDE** | VS Code | Exclusive development environment (not Cursor or other tools) |
| **Agent Runtime** | GitHub Copilot CLI | `copilot` binary for custom agent execution |
| **LLM Models** | GitHub Copilot | Multi-model support (Claude Haiku 4.5, Claude Sonnet 4.6) |
| **Memory System** | Hindsight MCP | Semantic tagging, observation scopes, mental models; Gemini 2.5 Flash LLM with planned upgrade to Gemini 3.1 Pro |
| **Agent Definition** | VS Code Custom Agents | `.agent.md` format with YAML frontmatter and Markdown instructions |

**Scoped Focus**: This workspace evaluates capabilities **within the Copilot ecosystem only**. We are not conducting multi-tool comparisons (Aider, Claude Code, OpenCode, etc.). The focus is on maximizing value within GitHub Copilot's capabilities and constraints.

## Project Overview

This workspace is an **agentic orchestration hub** — a system where work is routed through a primary orchestrator agent (`@ben`) who analyzes user requests and delegates to specialized sub-agents with specific skills. The architecture enables:

- **Intelligent task routing** — Requests are analyzed and delegated to the most appropriate specialist agent
- **Autonomous execution** — Specialist agents work independently with full context to complete their tasks
- **Parallel workflows** — Independent tasks execute simultaneously for faster completion
- **Scalable capability** — New specialist agents can be recruited on-demand when capability gaps are identified

## Strategic Overview

The workspace operates on a **4-phase hindsight deployment strategy** designed to build institutional memory and distributed intelligence:

### Core Strategy

- **Multi-agent orchestration** — Ben (orchestrator) + 9 specialist agents working autonomously
- **Institutional memory** — Hindsight-backed learning prevents duplication, enables smarter decisions, and synthesizes patterns across discoveries
- **Living documentation** — Architecture docs, guides, and research findings automatically updated as new patterns emerge
- **Skills composition** — Reusable domain knowledge packaged as agent skills for easier capability extension

### Current Focus

- CLI mode wrappers for bash scripting and task automation
- Skills composition patterns for packaging specialized knowledge
- Real-world testing and validation of agent orchestration

This strategic approach ensures the workspace scales beyond individual agent capabilities through shared context, pattern discovery, and autonomous decision-making.

## Deployment Phases

The hindsight integration follows a systematic 4-phase rollout:

### Phase 1: Memory Bank Initialization ✓ Complete

- Semantic tagging system for organizing discoveries
- Memory bank setup with disposition configuration
- Basic retain/recall operations for storing and retrieving facts

### Phase 2: Living Documentation ✓ Complete

- Living documentation synthesis from research findings
- Mental models capturing architectural patterns and best practices
- Documentation update workflow driven by hindsight discoveries

### Phase 3: Directives & Advanced Features ✓ Complete

- Observation scopes for filtering discovered patterns
- Directives for enforcing standards and guidelines
- 9 agents upskilled with hindsight integration
- 24 mental models representing workspace knowledge
- Reflection capabilities for synthesizing complex patterns

### Phase 4: Real-World Testing (In Progress)

- Validation of agent orchestration in production workflows
- Emergent intelligence patterns from multi-agent interaction
- Continuous refinement based on real-world usage

## Agent System Architecture

All agents are defined as `.agent.md` files in [.github/agents/](.github/agents/) and are powered by GitHub Copilot (Claude Haiku 4.5 or Claude Sonnet 4.6, depending on complexity).

### Routing Flow

1. User invokes Copilot and describes their request
2. Default routing directs to **@ben** (the orchestrator)
3. **@ben** analyzes the request and determines what type of work is needed
4. **@ben** delegates to the appropriate specialist agent with full context
5. Specialist agent executes autonomously and reports completion
6. **@ben** coordinates outputs and summarizes results to the user

### Agent Roles

Agents fall into two categories:

- **User-invocable agents** — Can be directly invoked via `@agent-name`
  - `@ben` — The orchestrator (primary entry point)

- **Sub-agents** — Invoked only by `@ben` when needed
  - `@doc` — Documentation specialist
  - `@agentic-workflow-researcher` — Research specialist
  - `@ar-director` — HR Director (recruits new agents)
  - `@ar-upskiller` — Upskilling specialist
  - `@git-ops` — Git operations specialist

## Agent Directory

| Agent | File | Role | Invocable |
|-------|------|------|-----------|
| **Ben** | [.github/agents/ben.agent.md](<.github/agents/ben.agent.md>) | **Orchestrator** — Analyzes tasks and delegates to specialist sub-agents. Never performs work directly. | ✓ User |
| **Doc** | [.github/agents/doc.agent.md](<.github/agents/doc.agent.md>) | **Documentation Specialist** — Writes, updates, and improves documentation (READMEs, guides, API docs, comments). | Sub-agent |
| **agentic-workflow-researcher** | [.github/agents/agentic-workflow-researcher.agent.md](<.github/agents/agentic-workflow-researcher.agent.md>) | **Research Specialist** — Investigates agentic workflows, VS Code extensibility, GitHub Copilot CLI, and multi-agent orchestration patterns. Provides expert analysis with sources. | Sub-agent |
| **ar-director** | [.github/agents/ar-director.agent.md](<.github/agents/ar-director.agent.md>) | **HR Director** — Recruits new specialist agents when a capability gap is identified. | Sub-agent only |
| **ar-upskiller** | [.github/agents/ar-upskiller.agent.md](<.github/agents/ar-upskiller.agent.md>) | **Upskilling Specialist** — Researches latest VS Code Copilot best practices and updates existing agent definitions with improved capabilities. | Sub-agent only |
| **git-ops** | [.github/agents/git-ops.agent.md](<.github/agents/git-ops.agent.md>) | **Git Operations Specialist** — Manages local and remote git operations with Conventional Commits enforcement, validation, and workflow automation. | Sub-agent only |

## Workflow Documentation

### Standard Workflow: Requesting Work

1. **Describe your request to @ben**
   ```
   @ben I need to add comprehensive API documentation for the payment service
   ```

2. **@ben analyzes and routes**
   - Determines the request requires documentation writing
   - Delegates to `@doc` with full context

3. **Specialist executes and reports**
   - `@doc` researches the codebase, writes documentation, and reports changes
   - Reports list of modified files and key changes

4. **Changes are committed** (if needed)
   - `@ben` may invoke `@git-ops` to handle commit and push with Conventional Commits

### Ben's Orchestration Logic

**@ben** follows a structured approach:

1. **Analyse** — Determine what kind of work is needed (coding, documentation, research, DevOps, etc.)
2. **Decompose** — Break complex requests into discrete sub-tasks and identify dependencies
3. **Delegate** — Invoke appropriate specialist agents with full context
4. **Coordinate** — Run independent tasks in parallel; sequence dependent ones in order
5. **Report** — Summarize what was delegated, to whom, and the outcome

### When to Invoke Specific Agents

- **@doc** — Documentation, READMEs, API docs, comments, guides
- **@agentic-workflow-researcher** — Research on agentic patterns, VS Code extensibility, GitHub Copilot CLI
- **@ar-director** — When a new specialist capability is needed (Ben invokes this)
- **@ar-upskiller** — Improving existing agents based on latest best practices (Ben invokes this)
- **@git-ops** — Committing and pushing changes with Conventional Commits validation

### Adding New Agents

When the workspace needs a new specialist capability:

1. Request the capability from **@ben**
2. **@ben** invokes **@ar-director** with the capability description
3. **@ar-director** creates a new `.agent.md` file in [.github/agents/](.github/agents/)
4. **@ar-director** updates [.github/copilot-instructions.md](<.github/copilot-instructions.md>) and [.github/agents/ben.agent.md](<.github/agents/ben.agent.md>)
5. New agent becomes available for delegation

Agent files follow the VS Code custom agent format with YAML frontmatter and Markdown instructions. See [VS Code custom agents documentation](https://code.visualstudio.com/docs/copilot/customization/custom-agents) for the full specification.

## Git & Commits

All changes in this workspace follow **Conventional Commits** standards to maintain clean history, enable automated versioning, and ensure clear commit messages.

### Conventional Commits Standard

Every commit must follow this structure:

```
<type>[optional scope]: <short summary>

[optional body]

[optional footer(s)]
```

### Commit Types

| Type | Purpose | Version Impact |
|------|---------|-----------------|
| `feat` | A new feature | Minor version bump |
| `fix` | A bug fix | Patch version bump |
| `docs` | Documentation-only changes | No version change |
| `style` | Code formatting (no logic changes) | No version change |
| `refactor` | Code refactoring (no feature/fix) | No version change |
| `test` | Adding or updating tests | No version change |
| `chore` | Build, dependencies, tooling, config | No version change |
| `perf` | Performance improvements | No version change |
| `ci` | CI/CD configuration changes | No version change |

### Examples

```
feat: add payment service webhook support

The service now accepts and processes payment webhook events
from the Stripe API, enabling real-time transaction updates.

Closes #234
```

```
fix: resolve race condition in user session manager

Use atomic operations instead of read-modify-write pattern
to prevent concurrent session corruption.
```

```
docs: update API authentication guide
```

### Git Operations Workflow

**@git-ops** manages all git operations when changes need to be committed:

1. Changes are completed by specialist agents
2. Agents report the list of modified files to **@ben**
3. **@ben** invokes **@git-ops** with the file list and context
4. **@git-ops** validates all changes, creates Conventional Commits, and pushes
5. **@git-ops** reports the commit hashes and branch status

All commits are validated for:
- Proper Conventional Commits format
- Meaningful commit messages
- Correct type classification
- Proper scope usage (when applicable)

### Integration Tools

The workspace uses these tools for git automation and validation:

- **commitlint** — Validates commit message format
- **husky** — Enforces git hooks for pre-commit validation
- **semantic-release** — Automates versioning based on Conventional Commits

## Quick Start

1. **For general tasks** — Mention @ben and describe what you need
2. **For documentation** — @ben will delegate to @doc
3. **For research** — @ben will delegate to @agentic-workflow-researcher
4. **For git operations** — Changes are automatically committed using Conventional Commits
5. **For new capabilities** — @ben handles recruitment of new specialist agents

## Directory Structure

The workspace is organized to support agent orchestration, documentation, and research:

```
wegrw5/
├── .github/
│   ├── agents/                          Agent definitions (*.agent.md)
│   │   ├── ben.agent.md                 Orchestrator (primary entry point)
│   │   ├── doc.agent.md                 Documentation specialist
│   │   ├── bash-ops.agent.md            Bash script specialist
│   │   ├── explore-codebase.agent.md    Codebase exploration
│   │   ├── research.agent.md            External research
│   │   ├── agentic-workflow-researcher.agent.md  Agentic patterns research
│   │   ├── evaluator.agent.md           Agent evaluation
│   │   ├── ar-director.agent.md         Agent recruitment (HR)
│   │   ├── ar-upskiller.agent.md        Agent upskilling
│   │   └── git-ops.agent.md             Git operations
│   ├── skills/                          Reusable agent skills (domain packages)
│   ├── context/                         Shared context for inter-agent knowledge
│   └── copilot-instructions.md          Routing rules and agent directory
│
├── docs/                                Architecture, guides, research findings
│   ├── research/
│   │   ├── agentic-workflows/           Agent orchestration patterns
│   │   └── ...
│   ├── guides/                          Specialized guides
│   └── architecture/                    System architecture documentation
│
├── .tmp/                                Temporary working files
│   ├── *.pdf                            Research PDFs
│   ├── scripts/                         Temporary scripts
│   └── ...
│
├── .memories/                           Session memory (temporary notes)
├── /memories/                           User and repo shared memory (persistent)
│
└── README.md                            This file (institutional documentation)
```

**Key Directories**:

- **`.github/agents/`** — Single source of truth for agent definitions. Each agent is a `.agent.md` file following VS Code custom agent format.
- **`.github/skills/`** — Reusable skills packages. Skills encapsulate domain-specific knowledge and capabilities for easy agent extension.
- **`.github/context/`** — Shared context for inter-agent communication and knowledge transfer.
- **`docs/`** — Architecture documentation, research findings, and comprehensive guides. This is the knowledge repository for the workspace.
- **`.tmp/`** — Temporary working files (research PDFs, scripts, etc.). Not version-controlled; used for transient work.
- **`/memories/`** — Hindsight persistent memory. Contains user, session, and repository-scoped memory files.

## Workspace Configuration

- **Workspace file** — [wegrw5.code-workspace](<../assets/wegrw5.code-workspace>)
- **Copilot instructions** — [.github/copilot-instructions.md](<.github/copilot-instructions.md>)
- **Agent definitions** — [.github/agents/](.github/agents/) directory
- **Documentation** — This README and agent-specific docs in each `.agent.md` file
- **Memory system** — Hindsight MCP configured via environment and agent instructions

## Roadmap

### In Progress

- **CLI mode wrappers** — @bash-ops is prototyping bash script execution patterns and TDD methodology for shell script development
- **Skills composition** — Defining reusable skill packages that encapsulate specialized knowledge for agent extension
- **Real-world validation** — Testing agent orchestration and hindsight integration in production workflows

### Future Roadmap

- **Enhanced agent coordination** — More sophisticated inter-agent communication patterns
- **Advanced skills library** — Expanding reusable skill packages across domains (API development, testing, DevOps, etc.)
- **Hindsight mental model synthesis** — Automatic generation of new mental models from discovered patterns
- **Performance optimization** — Parallel execution and caching strategies for multi-agent workflows

## Support

Each agent file includes detailed instructions and workflow documentation. For specific agent capabilities, refer to the relevant `.agent.md` file in [.github/agents/](.github/agents/).

For questions about architecture, strategy, or memory system integration, consult the relevant documentation in [docs/](docs/) or review the [Hindsight documentation](https://docs.hindsightai.io/).
