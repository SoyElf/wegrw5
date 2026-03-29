# VS Code Custom Agents Overview

## What Are VS Code Custom Agents?

VS Code custom agents are specialized versions of GitHub Copilot configured via `.agent.md` files. They extend the base Copilot experience with custom instructions, restricted tool access, and behavioral patterns tailored to specific workflows. A `.agent.md` file is a declarative way to create a focused AI assistant for specialized tasks within the VS Code editor.

Custom agents address a fundamental problem: a single general-purpose AI isn't optimal for all tasks. A documentation specialist needs different tools and instructions than a code reviewer, which differ from a research specialist. VS Code agents formalize this specialization.

## Agent Definition and Discovery

Agents are defined in markdown files with YAML frontmatter:

```yaml
name: Documentation Specialist
description: Writes and updates documentation
tools:
  - file_search
  - create_file
  - replace_string_in_file
instructions: |
  You are a documentation specialist...
```

Agents can be discovered in multiple ways:
- **Workspace-level agents**: defined in `.github/agents/*.agent.md` (recommended for team collaboration)
- **User-level agents**: defined in `~/.copilot/agents/*.agent.md` (personal tools)
- **Project convention**: agents are referenced in orchestration setups (e.g., `@ben`, `@doc`)

## Core Capabilities

VS Code agents can be invoked in multiple ways:

**Explicit Invocation**: User explicitly selects agent (e.g., `@doc` in Copilot Chat)

**Orchestrator Delegation**: Orchestrator agent routes work to specialists programmatically

**Context-Based**: VS Code automatically suggests relevant agents based on file type or task

Agents have access to comprehensive tooling:
- File system operations (search, create, edit, delete)
- Semantic code search (understand code relationships, not just text)
- Git integration (view diffs, commit history)
- Error diagnostics (linting, type checking)
- Language-specific analyzers

## Agent Modes and Behavioral Specialization

VS Code supports multiple agent modes that customize behavior:

**Code Generation Mode**: Optimized for writing and modifying code. Agents focus on correctness, performance, and style adherence.

**Analysis Mode**: Designed for code review, architecture analysis, and diagnostics. Agents examine code quality, identify issues, propose improvements.

**Documentation Mode**: Specialized for writing clear, well-structured documentation. Agents focus on precision, completeness, and audience-appropriate language.

**Research Mode**: Investigates complex topics, synthesizes information, cites sources. Agents emphasize exploration and accuracy.

**Orchestration Mode**: Routes work to specialists, coordinates execution. Agents focus on decomposition and delegation.

## Tools and Restrictions

Agents don't have access to all capabilities by default. Tool access is explicitly configured in the agent definition:

**Why Restrict?** Preventing agents from using unnecessary tools reduces hallucination, improves focus, and enables security controls.

**Tool Composition**: Strategic combinations of tools accomplish complex work. For example: search codebase → analyze results → create file → validate changes.

**MCP Integration**: Model Context Protocol servers extend tool capabilities with external services (GitHub API, web search, custom domains).

## User-Invokable vs Sub-Agents

**User-Invokable**: Agents users can directly invoke (e.g., `@doc`, `@research`). These are general-purpose specialists.

**Sub-Agents**: Only invoked by orchestrator agents, not directly by users. These are specialized utilities for specific workflows.

## File Specification Requirements

A valid `.agent.md` file includes:

- **name**: Displayed name (e.g., "Documentation Specialist")
- **description**: Clear purpose and primary capabilities
- **tools**: Array of tool configurations agent can access
- **instructions**: Detailed Markdown instructions for behavior
- **version**: (optional) Semantic version for tracking updates
- **tags**: (optional) Keywords for discovery

## Integration with Workspace Structure

VS Code agents integrate seamlessly with workspace conventions:

- Agents inherit workspace context (directory structure, recent changes, open files)
- Agents can reference project configuration (`.copilot-settings.json`, `.editorconfig`)
- Agents follow linting and style rules defined in workspace
- Agents discover related agents via agent directory conventions

## Common Use Patterns

**Orchestration Hub**: Central orchestrator agent (`@ben`) routes work to specialists (`@doc`, `@research`, `@git-ops`)

**Domain Specialists**: Agents specialized in documentation, code review, testing, DevOps

**Workshop Agents**: Temporary agents for specific projects or initiatives

**Cleanup and Maintenance**: Agents specialized in refactoring, deprecation, technical debt

## Related Concepts

- [VS Code Agent File Specification](<./vscode-agent-file-specification.md>) — Detailed `.agent.md` file structure
- [Agent Modes and Customization](agent-modes-and-customization.md) — Behavioral specialization
- [Agent Tool Capabilities and Composition](agent-tool-capabilities-and-composition.md) — What agents can do
- [Multi-Agent Orchestration Principles](<./multi-agent-orchestration-principles.md>) — Coordinating multiple agents
