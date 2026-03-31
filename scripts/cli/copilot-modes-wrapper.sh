#!/usr/bin/env bash
# copilot-modes-wrapper.sh
#
# GitHub Copilot CLI Mode-Based Wrapper with Safety Controls
#
# Provides 4 escalating permission modes for interacting with Copilot:
#   c-ask   → Advisory only (Claude Haiku 4.5, read-only)
#   c-plan  → Planning & structuring (Claude Sonnet 4.6, read-only)
#   c-edit  → Safe file editing (Claude Sonnet 4.6, scoped write)
#   c-agent → Full autonomy (Claude Opus 4.6, approval gate)
#
# Convenience functions (auto-add -p flag):
#   cp-ask, cp-plan, cp-edit, cp-agent
#
# Features: Model selection, confirmation gates, deny-list guardrails, logging
#

set -euo pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================

# Configuration directory and log file
COPILOT_MODES_CONFIG_DIR="${HOME}/.config/copilot-modes"
COPILOT_MODES_LOG="${COPILOT_MODES_CONFIG_DIR}/invocations.log"

# Deny-list for all modes (safety guardrails)
declare -a DENY_LIST=(
  'shell(rm)'
  'shell(rm:*)'
  'shell(chmod)'
  'shell(chmod:*)'
  'shell(chown)'
  'shell(chown:*)'
  'shell(sudo)'
  'shell(sudo:*)'
  'shell(git push)'
  'shell(git push:*)'
  'write(*.env)'
  'write(**/.env*)'
)

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

# Initialize configuration directory and log file
_init_config() {
  if [[ ! -d "$COPILOT_MODES_CONFIG_DIR" ]]; then
    mkdir -p "$COPILOT_MODES_CONFIG_DIR"
  fi

  if [[ ! -f "$COPILOT_MODES_LOG" ]]; then
    touch "$COPILOT_MODES_LOG"
  fi
}

# Log invocation to file
# Args: mode, prompt (first 60 chars), result, model
_log_invocation() {
  local mode="$1"
  local prompt="$2"
  local result="$3"
  local model="$4"

  _init_config

  local timestamp
  timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  # Truncate prompt to first 60 chars
  local prompt_short="${prompt:0:60}"

  printf "%s | %s | %-60s | %s | %s\n" \
    "$timestamp" "$mode" "$prompt_short" "$result" "$model" \
    >> "$COPILOT_MODES_LOG"
}

# Validate copilot binary is installed
_check_copilot() {
  if ! command -v copilot &>/dev/null; then
    echo "❌ Error: copilot CLI not found" >&2
    echo "" >&2
    echo "Install via:" >&2
    echo "  brew install copilot" >&2
    echo "" >&2
    echo "Or download from: https://github.com/github/copilot-cli" >&2
    return 1
  fi
}

# Build deny-tool flags for copilot command
_build_deny_flags() {
  local flags=""
  for deny in "${DENY_LIST[@]}"; do
    flags="$flags --deny-tool '$deny'"
  done
  echo "$flags"
}

# Detect if input is large (>100K tokens, rough heuristic: 6 bytes per token)
_is_large_input() {
  local input_size

  # Get input from stdin if available
  if [[ ! -t 0 ]]; then
    input_size=$(cat | wc -c)
    if (( input_size > 600000 )); then  # ~100K tokens
      return 0  # True: large input
    fi
  fi

  return 1  # False: normal input
}

# Request confirmation for high-risk operations
_request_confirmation() {
  local mode="$1"
  local prompt="$2"
  local model="$3"

  echo "⚠️  High-risk operation requested:" >&2
  echo "  Mode: $mode" >&2
  echo "  Prompt: $prompt" >&2
  echo "  Model: $model" >&2
  echo "" >&2
  read -p "Proceed? (type 'yes' to continue): " -r confirm

  if [[ "$confirm" != "yes" ]]; then
    _log_invocation "$mode" "$prompt" "cancelled" "$model"
    echo "Operation cancelled." >&2
    return 1
  fi

  return 0
}

# Check if prompt triggers high-risk keywords
_requires_confirmation() {
  local prompt="$1"

  # Keywords that require confirmation
  if [[ "$prompt" =~ (delete|remove|chmod|chown|sudo|push|deploy|production|destroy|drop|truncate) ]]; then
    return 0  # True: requires confirmation
  fi

  return 1  # False: no confirmation needed
}

# ============================================================================
# MODE FUNCTIONS (Layer 1: Thin Wrappers)
# ============================================================================

# MODE A: c-ask
# Advisory only, fast, read-only analysis
# Model: Claude Haiku 4.5
# Capabilities: Read stdin, analyze, output analysis
# Safety: Deny shell + write
c-ask() {
  _check_copilot || return 1

  local prompt=""
  local model="claude-haiku-4.5"
  local input_text=""
  local explicit_model=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -p|--prompt)
        prompt="$2"
        shift 2
        ;;
      --model)
        model="$2"
        explicit_model=true
        shift 2
        ;;
      *)
        echo "Error: Unknown option '$1' for c-ask" >&2
        echo "Usage: c-ask -p|--prompt <prompt> [--model <model>]" >&2
        return 1
        ;;
    esac
  done

  # Validate prompt provided
  if [[ -z "$prompt" ]]; then
    echo "Error: -p/--prompt flag required" >&2
    echo "Usage: c-ask -p 'your question here'" >&2
    return 1
  fi

  # Read full input for size check
  if [[ ! -t 0 ]]; then
    input_text=$(cat)
  fi

  # Auto-select Gemini for large context (unless explicitly specified)
  if [[ "$explicit_model" == false && ${#input_text} -gt 600000 ]]; then
    model="gemini-3.1-pro"
  fi

  # Log and execute
  _log_invocation "c-ask" "$prompt" "started" "$model"

  # Execute copilot in ask mode
  if [[ -n "$input_text" ]]; then
    echo "$input_text" | COPILOT_MODEL="$model" copilot \
      -p "$prompt" \
      --deny-tool 'shell' \
      --deny-tool 'write' \
      2>/dev/null
  else
    COPILOT_MODEL="$model" copilot \
      -p "$prompt" \
      --deny-tool 'shell' \
      --deny-tool 'write' \
      2>/dev/null
  fi

  local exit_code=$?
  if [[ $exit_code -eq 0 ]]; then
    _log_invocation "c-ask" "$prompt" "success" "$model"
  else
    _log_invocation "c-ask" "$prompt" "error" "$model"
  fi

  return $exit_code
}

# MODE B: c-plan
# Planning & structuring, balanced reasoning
# Model: Claude Sonnet 4.6
# Capabilities: Read input, generate plan/outline, structured text
# Safety: Deny shell + write, ask before external requests
c-plan() {
  _check_copilot || return 1

  local prompt=""
  local model="claude-sonnet-4.6"
  local input_text=""
  local explicit_model=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -p|--prompt)
        prompt="$2"
        shift 2
        ;;
      --model)
        model="$2"
        explicit_model=true
        shift 2
        ;;
      *)
        echo "Error: Unknown option '$1' for c-plan" >&2
        echo "Usage: c-plan -p|--prompt <prompt> [--model <model>]" >&2
        return 1
        ;;
    esac
  done

  # Validate prompt provided
  if [[ -z "$prompt" ]]; then
    echo "Error: -p/--prompt flag required" >&2
    echo "Usage: c-plan -p 'your question here'" >&2
    return 1
  fi

  # Read full input for size check
  if [[ ! -t 0 ]]; then
    input_text=$(cat)
  fi

  # Auto-select Gemini for large context (unless explicitly specified)
  if [[ "$explicit_model" == false && ${#input_text} -gt 600000 ]]; then
    model="gemini-3.1-pro"
  fi

  # Log and execute
  _log_invocation "c-plan" "$prompt" "started" "$model"

  # Execute copilot in plan mode
  if [[ -n "$input_text" ]]; then
    echo "$input_text" | COPILOT_MODEL="$model" copilot \
      -p "$prompt" \
      --deny-tool 'shell' \
      --deny-tool 'write' \
      2>/dev/null
  else
    COPILOT_MODEL="$model" copilot \
      -p "$prompt" \
      --deny-tool 'shell' \
      --deny-tool 'write' \
      2>/dev/null
  fi

  local exit_code=$?
  if [[ $exit_code -eq 0 ]]; then
    _log_invocation "c-plan" "$prompt" "success" "$model"
  else
    _log_invocation "c-plan" "$prompt" "error" "$model"
  fi

  return $exit_code
}

# MODE C: c-edit
# Safe file editing with declared scope
# Model: Claude Sonnet 4.6
# Capabilities: Modify files within declared scope, no shell/external
# Safety: Allow write within declared paths, deny shell + external
c-edit() {
  _check_copilot || return 1

  local prompt=""
  local scope=""
  local model="claude-sonnet-4.6"
  local input_text=""
  local explicit_model=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -p|--prompt)
        prompt="$2"
        shift 2
        ;;
      --scope)
        scope="$2"
        shift 2
        ;;
      --model)
        model="$2"
        explicit_model=true
        shift 2
        ;;
      *)
        echo "Error: Unknown option '$1' for c-edit" >&2
        echo "Usage: c-edit -p|--prompt <prompt> --scope <path> [--model <model>]" >&2
        return 1
        ;;
    esac
  done

  # Validate required flags
  if [[ -z "$prompt" ]]; then
    echo "Error: -p/--prompt flag required" >&2
    echo "Usage: c-edit -p 'edit description' --scope src/" >&2
    return 1
  fi

  if [[ -z "$scope" ]]; then
    echo "Error: --scope flag required (safety control)" >&2
    echo "Usage: c-edit -p 'edit description' --scope src/" >&2
    return 1
  fi

  # Validate scope path exists
  if [[ ! -e "$scope" ]]; then
    echo "Error: Scope path does not exist: $scope" >&2
    return 1
  fi

  # Read full input for size check
  if [[ ! -t 0 ]]; then
    input_text=$(cat)
  fi

  # Auto-select Gemini for large context (unless explicitly specified)
  if [[ "$explicit_model" == false && ${#input_text} -gt 600000 ]]; then
    model="gemini-3.1-pro"
  fi

  # Log and execute
  _log_invocation "c-edit" "$prompt" "started" "$model"

  # Execute copilot in edit mode with scope
  if [[ -n "$input_text" ]]; then
    echo "$input_text" | COPILOT_MODEL="$model" copilot \
      -p "$prompt" \
      --deny-tool 'shell' \
      --scope "$scope" \
      2>/dev/null
  else
    COPILOT_MODEL="$model" copilot \
      -p "$prompt" \
      --deny-tool 'shell' \
      --scope "$scope" \
      2>/dev/null
  fi

  local exit_code=$?
  if [[ $exit_code -eq 0 ]]; then
    _log_invocation "c-edit" "$prompt" "success" "$model"
  else
    _log_invocation "c-edit" "$prompt" "error" "$model"
  fi

  return $exit_code
}

# MODE D: c-agent
# Full autonomy with deny-list guardrails and approval gates
# Model: Claude Opus 4.6 (fallback to Sonnet if unavailable)
# Capabilities: All tools enabled with deny-list restrictions
# Safety: Deny dangerous operations only, require confirmation before execution
c-agent() {
  _check_copilot || return 1

  local prompt=""
  local model="claude-opus-4.6"
  local input_text=""
  local explicit_model=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -p|--prompt)
        prompt="$2"
        shift 2
        ;;
      --model)
        model="$2"
        explicit_model=true
        shift 2
        ;;
      *)
        echo "Error: Unknown option '$1' for c-agent" >&2
        echo "Usage: c-agent -p|--prompt <prompt> [--model <model>]" >&2
        return 1
        ;;
    esac
  done

  # Validate prompt provided
  if [[ -z "$prompt" ]]; then
    echo "Error: -p/--prompt flag required" >&2
    echo "Usage: c-agent -p 'your task here'" >&2
    return 1
  fi

  # Read full input for size check
  if [[ ! -t 0 ]]; then
    input_text=$(cat)
  fi

  # Auto-select Gemini for large context (unless explicitly specified)
  if [[ "$explicit_model" == false && ${#input_text} -gt 600000 ]]; then
    model="gemini-3.1-pro"
  fi

  # Agent mode requires confirmation (all tasks)
  if ! _request_confirmation "c-agent" "$prompt" "$model"; then
    return 1
  fi

  # Additional confirmation if prompt contains high-risk keywords
  if _requires_confirmation "$prompt"; then
    if ! _request_confirmation "c-agent" "$prompt [HIGH-RISK]" "$model"; then
      return 1
    fi
  fi

  # Log and execute
  _log_invocation "c-agent" "$prompt" "started" "$model"

  # Build deny flags for all modes
  local deny_flags=""
  for deny in "${DENY_LIST[@]}"; do
    deny_flags="$deny_flags --deny-tool '$deny'"
  done

  # Execute copilot in agent mode with deny-list
  if [[ -n "$input_text" ]]; then
    echo "$input_text" | COPILOT_MODEL="$model" copilot \
      -p "$prompt" \
      $deny_flags \
      2>/dev/null
  else
    COPILOT_MODEL="$model" copilot \
      -p "$prompt" \
      $deny_flags \
      2>/dev/null
  fi

  local exit_code=$?
  if [[ $exit_code -eq 0 ]]; then
    _log_invocation "c-agent" "$prompt" "success" "$model"
  else
    _log_invocation "c-agent" "$prompt" "error" "$model"
  fi

  return $exit_code
}

# ============================================================================
# CONVENIENCE FUNCTIONS (Layer 2: Auto-add -p flag)
# ============================================================================

# Convenience wrapper: auto-add -p flag to c-ask
cp-ask() {
  c-ask -p "$*"
}

# Convenience wrapper: auto-add -p flag to c-plan
cp-plan() {
  c-plan -p "$*"
}

# Convenience wrapper: auto-add -p flag to c-edit
cp-edit() {
  # Note: requires --scope, so this is less safe; users should use c-edit -p directly
  echo "Error: cp-edit requires explicit --scope flag for safety" >&2
  echo "Use: c-edit -p 'description' --scope <path>" >&2
  return 1
}

# Convenience wrapper: auto-add -p flag to c-agent
cp-agent() {
  c-agent -p "$*"
}

# ============================================================================
# UTILITY FUNCTION: Show Configured Modes
# ============================================================================

c-modes() {
  echo "📋 Configured Copilot Modes:"
  echo ""
  echo "THIN WRAPPERS (explicit -p flag):"
  printf "  %-12s %s\n" "c-ask -p" "Claude Haiku 4.5 (advisory, read-only)"
  printf "  %-12s %s\n" "c-plan -p" "Claude Sonnet 4.6 (planning, read-only)"
  printf "  %-12s %s\n" "c-edit -p" "Claude Sonnet 4.6 (editing, scoped write)"
  printf "  %-12s %s\n" "c-agent -p" "Claude Opus 4.6 (autonomous, approval gate)"
  echo ""
  echo "CONVENIENCE WRAPPERS (auto -p):"
  printf "  %-12s %s\n" "cp-ask" "Shorthand for c-ask -p"
  printf "  %-12s %s\n" "cp-plan" "Shorthand for c-plan -p"
  printf "  %-12s %s\n" "cp-agent" "Shorthand for c-agent -p"
  echo ""
  echo "SPECIAL:"
  printf "  %-12s %s\n" "c-modes" "This help message"
  printf "  %-12s %s\n" "c-log" "Show recent invocations"
  echo ""
  echo "LARGE CONTEXT HANDLING:"
  echo "  • Input > 100K tokens auto-selects Gemini 3.1 Pro"
  echo "  • Override: --model <gemini-3.1-pro|claude-sonnet-4.6|claude-haiku-4.5>"
  echo ""
  echo "EXAMPLES:"
  echo "  • cp-ask 'summarize this error log' < error.log"
  echo "  • cp-plan 'create implementation plan for auth module'"
  echo "  • c-edit -p 'add docstrings to functions' --scope src/"
  echo "  • cp-agent 'run test suite and report results'"
  echo ""
}

# Show recent invocations from log
c-log() {
  _init_config

  if [[ ! -f "$COPILOT_MODES_LOG" ]] || [[ ! -s "$COPILOT_MODES_LOG" ]]; then
    echo "No invocations logged yet."
    return 0
  fi

  echo "📜 Recent Copilot Mode Invocations (last 10):"
  echo ""
  printf "%-20s %-8s %-60s %-10s %s\n" \
    "TIMESTAMP" "MODE" "PROMPT" "RESULT" "MODEL"
  echo "---"
  tail -n 10 "$COPILOT_MODES_LOG" | while IFS='|' read -r timestamp mode prompt result model; do
    # Trim whitespace
    timestamp=$(echo "$timestamp" | xargs)
    mode=$(echo "$mode" | xargs)
    prompt=$(echo "$prompt" | xargs)
    result=$(echo "$result" | xargs)
    model=$(echo "$model" | xargs)

    printf "%-20s %-8s %-60s %-10s %s\n" \
      "$timestamp" "$mode" "$prompt" "$result" "$model"
  done
  echo ""
}

# ============================================================================
# MAIN: Export functions for sourcing
# ============================================================================

# Ensure functions are exported when sourced
export -f c-ask c-plan c-edit c-agent
export -f cp-ask cp-plan cp-edit cp-agent
export -f c-modes c-log
export -f _init_config _log_invocation _check_copilot _request_confirmation _requires_confirmation
