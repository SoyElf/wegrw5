# Workspace Structure

This document describes the organization of the wegrw5 workspace.

## Root Directory

Minimal files at root only:
- **README.md** — Main project documentation and entry point
- **wegrw5.code-workspace** — VS Code workspace file
- **Configuration files** — .env.hindsight, .gitignore, .stignore, etc.
- **Hidden config** — .github/, .vscode/, .git/ (system directories)
- **Temporary** — .tmp/ (for temporary shared context files)

## Major Directories

### docs/
Complete documentation hierarchy organized by purpose.

#### docs/INDEX.md
Main documentation index and navigation hub.

#### docs/guides/
Learning materials, tutorials, how-to guides for users.
- cli-modes-comprehensive-guide.md — Complete CLI modes walkthrough
- cli-modes-quick-reference.md — Quick reference table
- copilot-models-quick-reference.md — Copilot model reference
- copilot-wrapper-model-guide.md — Model behavior guide
- writing-clean-git-commits-summary.md — Git best practices
- INSTALLATION.md — Setup and installation instructions

#### docs/testing/
Test reports, test documentation, and validation results.
- INTEGRATION-TEST-EXECUTIVE-SUMMARY.md — Test summary
- INTEGRATION-TEST-REPORT.md — Detailed test report

#### docs/checklists/
Operational checklists for users.
- SETUP-CHECKLIST.md — Pre-flight setup checklist
- TEST-COMPLETION-CHECKLIST.md — Testing completion checklist

#### docs/research/
Research findings, analysis, and technical deep dives.
- README.md — Research index
- agent-skills-best-practices.md
- agentic-workflows/ (21 research documents on agent design patterns)

#### docs/EXAMPLES.md
Usage examples and demonstrations.

#### docs/DELIVERY.md
Delivery and deployment documentation.

### scripts/
Executable scripts and utilities, organized by function.

#### scripts/setup/
Setup and installation scripts.
- copilot-modes-installer.sh — Install CLI modes wrapper
- start-hindsight.sh — Start Hindsight service

#### scripts/cli/
CLI utilities and wrappers.
- copilot-modes-wrapper.sh — CLI modes wrapper utility

### .github/
GitHub and repository infrastructure.

#### .github/agents/
Specialist agent definitions (11 agents total).
- ben.agent.md — Orchestrator agent
- doc.agent.md — Documentation specialist
- bash-ops.agent.md — Bash script specialist
- git-ops.agent.md — Git operations specialist
- explore-codebase.agent.md — Codebase exploration specialist
- research.agent.md — External research specialist
- agentic-workflow-researcher.agent.md — Agentic workflows researcher
- ar-director.agent.md — Agent recruitment director
- ar-upskiller.agent.md — Agent upskilling specialist
- evaluator.agent.md — Agent evaluation specialist
- housekeeper.agent.md — Workspace organization specialist
- (Plus supporting instruction files)

#### .github/agents/skills/
Custom workspace skills (team-managed).
- SKILL-TEMPLATE.md — Template for creating new skills
- README.md — Skills library index and metadata guidelines
- cli-modes-skill/ — Custom CLI modes skill

#### .github/context/
Active working context and research files.
- Recent evaluation reports (2026-03-31)
- Strategic documents (hindsight-integration-strategy.md)
- Recruitment documents (recruitment-*.md files)

#### .github/context/archive/
Archived evaluation reports and historical context.
- 2026-03-31/ — Pre-2026-03-31 evaluation reports (9 files)

#### .github/copilot-instructions.md
Main Ben orchestrator routing and agent definitions.

### .agents/
External skills installed via `npx skills` package manager.

#### .agents/skills/
External skills (NOT manually managed—let `npx skills` handle).
- hindsight-docs/ — Hindsight documentation skill (70+ files)
  - SKILL.md — Skill entry point
  - references/ — API reference documentation
  - developer/ — Developer documentation
  - sdks/ — SDK documentation
  - changelog/ — Version history

### .vscode/
VS Code configuration.
- settings.json — Workspace settings
- mcp.json — MCP server configuration

### .tmp/
Temporary shared files directory (not committed).
Used for temporary contextual information shared between user and agents.

## Skill Discovery

Two skill locations serve different purposes:

| Location | Type | Purpose | Management |
|----------|------|---------|-----------|
| `./.agents/skills/` | External | Skills installed via `npx skills` | Package manager |
| `./.github/agents/skills/` | Custom | Team-specific workspace skills | Team-managed |

Both are equally discoverable by agents via metadata (keywords, tags, audience).

See **.github/agents/skills/README-SKILLS-ORGANIZATION.md** for detailed skill organization.

## Organization Principles

1. **Root is minimal** — Only essential entry points and configuration files
2. **Docs are hierarchical** — guides/, research/, testing/, checklists/ organize by purpose
3. **Scripts are categorized** — setup/, cli/ organize by function  
4. **Context is current** — Active work in .github/context/; old work archived for reference
5. **Skills are dual-sourced** — External (npx-managed) and custom (team-managed) coexist
6. **Atomic, organized, clearly structured** — Everything has a deliberate purpose and location

## File Navigation

- **New to the project?** Start with the main [Agentic Orchestration Hub](<../README.md>)
- **Looking for docs?** See [Workspace Documentation Index](<../docs/INDEX.md>)
- **Want to learn?** Start with [Guides & References](<../docs/guides/README.md>)
- **Need research?** See [Research Findings](<../docs/research/README.md>)
- **Working with agents?** See [Workspace Instructions](<./copilot-instructions.md>)
- **Managing skills?** See [Agent Skills Library](<./agents/skills/README.md>)

---

Last updated: March 31, 2026
