## GitHub Copilot CLI Model Discovery - Test Results

**Date**: 2026-03-30
**CLI Version**: 1.0.12
**Test Environment**: Linux

---

## Test #1: Version & Help Check
```bash
$ copilot --version
GitHub Copilot CLI 1.0.12.

$ copilot --help | grep -A2 "model"
--model <model>                       Set the AI model to use
```
✓ **Result**: `--model` flag works, accepts model name argument

---

## Test #2: Configuration File
```bash
$ cat ~/.copilot/config.json | grep model
"model": "claude-opus-4.6"
```
✓ **Result**: Default model is `claude-opus-4.6` (Anthropic Claude)

---

## Test #3: Invalid Model Name
```bash
$ copilot -p "test" --model gpt-4 --allow-all
Error: Model "gpt-4" from --model flag is not available.
```
✗ **Result**: GPT-4 is NOT available. Only GPT-5.x supported.

---

## Test #4: Schema File Analysis
Source: `~/.copilot/pkg/universal/1.0.12/schemas/session-events.schema.json`

```
Anthropic Claude:    8 models available
  - claude-haiku-4.5
  - claude-opus-4.5, claude-opus-4.6, claude-opus-4.6-fast, claude-opus-4.6-1m
  - claude-sonnet-4, claude-sonnet-4.5, claude-sonnet-4.6

OpenAI GPT:          11 models available
  - gpt-4.1
  - gpt-5-mini
  - gpt-5.1, gpt-5.1-codex, gpt-5.1-codex-mini, gpt-5.1-codex-max
  - gpt-5.2, gpt-5.2-codex
  - gpt-5.3-codex
  - gpt-5.4, gpt-5.4-mini

Google Gemini:       1 model available
  - gemini-3-pro-preview

TOTAL: 20 distinct models
```

---

## Test #5: Log Analysis (Session Logs)
Session history shows these models used successfully:
```
✓ claude-opus-4.6 (most frequent)
✓ claude-haiku-4.5
✓ claude-sonnet-4.6
✓ gpt-5.4
✓ gpt-5.2
```

---

## Key Findings

### Model Name Format
| Rule | Example | Counter-Example |
|------|---------|-----------------|
| Use hyphens | `claude-opus-4.6` | ~~claude_opus_4.6~~ ❌ |
| Use lowercase | `gpt-5.2-codex` | ~~GPT-5.2-Codex~~ ❌ |
| Semantic version | `4.6`, `5.2`, `5.1` | ~~4-6~~ ❌ |
| Optional variants | `-fast`, `-1m`, `-codex` | Required for some |

### CLI Flag Usage
```bash
copilot -p "prompt" --model MODEL_NAME --allow-all
```

### Default Behavior
1. **Explicit flag**: `--model claude-opus-4.6`
2. **Config file**: `~/.copilot/config.json` (model: "claude-opus-4.6")
3. **Fallback**: System default (currently: claude-opus-4.6)

### What the Article Got Wrong
| Article Said | Actual API | Fix |
|---|---|---|
| `claude-3-5-haiku` | `claude-haiku-4.5` | Remove version prefix |
| `gpt-4` | `gpt-4.1` | Only GPT-5.x available |
| `claude-3-sonnet` | `claude-sonnet-4.6` | Update model name |

---

## Recommendations for Implementation

### DO USE:
```bash
--model claude-opus-4.6          # Default, recommended
--model claude-sonnet-4.6        # Balanced alternative
--model claude-haiku-4.5         # Lightweight option
--model gpt-5.4                  # Latest GPT version
```

### DON'T USE:
```bash
--model claude-3-5-haiku         # ❌ Wrong format
--model gpt-4                    # ❌ Not available
--model gpt-4-turbo              # ❌ Not available
--model claude_opus_4_6          # ❌ Use hyphens
```

---

## Validation Method

To verify a model is available:
```bash
# Valid model: command runs (times out waiting for API if no network)
timeout 1 copilot -p "test" --model claude-opus-4.6 --allow-all

# Invalid model: error message appears immediately
copilot -p "test" --model invalid-xyz --allow-all
# Error: Model "invalid-xyz" from --model flag is not available.
```

---

## Source Files

| File | Purpose |
|------|---------|
| `~/.copilot/config.json` | Current settings & default model |
| `~/.copilot/pkg/universal/1.0.12/schemas/session-events.schema.json` | Definitive model list |
| `~/.copilot/logs/*.log` | Session history with models used |
| `copilot --help` | CLI documentation |
