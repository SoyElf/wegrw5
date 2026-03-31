# Quick Reference: Copilot Modes

## Installation (One-Time)

```bash
# From the workspace directory:
bash copilot-modes-installer.sh

# Add to ~/.zshrc or ~/.bashrc:
source "$HOME/.config/copilot-modes/copilot-modes.zsh"

# Reload shell:
source ~/.zshrc
```

## Available Modes

| Function | Model | Use Case | Example |
|----------|-------|----------|---------|
| `c-ask` | Haiku 4.5 | Quick analysis | `c-ask -p "explain this"` |
| `c-plan` | Sonnet 4.6 | Planning & structure | `c-plan -p "create plan"` |
| `c-edit` | Sonnet 4.6 | File editing (scoped) | `c-edit -p "add docs" --scope src/` |
| `c-agent` | Opus 4.6 | Complex tasks | `c-agent -p "run tests"` (with confirmation) |

## Quick Commands

```bash
# Show help and examples
c-modes

# View recent invocations
c-log

# Quick advisory (read stdin)
cat error.log | cp-ask "what went wrong?"

# Plan a task
cp-plan "create implementation plan for feature X"

# Safe code editing (requires scope)
c-edit -p "add docstrings" --scope src/

# Autonomous execution (requires confirmation)
c-agent -p "run test suite and report"

# Override model for large input
c-ask -p "analyze this" --model gemini-3.1-pro < huge-file.txt
```

## Common Workflows

### Error Analysis
```bash
./script.sh 2>&1 | cp-ask "what went wrong?"
cp-plan "what's the fix strategy?"
```

### Code Review
```bash
git diff | cp-ask "does this look ok?"
git diff | cp-plan "assess scope and risk"
c-agent -p "run linting, tests, and security scan"
```

### Documentation
```bash
c-ask -p "explain this API" < api-docs.md
cp-plan "how would you reorganize this documentation?"
c-edit -p "add missing examples" --scope docs/
```

### Learning Path
```bash
cp-ask "what is machine learning?"
cp-plan "create 12-week learning roadmap"
c-edit -p "create example code for ML algorithms" --scope examples/
```

## Safety Features

### Confirmation Gates
- **All c-agent calls** require confirmation
- **High-risk keywords** (delete, remove, chmod, sudo, push, deploy, production) trigger confirmation
- Type `yes` at prompt to proceed

### Deny-List (Always Blocked)
- File deletion (`shell(rm)`)
- Permission changes (`shell(chmod)`)
- Ownership changes (`shell(chown)`)
- Privilege escalation (`shell(sudo)`)
- Remote pushes (`shell(git push)`)
- Environment files (`write(*.env)`)

### Scoped Editing
- `c-edit` requires explicit `--scope` path for safety
- Prevents accidental modifications outside intended directory

## What Gets Logged

Location: `~/.config/copilot-modes/invocations.log`

Format: `TIMESTAMP | MODE | PROMPT (60 chars) | RESULT | MODEL`

Entries:
- Success/error status
- timestamp (ISO 8601)
- Mode used
- First 60 characters of prompt
- Model used

View logs: `c-log` (last 10) or `tail -f ~/.config/copilot-modes/invocations.log` (live)

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Command not found: c-ask" | Add to ~/.zshrc: `source "$HOME/.config/copilot-modes/copilot-modes.zsh"` then reload |
| "copilot CLI not found" | Install: `brew install copilot` |
| "Error: --scope required" | Use: `c-edit -p "task" --scope src/` (path must exist) |
| "Operation cancelled" | You rejected the confirmation prompt; re-run if you want to proceed |
| Slow performance | Input too large? Use `--model gemini-3.1-pro` for >100K tokens |

## Files Created

After installation:
- `~/.config/copilot-modes/copilot-modes.zsh` — Wrapper functions
- `~/.config/copilot-modes/invocations.log` — Invocation log

## Model Selection

**Automatic:**
- `c-ask` → Claude Haiku 4.5 (fast)
- `c-plan` → Claude Sonnet 4.6 (balanced)
- `c-edit` → Claude Sonnet 4.6 (editing)
- `c-agent` → Claude Opus 4.6 (powerful)
- **Large input (>100K tokens)** → Gemini 3.1 Pro

**Override:** `--model <model-name>`
```bash
c-ask -p "task" --model claude-opus-4.6
cp-ask "task" --model gemini-3.1-pro
```

## For More Info

- **Setup:** See `docs/guides/INSTALLATION.md`
- **Examples:** See `docs/EXAMPLES.md` (30+ real-world patterns)
- **Inline help:** Run `c-modes` after installation

---

*Last Updated: March 30, 2026*
