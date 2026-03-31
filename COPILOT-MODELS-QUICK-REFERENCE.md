# Copilot CLI Models - Quick Reference

## Correct Model Names (Copilot CLI 1.0.12)

### Format
```
--model <name>
```

All models use **hyphens** (not underscores), **lowercase**, semantic versioning.

### Claude Models (Anthropic)
```bash
--model claude-haiku-4.5                 # Lightweight, fast
--model claude-opus-4.5                  # Standard
--model claude-opus-4.6                  # Current default
--model claude-opus-4.6-fast             # Optimized for speed
--model claude-opus-4.6-1m               # 1M context window
--model claude-sonnet-4                  # Balanced (legacy)
--model claude-sonnet-4.5                # Balanced (v4.5)
--model claude-sonnet-4.6                # Balanced (current)
```

### GPT Models (OpenAI) - Version 5.x Only
```bash
--model gpt-4.1                          # GPT-4 equivalent
--model gpt-5-mini                       # Lightweight GPT-5
--model gpt-5.1                          # GPT-5.1
--model gpt-5.1-codex                    # Codex variant
--model gpt-5.1-codex-mini               # Codex mini
--model gpt-5.1-codex-max                # Codex max
--model gpt-5.2                          # GPT-5.2
--model gpt-5.2-codex                    # GPT-5.2 codex
--model gpt-5.3-codex                    # GPT-5.3 codex
--model gpt-5.4                          # GPT-5.4 (latest)
--model gpt-5.4-mini                     # GPT-5.4 mini
```

### Gemini Models (Google)
```bash
--model gemini-3-pro-preview             # Gemini 3 Pro preview
```

## Examples

```bash
# Use with prompt
copilot -p "What is the weather?" --model claude-opus-4.6 --allow-all

# Use with interactive mode
copilot -i "Start debugging this" --model gpt-5.4

# Use with session share
copilot -p "Analyze this code" --model claude-haiku-4.5 --share
```

## What Does NOT Work

❌ `claude-3-5-haiku` → Use `claude-haiku-4.5`
❌ `claude-3-sonnet` → Use `claude-sonnet-4.6`
❌ `gpt-4` → Use `gpt-4.1` or `gpt-5.4`
❌ `gpt-4-turbo` → Not available
❌ Underscores or CamelCase → Use **hyphens only**

## Default Model

If not specified, uses: **`claude-opus-4.6`**

To change default, edit `~/.copilot/config.json`:
```json
{
  "model": "claude-opus-4.6"
}
```

## Testing Model Availability

```bash
# This WILL fail (shows error message)
copilot -p "test" --model gpt-4 --allow-all
# Error: Model "gpt-4" from --model flag is not available.

# This WILL work (all listed models above are valid)
copilot -p "test" --model claude-opus-4.6 --allow-all
```
