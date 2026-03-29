# Tool Restrictions and Safety

## Overview

Tool restrictions ensure agents have only the capabilities they need for their role, preventing misuse, limiting security risks, and focusing agent attention on appropriate tasks. This is a core aspect of agent specialization.

**Core Principle**: Define explicit tool allowlists in agent configuration rather than default-allow-all approach.

---

## Scoping Principles

### Principle 1: Role-Based Scoping

Each agent's tools should match its role and responsibilities:

| Agent Role | Appropriate Tools | Restricted Tools |
|-----------|-------------------|------------------|
| Documentation specialist | file_search, create_file, replace_string, semantic_search | run_in_terminal, delete_file |
| Code reviewer | semantic_search, grep_search, get_errors, create_file (for comments) | run_in_terminal (arbitrary commands) |
| DevOps specialist | run_in_terminal (specific commands), git operations, create_file | arbitrary file deletion |
| Research specialist | semantic_search, grep_search, web search, create_file | file modification (read-only findings) |

### Principle 2: Context-Based Restrictions

Tool access should be scoped to specific use cases:

```
✓ Correct: DevOps agent can run `docker build`, `kubectl apply`, verified scripts
✗ Wrong: DevOps agent can run any shell command (includes `rm -rf /`)
```

### Principle 3: Destructive Operation Controls

Destructive operations need explicit safeguards:

- **File deletion**: Restricted to specific agents; requires clear purpose in instructions
- **Database operations**: Requires approval controls; never auto-approve destructive queries
- **Deployment**: Never auto-approve; always requires explicit user approval or approval flag
- **Force-push Git**: Restricted; requires explicit approval separate from regular git tool use

---

## Tool Allowlist Configuration

### Example Agent Configuration with Tool Restrictions

```yaml
name: Documentation Specialist
description: Writes and updates documentation with high quality standards

tools:
  - name: file_search
    description: Find documentation files by pattern
    restrictions:
      paths:
        - docs/**
        - README.md
        - CONTRIBUTING.md

  - name: semantic_search
    description: Find related documentation and code examples

  - name: create_file
    description: Create new documentation files
    restrictions:
      paths:
        - docs/**
        - "*.md"
      operations:
        - create_only (no overwrite)

  - name: replace_string_in_file
    description: Update existing documentation
    restrictions:
      paths:
        - docs/**
        - "*.md"
        - "!node_modules/**"

  - name: read_file
    description: Read documentation and code for reference

  - name: get_errors (linting)
    description: Check documentation syntax/formatting

# Explicitly NOT available (security/focus)
restricted_tools:
  - run_in_terminal
  - delete_file
  - mcp_github_create_or_update_file (GitHub API calls)
  - database operations

instructions: |
  You are a documentation specialist...
```

---

## Safety Considerations

### 1. File Modification Safety

**Risk**: Agent modifies wrong files or breaks existing content

**Mitigations**:
- Restrict file modification to specific paths (e.g., only `docs/**`)
- Require read-file-first before modifications
- Include instructions to preserve existing content structure
- Verify changes with linting/syntax checking

### 2. External API Calls

**Risk**: Unauthorized API access, credential exposure

**Mitigations**:
- Require authentication validation in instructions
- Store credentials in environment variables, not prompts
- Use MCP servers with built-in auth rather than raw HTTP calls
- Log all API usage for audit trails

### 3. Terminal/Shell Execution

**Risk**: Arbitrary command execution could be destructive or access sensitive data

**Mitigations**:
- **Restrict to specific commands only** (whitelist approach)
  - DevOps agent: `docker`, `kubectl`, custom deployment scripts
  - Build agent: `npm`, `cargo`, `python -m pytest`
- **Never use `/bin/bash` or arbitrary command execution** for general-purpose agents
- **Require explicit approval** for any terminal operations in user-facing agents
- Document exactly which commands are safe for agent use

### 4. Rollback and Recovery

**Risk**: Change made, can't undo; cascading failures

**Mitigations**:
- Verify changes before reporting success
- Include git integration (agents can view diffs to see exactly what changed)
- Document changes explicitly for user review
- For critical operations, require user approval before changes take effect

### 5. Credential Security

**Anti-Pattern**: Credentials in agent instructions

```yaml
# ✗ WRONG - Never do this
instructions: |
  You are a GitHub operations agent.
  Use the GitHub API token: ghp_xxxxxxxxxxxx
  # Risk: Token gets logged, exposed in git history, etc.
```

**Correct Pattern**: Environment variables + MCP authentication

```yaml
# ✓ Correct
instructions: |
  You are a GitHub operations agent.
  Use the GitHub API through the GitHub MCP server.
  The MCP server handles authentication.

# In VS Code settings or CLI config:
# MCP_GITHUB_TOKEN environment variable is set by system
```

---

## Authorization Controls

### Approval Model Levels

#### Level 1: Auto-Approve (Least Restrictive)

**Use Case**: Safe, deterministic operations
- Reading files
- Searching codebase
- Linting/syntax checking

**Risk**: Low; these operations don't modify state

#### Level 2: Interactive Approval

**Use Case**: Modifications that should be reviewed first
- Creating new files
- Modifying existing files
- Creating git commits

**Implementation**: Agent requests permission, user approves before proceeding

#### Level 3: Pre-Approval Only

**Use Case**: Destructive operations; no interactive approval
- File deletion
- Database mutations
- Production deployments

**Implementation**: Pre-approve via approval flags (`--allow-delete-files`); no interactive prompts

#### Level 4: Human Approval Required

**Use Case**: Critical operations
- Force-push git
- Production data deletion
- Disabling security systems

**Implementation**: Always require explicit human approval; no automated approval available

---

## Role-Specific Tool Sets

### Documentation Agent

```yaml
tools:
  - file_search (docs/** only)
  - semantic_search
  - create_file (docs/** only, create-only mode)
  - replace_string_in_file (docs/** only)
  - read_file
  - get_errors (markdown linting)

restrictions: |
  Cannot: modify code, delete files, run arbitrary commands
  Can only: read and write documentation
```

### Code Review Agent

```yaml
tools:
  - semantic_search
  - grep_search
  - read_file
  - get_errors (lint, type errors)
  - create_file (feedback/comments only)

restrictions: |
  Cannot: modify code directly, run commands
  Can only: analyze and provide feedback
```

### DevOps Agent

```yaml
tools:
  - run_in_terminal (restricted to:
      - docker build/push/run
      - kubectl apply/delete/rollout
      - Custom deployment scripts only
    )
  - create_file (config/infrastructure only)
  - read_file
  - get_errors

restrictions: |
  Cannot: arbitrary shell commands, modify application code
  Can only: manage deployment and infrastructure
```

---

## Best Practices

1. **Default Deny**: Start restrictive; add tools as needed. Don't start permissive.

2. **Document Restrictions**: Include restriction rationale in agent instructions.

3. **Test Tool Boundaries**: Verify agent can't access restricted tools even if it tries.

4. **Audit Tool Usage**: Log what tools agents use for security analysis.

5. **Review Periodically**: As agents evolve, revisit whether restrictions still apply.

---

## References

- **Related**: [Agent Definition and Fundamentals](<./agent-definition-and-fundamentals.md>) — agent architecture and tool configuration
- **Related**: [Tool Composition and Design](<./tool-composition-patterns.md>) — using tools effectively
- **Related**: [Common Failure Modes](<./common-failure-modes.md>) — failures from poor tool restriction design
