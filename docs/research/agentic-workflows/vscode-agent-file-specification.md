# VS Code Agent File Specification

## Structure and Format

The `.agent.md` file is the declarative definition of a VS Code custom agent. It uses YAML frontmatter for metadata followed by Markdown for detailed instructions. This structure makes agents discoverable, version-controllable via git, and human-readable.

Basic structure:

```markdown
---
name: Agent Name
description: Clear description of purpose
tools:
  - tool_name
instructions: |
  Detailed markdown instructions...
---
```

## Required Fields

**name** (string)
The agent's display name. Should be descriptive and unique within your workspace.
Examples: "Documentation Specialist", "Code Reviewer", "Research Agent"

**description** (string)
Clear, concise description of what the agent does and its primary capabilities. Should be 1-2 sentences.
Example: "Writes, updates, and improves documentation with focus on clarity and completeness"

**tools** (array)
List of tools the agent can access. Each entry can be a string (tool name) or object with configuration.

```yaml
tools:
  - file_search
  - semantic_search
  - create_file
  - replace_string_in_file
  - multi_replace
```

**instructions** (string)
Detailed Markdown instructions that guide agent behavior. This is the primary behavioral specification. Can be 200-2000+ words. Include sections for: role description, responsibilities, constraints, quality standards, workflow examples, error handling.

## Optional Fields

**version** (string)
Semantic version for tracking agent evolution. Enables versioning in git history.
Recommended format: `1.0.0`, `1.1.0`, etc.

```yaml
version: 1.2.0
```

**tags** (array)
Keywords for agent discovery. Helps orchestrators identify appropriate agents.
```yaml
tags:
  - documentation
  - technical-writing
  - markdown
```

**scope** (string)
Where the agent is available: `user` (global) or `workspace` (repository-specific).
```yaml
scope: workspace
```

**custom_instructions** (string)
Additional behavioral modifications beyond the main instructions. Used for fine-tuning specific aspects.

**models** (array)
If specified, which models can run this agent (e.g., `claude-haiku-4.5`, `claude-sonnet-4.6`).

## Instructions Section Best Practices

The instructions section is where agent behavior is defined. Structure instructions clearly:

**Role and Purpose**
Start with explicit role statement: "You are a [role]. Your job is to [primary job]."
Clarify what you are NOT: "You do not write application code. You do not perform DevOps tasks."

**Responsibilities**
Bullet list of what the agent is accountable for delivering. Be specific.
- Write clear, well-structured documentation
- Update existing docs for accuracy and completeness
- Ensure consistency with project style guide

**Constraints and Boundaries**
Explicit constraints prevent agents from overstepping:
- Only modifies documentation files (not application code)
- Does not make architectural decisions (requests clarification from orchestrator)
- Does not commit code without explicit approval

**Workflow and Processing Steps**
If applicable, describe the step-by-step workflow:
1. Read existing documentation for context and style
2. Search codebase to understand current implementation
3. Identify documentation gaps or inaccuracies
4. Create or update documentation
5. Verify consistency and completeness

**Quality Standards**
Define explicit quality thresholds:
- All documentation must match existing style guide (see docs/_style-guide.md for details)
- Code examples must be tested and correct
- Links must be verified
- Grammar and spelling must be checked

**Error Handling**
Specify how to handle blockers and errors:
- If unable to understand requirement after 2 attempts, ask for clarification
- If file modifications fail, report specific error to orchestrator
- If context is insufficient, request additional information

**Examples and References**
Include concrete examples of desired behavior:
- Reference successful past outputs
- Show example structures
- Point to related documentation
- Link to style guides and conventions

## Tool Configuration

Tools can be specified minimally (just the name) or with details:

```yaml
tools:
  - file_search
  - semantic_search:
      max_results: 10
  - create_file
  - replace_string_in_file
```

Common tools available to agents:

| Tool | Purpose | Use When |
|------|---------|----------|
| `file_search` | Find files by name/glob pattern | Discovering project structure |
| `semantic_search` | Search codebase semantically | Understanding code relationships |
| `grep_search` | Text/regex search in files | Finding specific code patterns |
| `create_file` | Create new files with content | Writing new documentation, code |
| `replace_string_in_file` | Edit existing files | Updating documentation, code changes |
| `multi_replace` | Batch file edits | Efficient multiple file updates |
| `get_errors` | Retrieve lint/compile errors | Code quality analysis |
| `get_changed_files` | View git diffs | Understand recent changes |

## Example: Documentation Specialist Agent

```yaml
---
name: Documentation Specialist
description: Writes clear, well-structured documentation that matches project conventions
version: 1.0.0
scope: workspace
tags:
  - documentation
  - technical-writing
tools:
  - file_search
  - semantic_search
  - create_file
  - replace_string_in_file
  - multi_replace

instructions: |
  # Role
  You are a documentation specialist. Your job is to write, update, and improve documentation
  that is clear, accurate, and consistent with project standards.

  # Responsibilities
  - Write new documentation from scratch when requested
  - Update existing documentation for accuracy and completeness
  - Ensure consistency with project style guide
  - Verify all code examples are correct and tested

  # Constraints
  - Only modify documentation files (README.md, docs/*, comments)
  - Do not write application code
  - Do not make architectural decisions
  - Request clarification if requirements are unclear

  # Quality Standards
  - Match existing documentation style (see docs/_style-guide.md)
  - All code examples must be runnable
  - Include concrete examples and use cases
  - Verify internal links are correct
  - Check spelling and grammar

  # Workflow
  1. Search codebase to understand implementation
  2. Read existing documentation for context and style
  3. Identify gaps or inaccuracies
  4. Create or update documentation
  5. Verify consistency and completeness

  # Error Handling
  - If unable to understand requirement clearly, ask orchestrator for clarification
  - If file modification fails, report specific error
  - If code examples fail, request correction from appropriate specialist
---
```

## Directory Organization

Agents are organized by scope:

**Workspace Agents** (Repository-specific)
Location: `.github/agents/` or `.copilot/agents/`
Example files:
- `.github/agents/ben.agent.md` (orchestrator)
- `.github/agents/doc.agent.md` (documentation)
- `.github/agents/research.agent.md` (research)

**User Agents** (Personal tools)
Location: `~/.copilot/agents/`
Used for personal workflows, not shared with team

## Versioning and Updates

Version agents in git:
- Track changes to agent behavior in commits
- Enable rollback if agent changes cause issues
- Document behavioral evolution

When updating agents:
- Increment version number
- Include changelog in commit message
- Test with representative tasks before deploying

## Related Concepts

- [VS Code Custom Agents Overview](<./vscode-custom-agents-overview.md>) — Overview of agent system
- [Agent Tool Capabilities and Composition](agent-tool-capabilities-and-composition.md) — What tools do
- [Agent Modes and Customization](agent-modes-and-customization.md) — Behavioral customization
- [Agent Specialization and Role Definition](agent-specialization-and-role-definition.md) — Designing focused roles
