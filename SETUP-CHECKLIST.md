# Copilot Modes Setup Checklist

## Pre-Installation

- [ ] Check that `copilot` CLI is installed:
  ```bash
  which copilot
  ```
  - [ ] If not installed: `brew install copilot`

- [ ] Verify shell is Bash 4.0+ or Zsh:
  ```bash
  echo $SHELL
  ```

- [ ] Ensure write access to `~/.config/`:
  ```bash
  touch ~/.config/.test-write && rm ~/.config/.test-write
  ```

## Installation

- [ ] Navigate to workspace directory containing the installer
- [ ] Run installer script:
  ```bash
  bash copilot-modes-installer.sh
  ```
- [ ] Verify output shows:
  - ✔ copilot CLI found
  - ✔ Config directory created
  - ✔ Wrapper script installed
  - ✔ Log file created

## Activation

- [ ] Copy the print-out from installer (the `source ...` line)
- [ ] Add to appropriate shell profile:
  - For **Zsh**: `~/.zshrc`
  - For **Bash**: `~/.bashrc`

  Paste this line at the end:
  ```bash
  source "$HOME/.config/copilot-modes/copilot-modes.zsh"
  ```

- [ ] Reload shell profile:
  ```bash
  # For zsh
  source ~/.zshrc

  # For bash
  source ~/.bashrc
  ```

## Verification

- [ ] Test basic functionality:
  ```bash
  c-modes  # Should show help menu
  ```

- [ ] Verify functions are available:
  ```bash
  cp-ask "What is 2+2?"  # Should work and show answer
  ```

- [ ] Check logging:
  ```bash
  c-log  # Should show recent invocation(s)
  ```

- [ ] Verify configuration directory:
  ```bash
  ls -la ~/.config/copilot-modes/
  ```
  Should show:
  - `copilot-modes.zsh` (wrapper script)
  - `invocations.log` (log file)

## Try Each Mode (Optional)

- [ ] **Ask mode** (advisory only):
  ```bash
  c-ask -p "What is REST API?"
  ```

- [ ] **Plan mode** (planning):
  ```bash
  c-plan -p "Create a plan for learning TypeScript"
  ```

- [ ] **Edit mode** (scoped editing):
  ```bash
  mkdir -p /tmp/test-scope
  c-edit -p "What edits would you suggest?" --scope /tmp/test-scope
  ```

- [ ] **Agent mode** (autonomous):
  ```bash
  c-agent -p "What would you do to improve code quality?"
  # (Requires confirmation - type 'yes')
  ```

## Next Steps

- [ ] Read `EXAMPLES.md` for real-world usage patterns
- [ ] Read `INSTALLATION.md` for detailed setup and troubleshooting
- [ ] Read `QUICK-REFERENCE.md` for command cheat sheet
- [ ] Set up shell alias (optional):
  ```bash
  alias cask='cp-ask'
  alias cplan='cp-plan'
  alias cagent='c-agent'
  ```

## Notes

- Installation is **idempotent** — safe to run installer multiple times
- All invocations are logged to `~/.config/copilot-modes/invocations.log`
- High-risk operations (c-agent, delete/remove keywords) require confirmation
- `c-edit` requires explicit `--scope` path for safety
- Large inputs (>100K tokens) automatically use Gemini 3.1 Pro
- Model can be overridden with `--model <model-name>`

## Troubleshooting Checklist

If something isn't working:

1. [ ] **Functions not found?**
   - Verify shell profile was modified: `grep "copilot-modes.zsh" ~/.zshrc` (or ~/.bashrc)
   - Reload: `source ~/.zshrc` (or ~/.bashrc)

2. **copilot binary not found?**
   - Install: `brew install copilot`
   - Verify: `which copilot`

3. **Permission denied?**
   - Check permissions: `ls -la ~/.config/copilot-modes/`
   - Make executable: `chmod +x ~/.config/copilot-modes/copilot-modes.zsh`

4. **"Error: --scope required"?**
   - Use `c-edit` with explicit scope: `c-edit -p "task" --scope src/`
   - Scope path must exist

5. **Changes not taking effect?**
   - Open new terminal (new shells inherit changes)
   - Or reload current shell: `source ~/.zshrc`

---

## Setup Complete ✓

Once checklist is complete, your Copilot modes wrapper is ready to use!

**Quick start:**
```bash
c-modes              # Show all modes
cp-ask "hello"       # Try advisory mode
c-log                # View invocations
```

For more examples and detailed usage, see the documentation files:
- `QUICK-REFERENCE.md` — Command cheat sheet
- `EXAMPLES.md` — Real-world usage patterns
- `INSTALLATION.md` — Detailed setup guide
