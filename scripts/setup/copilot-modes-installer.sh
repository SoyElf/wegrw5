#!/usr/bin/env bash
# copilot-modes-installer.sh
#
# GitHub Copilot Modes Installation Script
#
# Creates configuration directory, installs wrapper, and provides
# setup instructions for adding to shell profile.
#
# Idempotent: Safe to re-run. Will not overwrite existing configs
# unless explicitly requested.
#

set -euo pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================

CONFIG_DIR="${HOME}/.config/copilot-modes"
WRAPPER_DEST="${CONFIG_DIR}/copilot-modes.zsh"
LOG_FILE="${CONFIG_DIR}/invocations.log"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

# ============================================================================
# FUNCTIONS
# ============================================================================

# Print colored output
print_success() {
  echo -e "${GREEN}✔${RESET} $*"
}

print_info() {
  echo -e "${YELLOW}ℹ${RESET} $*"
}

print_error() {
  echo -e "${RED}✘${RESET} $*" >&2
}

# Check if copilot CLI is installed
check_copilot_installed() {
  if ! command -v copilot &>/dev/null; then
    print_error "copilot CLI not found"
    echo ""
    echo "Install copilot CLI first:"
    echo "  brew install copilot"
    echo ""
    echo "Or download from: https://github.com/github/copilot-cli"
    return 1
  fi

  return 0
}

# Get the wrapper script location
get_wrapper_script() {
  # Try to find copilot-modes-wrapper.sh in common locations
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  if [[ -f "${script_dir}/copilot-modes-wrapper.sh" ]]; then
    echo "${script_dir}/copilot-modes-wrapper.sh"
  elif [[ -f "./copilot-modes-wrapper.sh" ]]; then
    echo "$(pwd)/copilot-modes-wrapper.sh"
  else
    print_error "Could not find copilot-modes-wrapper.sh"
    echo ""
    echo "Make sure to run this installer from the directory containing:"
    echo "  - copilot-modes-wrapper.sh"
    echo "  - copilot-modes-installer.sh"
    return 1
  fi
}

# Create configuration directory
create_config_dir() {
  if [[ ! -d "$CONFIG_DIR" ]]; then
    mkdir -p "$CONFIG_DIR"
    print_success "Created config directory: $CONFIG_DIR"
  else
    print_info "Config directory already exists: $CONFIG_DIR"
  fi
}

# Install wrapper script
install_wrapper() {
  local wrapper_source
  wrapper_source=$(get_wrapper_script) || return 1

  if [[ ! -f "$wrapper_source" ]]; then
    print_error "Wrapper script not found: $wrapper_source"
    return 1
  fi

  # Convert to zsh format by removing bash-isms if necessary
  # For now, just copy as-is since bash functions work in zsh too
  cp "$wrapper_source" "$WRAPPER_DEST"
  chmod +x "$WRAPPER_DEST"

  print_success "Installed wrapper script: $WRAPPER_DEST"
}

# Create empty log file
create_log_file() {
  if [[ ! -f "$LOG_FILE" ]]; then
    touch "$LOG_FILE"
    print_success "Created log file: $LOG_FILE"
  else
    print_info "Log file already exists: $LOG_FILE"
  fi
}

# Get current shell
get_current_shell() {
  basename "$SHELL"
}

# Print installation summary and next steps
print_summary() {
  local shell_name
  shell_name=$(get_current_shell)

  echo ""
  echo "════════════════════════════════════════════════════════════════"
  echo "✔ Copilot Modes Installation Complete"
  echo "════════════════════════════════════════════════════════════════"
  echo ""
  echo "📁 Files created:"
  echo "  • $WRAPPER_DEST"
  echo "  • $LOG_FILE"
  echo ""
  echo "📝 Next Step: Add to your shell profile"
  echo ""

  if [[ "$shell_name" == "zsh" ]]; then
    echo "Add this line to your ~/.zshrc:"
    echo ""
    echo "  source \"$WRAPPER_DEST\""
    echo ""
    echo "Then reload:"
    echo "  source ~/.zshrc"
  elif [[ "$shell_name" == "bash" ]]; then
    echo "Add this line to your ~/.bashrc:"
    echo ""
    echo "  source \"$WRAPPER_DEST\""
    echo ""
    echo "Then reload:"
    echo "  source ~/.bashrc"
  else
    echo "Add this line to your shell profile (~/${shell_name}rc):"
    echo ""
    echo "  source \"$WRAPPER_DEST\""
    echo ""
    echo "Then reload your shell configuration."
  fi

  echo ""
  echo "🧪 Test Installation:"
  echo "  After sourcing, try these commands:"
  echo ""
  echo "  • c-modes          # Show available modes"
  echo "  • cp-ask 'hello'   # Quick test (ask mode)"
  echo "  • c-log            # View recent invocations"
  echo ""
  echo "⚠️  Important Security Notes:"
  echo "  • All modifications are logged to: $LOG_FILE"
  echo "  • High-risk operations require confirmation"
  echo "  • Large inputs (>100K tokens) auto-use Gemini 3.1 Pro"
  echo "  • Check c-modes for full documentation"
  echo ""
  echo "📚 For more information:"
  echo "  • Run: c-modes"
  echo "  • Read: docs/guides/INSTALLATION.md"
  echo "  • Examples: docs/EXAMPLES.md"
  echo ""
  echo "════════════════════════════════════════════════════════════════"
  echo ""
}

# ============================================================================
# MAIN INSTALLATION FLOW
# ============================================================================

main() {
  echo ""
  echo "🚀 Copilot Modes Installation Script"
  echo ""

  # Step 1: Check copilot CLI installed
  print_info "Checking for copilot CLI..."
  if ! check_copilot_installed; then
    return 1
  fi
  print_success "copilot CLI found: $(command -v copilot)"

  # Step 2: Create config directory
  print_info "Setting up configuration directory..."
  create_config_dir || return 1

  # Step 3: Install wrapper script
  print_info "Installing wrapper script..."
  install_wrapper || return 1

  # Step 4: Create log file
  print_info "Setting up logging..."
  create_log_file || return 1

  # Step 5: Print summary
  print_summary

  return 0
}

# Run main function
main "$@"
