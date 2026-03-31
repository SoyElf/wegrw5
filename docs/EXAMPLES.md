# Copilot Modes Usage Examples

Real-world examples for each Copilot mode, from simple to complex workflows.

## Quick Start

After installation, try these to verify everything works:

```bash
# Show what modes are available
c-modes

# Quick test (ask mode)
cp-ask "what's the difference between REST and GraphQL?"

# View recent invocations
c-log
```

---

## Mode a: `c-ask` (Advisory Only)

**Use for:** Learning, analysis, explanation. Read-only, no modifications.
**Model:** Claude Haiku 4.5 (fast, cost-effective)

### Example 1: Analyze an Error

```bash
# Pipe an error directly
./script.sh 2>&1 | cp-ask "what went wrong and how do I fix it?"

# Or with file
c-ask -p "analyze this error and suggest fixes" < error.log
```

### Example 2: Code Explanation

```bash
# Understand what code does
c-ask -p "explain what this function does and how it works" src/auth.ts

# Or pipe code through stdin
cat src/utils.rs | cp-ask "is there any security issue in this code?"
```

### Example 3: Log Analysis

```bash
# Summarize application logs
tail -n 100 app.log | cp-ask "what are the main error patterns in these logs?"

# Extract insights from structured logs
cat metrics.json | cp-ask "what metrics show concerning trends?"
```

### Example 4: Diff Review Quick Analysis

```bash
# Get quick analysis of changes
git diff origin/main | cp-ask "summarize the changes in plain English"

# Or specific file
git diff src/main.rs | cp-ask "are there any security concerns in these changes?"
```

### Example 5: Test Failure Diagnosis

```bash
# Understand test failures
npm test 2>&1 | cp-ask "why are these tests failing?"

# Or for Python
pytest --tb=short 2>&1 | cp-ask "what went wrong in these test failures?"
```

### Example 6: Documentation Review

```bash
# Clarify existing documentation
c-ask -p "summarize this API documentation in 3 bullet points" < docs/api.md

# Or explain complex config
cat config.yaml | cp-ask "what does this configuration do?"
```

---

## Mode b: `c-plan` (Planning & Structuring)

**Use for:** Structured planning, roadmapping, decomposition.
**Model:** Claude Sonnet 4.6 (balanced reasoning + speed)

### Example 1: Refactoring Plan

```bash
# Plan a refactoring effort
c-plan -p "create a step-by-step plan to refactor this authentication module" src/auth/

# Or from design doc
c-plan -p "break down this feature request into implementation tasks" < feature-spec.md
```

### Example 2: Architecture Decision

```bash
# Plan system architecture changes
git diff architecture/ | cp-plan "outline the approach to implement these changes"

# Or review a proposal
c-plan -p "what's a phased approach to migrate from REST to GraphQL?" < proposal.md
```

### Example 3: Project Scoping

```bash
# Break down a large task
cp-plan "create a detailed implementation plan for adding user authentication"

# From existing code analysis
c-plan -p "how would you refactor this monolith into microservices?" < codebase-overview.md
```

### Example 4: Risk Assessment

```bash
# Assess risks of changes
git diff | cp-plan "what are the risks of these changes and how to mitigate them?"

# Or review deployment plan
c-plan -p "what could go wrong in this deployment plan and how to reduce risks?" < deployment.md
```

### Example 5: Learning Roadmap

```bash
# Learn a new technology
cp-plan "create a learning roadmap for mastering Kubernetes in 3 months"

# Or for team upskilling
cp-plan "build a training plan for our team to become proficient with Rust"
```

### Example 6: Content Outline

```bash
# Plan a blog post or documentation
cp-plan "outline a comprehensive guide to API design best practices"

# Or documentation restructuring
c-plan -p "how would you reorganize this documentation for better navigation?" < docs/index.md
```

---

## Mode c: `c-edit` (Safe File Editing)

**Use for:** Code generation, documentation, safe file modifications.
**Model:** Claude Sonnet 4.6 (balanced)
**Safety:** Requires explicit `--scope` path

### Example 1: Add Documentation

```bash
# Add docstrings to Python functions
c-edit -p "add comprehensive docstrings to all functions following numpy style" --scope src/

# Or for JavaScript
c-edit -p "add JSDoc comments to all exported functions" --scope src/lib/
```

### Example 2: Code Formatting

```bash
# Format code consistently
c-edit -p "ensure consistent formatting and style across all files" --scope src/

# Or specific file type
c-edit -p "format all SQL migrations to follow our style guide" --scope migrations/
```

### Example 3: Generate Tests

```bash
# Generate test stubs
c-edit -p "generate comprehensive unit tests for these functions" --scope src/utils/

# Or integration tests
c-edit -p "create integration tests for the API endpoints" --scope tests/
```

### Example 4: Update Configuration

```bash
# Update config based on new requirements
c-edit -p "update the configuration to add support for multiple environments" --scope config/

# Or documentation
c-edit -p "update README with installation, usage, and troubleshooting sections" --scope ./
```

### Example 5: Boilerplate Generation

```bash
# Generate new component/module structure
# Create files in specific directory
c-edit -p "generate boilerplate for a new feature module with proper structure" --scope src/features/

# Or service template
c-edit -p "create a complete service boilerplate with error handling" --scope src/services/
```

### Example 6: Refactor with Scope Safety

```bash
# Safe refactoring within declared scope
c-edit -p "refactor to use async/await instead of promises" --scope src/api/

# Or module-specific changes
c-edit -p "update all functions to use TypeScript strict types" --scope src/utils/
```

---

## Mode d: `c-agent` (Full Autonomy)

**Use for:** Complex multi-step tasks, autonomous execution.
**Model:** Claude Opus 4.6 (most capable)
**Safety:** Requires confirmation gate; all high-risk operations blocked

### Example 1: Test Suite Automation

```bash
# Run and report on tests
c-agent -p "run the test suite, identify failing tests, and summarize what's broken"

# Or with fixes
c-agent -p "run tests, identify failures, suggest quick fixes, and implement them"
```

### Example 2: Code Quality Analysis

```bash
# Comprehensive code review
c-agent -p "analyze the codebase for security issues, performance problems, and best practice violations"

# Or for specific module
c-agent -p "perform a complete code quality review of the authentication module and suggest improvements"
```

### Example 3: Automated Dependency Updates

```bash
# Check and update dependencies
c-agent -p "check for outdated dependencies, test compatibility, and safely update them"

# Or with reporting
c-agent -p "audit dependencies for security vulnerabilities and create a patch plan"
```

### Example 4: Documentation Generation

```bash
# Generate comprehensive documentation
c-agent -p "analyze the codebase and generate complete API documentation in Markdown"

# Or architecture docs
c-agent -p "create architecture documentation based on the current codebase structure"
```

### Example 5: Multi-File Refactoring

```bash
# Complex refactoring across modules
c-agent -p "refactor error handling to use a consistent pattern across all modules"

# Or feature addition
c-agent -p "add comprehensive logging to all critical paths in the application"
```

### Example 6: Build and Deploy

```bash
# Automated build analysis
c-agent -p "analyze build failures, identify root causes, and propose fixes"

# Or deployment verification
c-agent -p "verify the deployment is correct, check for common issues, and report status"
```

---

## Advanced Patterns

### Pattern 1: Analysis → Planning → Implementation

Chain modes to go from analysis to plan to execution:

```bash
# Step 1: Analyze the current state
git log --oneline -10 | cp-ask "what's been the main focus of development recently?"

# Step 2: Plan improvements based on analysis
# (Take output from step 1 and pipe to plan, or copy into plan prompt)
cp-plan "based on recent changes, what's the next priority for the codebase?"

# Step 3: Get implementation strategy
# (Use plan output)
cp-agent "outline the implementation approach for the planned improvements"
```

### Pattern 2: Large Codebase Analysis

For analyzing large codebases (>100K tokens):

```bash
# Automatic Gemini 3.1 Pro will be selected for large inputs
c-ask -p "analyze this entire codebase for architectural patterns" < codebase.dump

# Or explicitly specify
c-ask -p "summarize this large dataset" --model gemini-3.1-pro < huge-log-file.txt

# Still works in planning mode
c-plan -p "create architecture plan for this codebase" --model gemini-3.1-pro < codebase.dump
```

### Pattern 3: Error to Fix Workflow

Complete workflow from error discovery to solution:

```bash
# 1. Capture the error
./deploy.sh > deploy.log 2>&1 || true

# 2. Analyze what went wrong
cp-ask "what went wrong in this deployment?" < deploy.log

# 3. Plan the fix
cp-plan "create a step-by-step fix plan for this deployment issue"

# 4. Let agent implement fixes (with approval)
c-agent -p "implement the necessary fixes to resolve the deployment issue"
```

### Pattern 4: Code Review Workflow

Structured code review:

```bash
# 1. Get quick analysis
git diff feature-branch | cp-ask "does this look reasonable at first glance?"

# 2. Deeper review
git diff feature-branch | cp-plan "create a comprehensive code review checklist for these changes"

# 3. Automated checks
c-agent -p "run full test suite, linting, type checking, and security scans on this branch"
```

### Pattern 5: Documentation Workflow

Create comprehensive documentation:

```bash
# 1. Understand the code
c-ask -p "summarize what this module does" < src/module.rs

# 2. Plan documentation structure
cp-plan "create an outline for comprehensive documentation of this module"

# 3. Generate the actual documentation
c-edit -p "generate complete documentation with examples and usage patterns" --scope docs/
```

### Pattern 6: Learning Spiral

Use modes for progressive learning:

```bash
# 1. Ask for overview
cp-ask "what is machine learning?"

# 2. Plan learning path
cp-plan "create a 12-week learning roadmap for getting proficient in machine learning"

# 3. Generate resources and examples
c-edit -p "create example code for fundamental ML algorithms" --scope examples/

# 4. Full implementation
c-agent -p "implement a complete ML pipeline example with data loading, training, and evaluation"
```

---

## Safety Examples

### Example 1: Confirmation Gates

High-risk operations require confirmation:

```bash
# This will ask for confirmation (contains 'delete')
$ cp-agent "clean up and delete old log files"
⚠️  High-risk operation requested:
  Mode: c-agent
  Prompt: clean up and delete old log files
  Model: claude-opus-4.6

Proceed? (type 'yes' to continue): yes
# ... execution proceeds

# This was cancelled
$ cp-agent "remove old backups"
⚠️  High-risk operation requested:
  ...
Proceed? (type 'yes' to continue): no
Operation cancelled.
```

### Example 2: Scoped Editing

`c-edit` requires explicit scope for safety:

```bash
# ✅ Safe: explicit scope
c-edit -p "improve documentation" --scope docs/

# ✅ Safe: narrow scope
c-edit -p "add type annotations" --scope src/utils/

# ❌ Won't work: no scope
c-edit -p "refactor codebase"  # Error: --scope required

# ❌ Won't work: scope doesn't exist
c-edit -p "update code" --scope non-existent/  # Error: path missing
```

### Example 3: Deny-List in Action

Dangerous operations are always blocked:

```bash
# These will be blocked by deny-list:

# Blocked: file deletion
c-agent -p "remove all .log files from the system"
# Error: shell(rm) denied

# Blocked: permission changes
c-agent -p "chmod all scripts to 755"
# Error: shell(chmod) denied

# Blocked: privilege escalation
c-agent -p "run tests with sudo"
# Error: shell(sudo) denied
```

---

## Piping Examples

Use Unix pipes to chain operations:

```bash
# Multiple analysis steps
ls -la | cp-ask "what does this directory contain?" | cp-plan "what should I do with these files?"

# Code through pipeline
git show HEAD:src/main.rs | cp-ask "what changed?" | cp-plan "is refactoring needed?"

# Error analysis chain
npm test 2>&1 | cp-ask "why did tests fail?" | cp-plan "what's the quickest fix?"

# Log analysis chain
tail -100 app.log | cp-ask "what errors occurred?" | cp-plan "what should we fix first?"
```

---

## Integration Examples

### With Git Workflow

```bash
# Review PR before merging
git diff origin/main | cp-ask "what are these changes doing?"
git diff origin/main | cp-plan "assess the scope and risk of these changes"

# Plan branch work
cp-plan "break down this branch into logical commits"

# Analyze commits
git log --oneline -10 | cp-ask "summarize recent work"
```

### With Test Workflow

```bash
# Quick test failure analysis
npm test 2>&1 | cp-ask "why are tests failing?"

# Comprehensive test review
c-agent -p "run full test suite with coverage analysis and report on gaps"

# Flaky test investigation
npm test 2>&1 | cp-ask "why might these tests be flaky?"
```

### With Build System

```bash
# Build failure diagnosis
./build.sh 2>&1 | cp-ask "why did the build fail?"

# Build optimization
cp-plan "how could we speed up this build process?"

# Automated build fixes
c-agent -p "diagnose and fix build failures"
```

### With Documentation

```bash
# Quick docs clarification
c-ask -p "explain this in simpler terms" < docs/architecture.md

# Plan docs restructuring
cp-plan "how would you reorganize this documentation for better user experience?"

# Generate missing docs
c-edit -p "generate missing API documentation" --scope docs/api/
```

---

## Tips and Best Practices

### Use Ask Mode for Quick Answers
- Fast (Haiku model), cheap
- Great for understanding, learning, analysis
- Pipe anything through it: logs, code, diffs, errors

### Use Plan Mode to Think Through Complex Tasks
- Structured output, clear reasoning
- Use before implementing
- Great for risk assessment and roadmapping

### Use Edit Mode for Code Generation
- Only modifies code within scope
- Safe for adding docstrings, tests, boilerplate
- Always include `--scope` for safety

### Use Agent Mode with Caution
- Most powerful, requires confirmation
- Best for complex multi-step tasks
- Don't use for simple things (ask/plan are faster)
- Always review confirmation prompts carefully

### Monitor Your Usage
- Run `c-log` periodically to see what you're using
- Share logs to team for audit trails
- Use in conjunction with Hindsight for institutional memory

### Leverage Large Context
- Automatically gets Gemini for >100K tokens
- Great for analyzing entire codebases, large datasets
- Explicit `--model` flag overrides auto-selection

---

## Troubleshooting Examples

### "Command not found: c-ask"

**Problem:** Wrapper not loaded in current shell
**Solution:** Add to `.zshrc`/`.bashrc` and reload
```bash
source "$HOME/.config/copilot-modes/copilot-modes.zsh"
```

### Slow Performance

**Problem:** Taking a long time
**Cause:** Large input or complex task
**Solution:**
- Split input into smaller chunks
- Use appropriate mode (ask for quick answers, agent for complex)
- Check network connection

### "Scoped path does not exist"

**Problem:** `c-edit` error when path doesn't exist
**Solution:** Ensure path exists before running
```bash
# Create if needed
mkdir -p src/features/

# Then use
c-edit -p "generate new feature module" --scope src/features/
```

---

**Last Updated:** March 30, 2026
