# Copilot CLI Model Names - Wrapper Script Guide

## TLDR: Use These Models

```bash
# Recommended for wrapper script
claude-opus-4.6           # Default, most capable
claude-sonnet-4.6        # Balanced, faster
claude-haiku-4.5         # Lightweight, fastest
gpt-5.4                  # Latest OpenAI
```

## Complete Available Models

### Claude (8 total)
- `claude-haiku-4.5` ← lightweight
- `claude-opus-4.5` ← standard
- `claude-opus-4.6` ← **DEFAULT**
- `claude-opus-4.6-fast` ← optimized
- `claude-opus-4.6-1m` ← long context
- `claude-sonnet-4` ← legacy
- `claude-sonnet-4.5` ← mid-tier
- `claude-sonnet-4.6` ← current

### GPT (11 total)
- `gpt-4.1` ← single version of GPT-4
- `gpt-5-mini` ← lightweight
- `gpt-5.1` + 3 codex variants
- `gpt-5.2` + 1 codex variant  
- `gpt-5.3-codex`
- `gpt-5.4` ← **latest**
- `gpt-5.4-mini`

### Gemini (1 total)
- `gemini-3-pro-preview`

## usage in wrapper

```bash
#!/bin/bash

# Default model
MODEL="${1:-claude-opus-4.6}"

# Validate (optional - all listed above work)
case "$MODEL" in
    claude-opus-4.6|claude-sonnet-4.6|claude-haiku-4.5|gpt-5.4)
        : # valid
        ;;
    *)
        echo "Unknown model: $MODEL"
        exit 1
        ;;
esac

# Use with copilot
copilot -p "prompt" --model "$MODEL" --allow-all
```

## Error Messages

**Invalid model** (will fail):
```
$ copilot -p test --model gpt-4 --allow-all
Error: Model "gpt-4" from --model flag is not available.
```

**Valid model** (will work):
```
$ copilot -p test --model gpt-5.4 --allow-all
(waits for API response...)
```

## Format Rules

1. **Always hyphens**: `claude-opus-4.6` YES, `claude_opus_4_6` NO
2. **Always lowercase**: `gpt-5.4` YES, `GPT-5.4` NO
3. **Semantic versioning**: `4.6` YES, `4-6` NO
4. **Optional variants**: `-fast`, `-1m`, `-codex`, `-mini`, `-preview`

## Config File Alternative

Instead of `--model` flag, can edit `~/.copilot/config.json`:
```json
{
  "model": "claude-opus-4.6"
}
```

Then copilot uses that model by default.

## Selection Guide

| Use Case | Recommended Model |
|----------|-------------------|
| General tasks | `claude-opus-4.6` |
| Quick jobs | `claude-haiku-4.5` |
| Code analysis | `claude-opus-4.6` |
| Complex reasoning | `claude-opus-4.6-1m` |
| OpenAI preference | `gpt-5.4` |
| Budget-constrained | `claude-haiku-4.5` |
