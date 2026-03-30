# Copilot Modes Installation Guide

## Overview

This guide will help you install and configure the GitHub Copilot modes wrapper system. The installation is quick, safe, and idempotent (can be run multiple times).

## Prerequisites

Before installing, ensure you have:

1. **GitHub Copilot CLI** installed and working
   ```bash
   # Check if installed
   which copilot

   # If not installed, install via Homebrew
   brew install copilot

   # Or download from: https://github.com/github/copilot-cli
   ```

2. **Bash or Zsh** shell (both supported)
   ```bash
   echo $SHELL
   ```

3. **Write access** to `~/.config/` directory

## Installation Steps

### Step 1: Get the Installation Script

The installation files should be in your current directory:
- `copilot-modes-installer.sh` — Installation script
- `copilot-modes-wrapper.sh` — Main wrapper with all functions

### Step 2: Run the Installer

```bash
bash copilot-modes-installer.sh
```

What this does:
- ✅ Creates `~/.config/copilot-modes/` directory
- ✅ Installs the wrapper script
- ✅ Creates an empty invocations log
- ✅ Shows you what to add to your shell profile
- ✅ Does NOT modify your `.zshrc` or `.bashrc` (you do that manually for safety)

### Step 3: Add to Your Shell Profile

The installer will print the exact command to add. Here's what to do:

**For Zsh** (`~/.zshrc`):
```bash
# Add this line to the end of ~/.zshrc
source "$HOME/.config/copilot-modes/copilot-modes.zsh"
```

**For Bash** (`~/.bashrc`):
```bash
# Add this line to the end of ~/.bashrc
source "$HOME/.config/copilot-modes/copilot-modes.zsh"
```

Then reload your shell:
```bash
# For zsh
source ~/.zshrc

# For bash
source ~/.bashrc
```

### Step 4: Verify Installation

Test that everything works:

```bash
# Show available modes (tests if functions loaded)
c-modes

# Try a quick test
c-ask -p "hello, what's 2+2?"

# View log (shows invocations)
c-log
```

## Configuration

### Default Behavior

After installation, the wrapper is ready to use with sensible defaults:

| Mode | Model | Purpose | Safety |
|------|-------|---------|--------|
| `c-ask` | Claude Haiku 4.5 | Analysis/explanation | Read-only |
| `c-plan` | Claude Sonnet 4.6 | Planning/structuring | Read-only |
| `c-edit` | Claude Sonnet 4.6 | File editing | Scoped write |
| `c-agent` | Claude Opus 4.6 | Autonomous tasks | Approval gate |

### Configuration Directory

Everything lives in `~/.config/copilot-modes/`:

```
~/.config/copilot-modes/
├── copilot-modes.zsh      # Main wrapper (installed by installer)
└── invocations.log        # Log of all invocations (created by installer)
```

The wrapper is designed to be sourced (not executed directly), so don't try to run `copilot-modes.zsh` as a script—just source it in your shell profile.

### Custom Models

You can override the default model for any mode:

```bash
# Use a specific model for this invocation
c-ask -p "analyze this" --model claude-opus-4.6

# Or use Gemini for large inputs
c-plan -p "plan this project" --model gemini-3.1-pro
```

## Troubleshooting

### "Error: copilot CLI not found"

The `copilot` binary is not installed or not in your `$PATH`.

**Solution:**
```bash
# Install via Homebrew
brew install copilot

# Or verify it's in PATH
which copilot
```

### "Command not found: c-ask"

The wrapper script is not sourced into your current shell session.

**Solutions:**
1. Verify you added the source line to your shell profile
2. Reload your shell: `source ~/.zshrc` or `source ~/.bashrc`
3. Open a new terminal (new shells from here on will have it)

### "c-edit: Error: --scope flag required"

The `c-edit` mode requires an explicit `--scope` path for safety.

**Solution:**
```bash
# Correct usage:
c-edit -p "add docstrings" --scope src/

# Don't use convenience wrapper (it bypasses safety):
# Don't do: cp-edit "add docstrings" --scope src/
```

### "Operation cancelled"

You rejected a confirmation prompt.

**Context:** High-risk operations and all `c-agent` mode tasks require explicit confirmation. This is intentional and safe.

**Solution:** If you trust the operation, run it again and type `yes` at the confirmation prompt.

### Large Inputs Slow

For inputs >100K tokens, the wrapper automatically uses Gemini 3.1 Pro (2M token context).

**Solutions:**
1. Let it use Gemini (it's designed for this)
2. Or split your input into smaller pieces
3. Or explicitly specify a model: `c-ask --model claude-opus-4.6 -p "analyze this"`

## Uninstallation

To remove the wrapper:

```bash
# Remove from shell profile (e.g., ~/.zshrc)
# Delete or comment out the line:
#   source "$HOME/.config/copilot-modes/copilot-modes.zsh"

# Remove the configuration directory (optional)
rm -rf ~/.config/copilot-modes/

# Reload shell
source ~/.zshrc
```

## Advanced Usage

### Piping Between Modes

Chain modes using Unix pipes:

```bash
# Analyze with ask, then plan based on findings
git log -5 --oneline | cp-ask "summarize these commits" | cp-plan "create todo from summary"

# Read code, explain it, then get refactor plan
cat src/main.rs | cp-ask "what does this do?" | cp-plan "how would you refactor this?"
```

### Logging

All invocations are logged to `~/.config/copilot-modes/invocations.log`:

```
TIMESTAMP               | MODE       | PROMPT          | RESULT    | MODEL
2026-03-30T14:23:45Z    | c-ask      | explain this... | success   | claude-haiku-4.5
2026-03-30T14:24:10Z    | c-plan     | create plan...  | success   | claude-sonnet-4.6
2026-03-30T14:24:50Z    | c-agent    | deploy app      | cancelled | claude-opus-4.6
```

View recent logs:
```bash
c-log              # Last 10 invocations
tail -f ~/.config/copilot-modes/invocations.log  # Live monitoring
```

### Bash vs Zsh

The wrapper works identically in both shells:

- **Zsh**: Native support for all functions and features
- **Bash 4.0+**: Full support (some features require bash 4.0+)

If you're using an older bash version, you may see warnings. Upgrade or switch to zsh for full compatibility.

### Reinstallation

The installer is idempotent (safe to run multiple times):

```bash
# Running again won't break anything
bash copilot-modes-installer.sh

# It will:
# ✓ Skip creating config dir if it exists
# ✓ Overwrite wrapper with latest version
# ✓ Preserve your log file
```

## Security Considerations

### Deny-List Guardrails

By default, these operations are blocked across all modes:

```
• shell(rm)           — File deletion forbidden
• shell(rm:*)         — Recursive deletion forbidden
• shell(chmod)        — Permission changes forbidden
• shell(chown)        — Ownership changes forbidden
• shell(sudo)         — Privilege escalation forbidden
• shell(git push)     — Remote pushes forbidden
• write(*.env)        — Environment files protected
• write(**/.env*)     — All .env variants protected
```

### Confirmation Gates

High-risk operations trigger confirmation:

**Automatic trigger:**
- All `c-agent` mode invocations
- Prompts containing keywords: `delete`, `remove`, `chmod`, `sudo`, `push`, `deploy`, `production`

**Example:**
```bash
$ cp-agent "remove old logs"
⚠️  High-risk operation requested:
  Mode: c-agent
  Prompt: remove old logs
  Model: claude-opus-4.6

Proceed? (type 'yes' to continue): no
Operation cancelled.
```

### Logging

All invocations are logged (timestamp, mode, prompt, result, model) for audit trails and hindsight observation.

## Next Steps

1. ✅ Installation complete
2. 📖 Read [Examples](<../wegrw2/projects/zotero-graphql_ts/docs/api/examples.md>) for real usage patterns
3. 🧪 Try each mode: `c-modes` shows quickstart
4. 📝 Check `c-log` periodically to review your usage
5. 🔍 Use modes with hindsight: combine with memory system for institutional learning

## Support

For issues or questions:

1. Check the [Troubleshooting](<#troubleshooting>) section above
2. Run `c-modes` for inline help
3. Review [Examples](<../wegrw2/projects/zotero-graphql_ts/docs/api/examples.md>) for usage patterns
4. Check shell compatibility (Bash 4.0+ or Zsh required)

---

**Last Updated:** March 30, 2026
