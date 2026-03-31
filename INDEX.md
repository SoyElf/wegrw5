# Copilot CLI Model Discovery - Complete Index

**Discovery Date**: 2026-03-30
**Copilot Version**: 1.0.12
**Status**: ✓ COMPLETE

---

## Quick Facts

| Item | Value |
|------|-------|
| **Total Models** | 20 (8 Claude + 11 GPT + 1 Gemini) |
| **Default Model** | `claude-opus-4.6` |
| **Format** | Hyphens only, lowercase, no underscores |
| **CLI Flag** | `--model <name>` |
| **Config File** | `~/.copilot/config.json` |

---

## Most Useful Model Names

### For General Use
```bash
--model claude-opus-4.6       # Default, recommended
--model claude-opus-4.6-1m    # For long documents
--model claude-opus-4.6-fast  # Optimized speed
```

### For Budget
```bash
--model claude-haiku-4.5      # Lightweight, fast
--model gpt-5-mini            # Minimal resources
```

### For Power Users
```bash
--model gpt-5.4               # Latest OpenAI
--model claude-sonnet-4.6     # Balanced approach
```

---

## Documentation Index

| Document | Purpose | Size | Audience |
|----------|---------|------|----------|
| **[DISCOVERY-SUMMARY.txt](<../assets/DISCOVERY-SUMMARY.txt>)** | Executive overview (this page) | 3KB | Everyone |
| **[COPILOT-WRAPPER-MODEL-GUIDE.md](<./COPILOT-WRAPPER-MODEL-GUIDE.md>)** | Implementation guide with code samples | 5KB | Developers |
| **[COPILOT-MODELS-QUICK-REFERENCE.md](<./COPILOT-MODELS-QUICK-REFERENCE.md>)** | One-page model lookup | 4KB | Quick reference |
| **[MODEL-DISCOVERY-TEST-RESULTS.md](<./MODEL-DISCOVERY-TEST-RESULTS.md>)** | Detailed test procedures & results | 8KB | Technical review |
| **[MODEL-DISCOVERY-REPORT.md](<./MODEL-DISCOVERY-REPORT.md>)** | Comprehensive discovery report | 12KB | Full documentation |

---

## All 20 Available Models

### Claude (Anthropic) - 8 Models
```
claude-haiku-4.5              # Lightweight
claude-opus-4.5               # Standard
claude-opus-4.6               # Current (DEFAULT)
claude-opus-4.6-fast          # Optimized
claude-opus-4.6-1m            # 1M context
claude-sonnet-4               # Legacy
claude-sonnet-4.5             # Mid-tier
claude-sonnet-4.6             # Current
```

### GPT (OpenAI) - 11 Models
```
gpt-4.1                       # Single GPT-4 version
gpt-5-mini                    # Lightweight GPT
gpt-5.1                       # Version 5.1
gpt-5.1-codex                 # Code focused
gpt-5.1-codex-mini            # Code mini
gpt-5.1-codex-max             # Code max
gpt-5.2                       # Version 5.2
gpt-5.2-codex                 # Version 5.2 code
gpt-5.3-codex                 # Version 5.3 code
gpt-5.4                       # Latest (Version 5.4)
gpt-5.4-mini                  # Version 5.4 mini
```

### Gemini (Google) - 1 Model
```
gemini-3-pro-preview          # Preview access
```

---

## Common Model Name Errors

| ❌ Wrong | ✅ Right | Issue |
|---------|----------|-------|
| `claude-3-5-haiku` | `claude-haiku-4.5` | Wrong version prefix |
| `gpt-4` | `gpt-4.1` | Not available, use v4.1 or v5.x |
| `gpt-4-turbo` | `gpt-5.4` | Not available |
| `claude_opus_4_6` | `claude-opus-4.6` | Use hyphens not underscores |
| `Claude-Opus-4.6` | `claude-opus-4.6` | Use lowercase |

---

## Usage Examples

### In Scripts
```bash
#!/bin/bash
PROMPT="${1:-Default prompt}"
MODEL="${2:-claude-opus-4.6}"

copilot -p "$PROMPT" --model "$MODEL" --allow-all
```

### Interactive
```bash
# Interactive mode with specific model
copilot -i "Your initial prompt" --model claude-opus-4.6

# Resume session with different model
copilot --continue --model gpt-5.4
```

### With Options
```bash
# Share results to file
copilot -p "prompt" --model claude-opus-4.6 --share output.md

# High reasoning effort
copilot -p "prompt" --model claude-opus-4.6 --effort high --allow-all
```

---

## How We Discovered This

### Method 1: Configuration File
```bash
cat ~/.copilot/config.json
# Shows current model: claude-opus-4.6
```

### Method 2: Schema File (Authoritative)
```bash
cat ~/.copilot/pkg/universal/1.0.12/schemas/session-events.schema.json
# Contains complete enum of all 20 models
```

### Method 3: Session Logs
```bash
grep -rh "Using model:" ~/.copilot/logs/
# Shows which models were actually used
```

### Method 4: CLI Testing
```bash
copilot -p test --model gpt-4 --allow-all
# Error: Model "gpt-4" from --model flag is not available.
```

---

## Key Insights

1. **GPT-4 Not Available**: Despite articles mentioning `gpt-4`, only `gpt-4.1` is available. Latest GPT model is `gpt-5.4`.

2. **Claude Versions**: Articles mention `claude-3-5-haiku` but the actual model is `claude-haiku-4.5`.

3. **20 Total Models**: Far more variety than most articles suggest (they usually mention 3-4 options).

4. **Default Changed**: System changed from `claude-sonnet-4.6` to `claude-opus-4.6` as default.

5. **Format is Strict**: Hyphens required, no underscores or mixed case. Model name validation happens at runtime.

---

## Verification Commands

Test that a model works:
```bash
# This will succeed (but may timeout waiting for API)
timeout 2 copilot -p "test" --model claude-opus-4.6 --allow-all

# This will fail immediately with error message
timeout 2 copilot -p "test" --model gpt-4 --allow-all
# Error: Model "gpt-4" from --model flag is not available.
```

---

## For Implementation

When creating or updating the wrapper script:

1. ✓ Use `--model` flag to accept user model preference
2. ✓ Default to `claude-opus-4.6` (current production default)
3. ✓ Validate against the 20 known models before calling CLI
4. ✓ Use hyphens only in model names (no underscores)
5. ✓ Provide helpful error if invalid model specified
6. ✓ Support all 20 models (don't restrict choice)

---

## References

- **Primary Source**: `~/.copilot/pkg/universal/1.0.12/schemas/session-events.schema.json`
- **Config**: `~/.copilot/config.json`
- **History**: `~/.copilot/logs/` (session logs showing models used)
- **CLI Help**: `copilot --help` (documents --model flag)
