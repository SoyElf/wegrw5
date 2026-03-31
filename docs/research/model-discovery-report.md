# GitHub Copilot CLI - Available Models Discovery Report

**Generated**: 2026-03-30
**Copilot Version**: 1.0.12
**OS**: Linux

## Executive Summary

The GitHub Copilot CLI supports a diverse set of LLM models including:
- **Claude models** (Anthropic): Multiple versions with variants
- **GPT models** (OpenAI): Version 5.x series (no GPT-4)
- **Gemini models** (Google): Limited preview access

## Test Commands Executed

### 1. Version Check
```bash
$ copilot --version
GitHub Copilot CLI 1.0.12.
Run 'copilot update' to check for updates.
```
**Result**: ✓ CLI is version 1.0.12

### 2. Help Command
```bash
$ copilot --help | grep -A5 "model"
--model <model>                       Set the AI model to use
```
**Result**: ✓ `--model` flag exists and accepts a model name argument

### 3. Invalid Model Test
```bash
$ copilot -p "test" --model gpt-4 --allow-all
Error: Model "gpt-4" from --model flag is not available.
```
**Result**: ✗ GPT-4 is NOT available (only GPT-5.x)

### 4. Configuration File Analysis
```bash
$ cat ~/.copilot/config.json | grep model
"model": "claude-opus-4.6"
```
**Result**: ✓ Default model is `claude-opus-4.6`

## Complete List of Available Models

### Claude Models (Anthropic)
| Model Name | Type | Status |
|-----------|------|--------|
| `claude-haiku-4.5` | Lightweight | ✓ Available |
| `claude-opus-4.5` | Full-size | ✓ Available |
| `claude-opus-4.6` | Full-size (current) | ✓ Available |
| `claude-opus-4.6-fast` | Optimized | ✓ Available |
| `claude-opus-4.6-1m` | 1M context | ✓ Available |
| `claude-sonnet-4` | Balanced | ✓ Available |
| `claude-sonnet-4.5` | Balanced (prev) | ✓ Available |
| `claude-sonnet-4.6` | Balanced (current) | ✓ Available |

### GPT Models (OpenAI)
| Model Name | Type | Status |
|-----------|------|--------|
| `gpt-4.1` | Legacy | ✓ Available |
| `gpt-5-mini` | Lightweight | ✓ Available |
| `gpt-5.1` | Version 5.1 | ✓ Available |
| `gpt-5.1-codex` | Codex variant | ✓ Available |
| `gpt-5.1-codex-mini` | Mini codex | ✓ Available |
| `gpt-5.1-codex-max` | Max codex | ✓ Available |
| `gpt-5.2` | Version 5.2 | ✓ Available |
| `gpt-5.2-codex` | Codex variant | ✓ Available |
| `gpt-5.3-codex` | Codex variant | ✓ Available |
| `gpt-5.4` | Version 5.4 (latest) | ✓ Available |
| `gpt-5.4-mini` | Mini variant | ✓ Available |

### Gemini Models (Google)
| Model Name | Type | Status |
|-----------|------|--------|
| `gemini-3-pro-preview` | Preview | ✓ Available |

## Model Name Format Rules

### Format Pattern
```
[vendor]-[model]-[version](-[variant])?
```

Examples:
- `claude-opus-4.6` → Vendor: claude, Model: opus, Version: 4.6
- `gpt-5.2-codex` → Vendor: gpt, Model: 5.2, Variant: codex
- `gemini-3-pro-preview` → Vendor: gemini, Model: 3-pro, Variant: preview

### Key Observations
1. **Hyphen-separated**: All models use hyphens, NOT underscores or dots
2. **Version format**: Semantic versioning (e.g., 4.6, 5.2, 5.4)
3. **Variants**: Optional suffixes like `-fast`, `-1m`, `-codex`, `-mini`, `-preview`
4. **Case sensitivity**: All lowercase

## Setting Models via CLI

### Method 1: --model Flag (Recommended)
```bash
copilot -p "prompt here" --model claude-opus-4.6 --allow-all
copilot -p "prompt here" --model gpt-5.4 --allow-all
copilot -p "prompt here" --model claude-haiku-4.5 --allow-all
```

### Method 2: Configuration File
```bash
# Edit ~/.copilot/config.json
{
  "model": "claude-opus-4.6",
  "banner": "never",
  ...
}
```

### Method 3: Interactive Mode
```bash
copilot
# Then use commands to change model
```

## Actual vs. Expected Model Names

| Expected (article) | Actual (CLI) | Available? |
|---|---|---|
| `claude-3-5-haiku` | `claude-haiku-4.5` | ✗ Different name |
| `claude-3-sonnet` | `claude-sonnet-4.6` | ✓ Different version |
| `gpt-4` | `gpt-4.1` | ✓ Different version |
| `gpt-5.2` | `gpt-5.2` | ✓ Exact match |

## Default Model Behavior

When no model is specified:
1. Check `--model` flag
2. Check `~/.copilot/config.json` setting
3. Fall back to system default (was `claude-sonnet-4.6`, now `claude-opus-4.6`)

## Test Results Summary

| Test | Command | Result | Finding |
|------|---------|--------|---------|
| Valid model (configured) | `--model claude-opus-4.6` | Accepted | Uses configured default |
| Valid model (other) | `--model gpt-5.4` | Accepted | All listed models work |
| Invalid model | `--model gpt-4` | Error | Returns clear error message |
| Fake model | `--model xyz-999` | Accepted then fails | No pre-flight validation for unknown names |

## Recommendations for Wrapper

✓ **Use**: `claude-opus-4.6`, `claude-sonnet-4.6`, `gpt-5.4`, `claude-haiku-4.5`
✗ **Avoid**: `claude-3-5-haiku`, `gpt-4`, outdated article recommendations
✓ **Format**: Hyphens only, all lowercase, semantic version numbers
✓ **Flag**: Use `--model <name>` for explicit model specification

## Sources

- **Schema file**: `~/.copilot/pkg/universal/1.0.12/schemas/session-events.schema.json`
- **Config file**: `~/.copilot/config.json`
- **Logs**: `~/.copilot/logs/` (shows actual models used in sessions)
- **Help text**: `copilot --help` and `copilot -h`

