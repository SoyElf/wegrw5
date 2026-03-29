# Tool Composition and Design

## Overview

Tool composition is the strategic combining of multiple atomic tools to accomplish complex tasks reliably. Rather than creating single complex tools, successful agent design composes atomic operations into well-ordered workflows with explicit verification steps.

**Core Principle**: Well-composed tool chains are more reliable than single complex tools; compose atomic operations rather than attempting monolithic solutions.

---

## Tool Composition Pattern

The fundamental pattern for reliable tool composition:

```
1. Search/Analyze (gather information)
   ↓
2. Decide (determine what changes are needed)
   ↓
3. Modify (apply changes with atomic tools)
   ↓
4. Verify (validate outcomes)
   ↓
5. Report (communicate results)
```

Each step should be explicit in agent instructions.

---

## Atomic Tool Operations

### Search and Analysis Tools

- **file_search**: Find files by glob pattern
- **semantic_search**: Search codebase semantically (understand relationships, not just text)
- **grep_search**: Text/regex search within files
- **file_list**: List directory contents

**Best Practice**: Always search before modifying. Don't assume file locations or structure.

### File Operations

- **create_file**: Create new files with content
- **replace_string_in_file**: Edit specific sections of existing files
- **multi_replace**: Batch edits to multiple files in one operation
- **read_file**: Get current file contents before modifying

**Best Practice**: Read file context before making targeted replacements. This ensures edits are surgically precise.

### Verification Tools

- **get_errors**: Retrieve linting, type-checking, and compilation errors
- **get_changed_files**: View git diffs to see exactly what changed

**Critical Practice**: Always verify changes after modifications. Check for syntax errors, type issues, and unexpected side effects.

### Context Tools

- **get_changed_files**: Understand what git modifications occurred
- **semantic_search**: Find related code that might be affected by changes

---

## Composition Strategies

### Strategy 1: Search-Then-Modify Pattern

**When to use**: Making targeted changes to existing code/docs

```
1. semantic_search for relevant files/sections
2. read_file to get full context
3. replace_string_in_file with precise old_string/new_string
4. get_errors to verify no syntax issues
5. Report changes made
```

**Why it works**: Reading first eliminates guess-work about indentation, whitespace, and context.

### Strategy 2: Create-Then-Verify Pattern

**When to use**: Creating new files or adding substantial content

```
1. Gather requirements/context
2. create_file with complete, well-structured content
3. get_errors to check syntax/type correctness
4. Report file created
```

**Best Practice**: Generate complete files rather than creating empty files then modifying them. This reduces round-trips.

### Strategy 3: Batch Modification Pattern

**When to use**: Making related changes across multiple files

```
1. file_search to identify all files needing changes
2. Prepare multi_replace with all modifications
3. Execute multi_replace (all changes in single operation)
4. get_errors to verify
5. Report changes
```

**Advantage**: `multi_replace` eliminates file coordination issues; all changes succeed or all fail together.

### Strategy 4: Read-Modify-Verify Pattern for Complex Changes

**When to use**: Complex edits where side effects are possible

```
1. read_file (full context + surrounding code)
2. Analyze what could break if changed
3. replace_string_in_file with sufficient context (3-5 lines before/after)
4. get_errors
5. semantic_search for related code that might be affected
6. Report with explicit acknowledgment of verified behavior
```

---

## Failure Prevention

### Include Verification Steps

Always verify tool operations. Don't assume success. Example:

```
✓ Correct: "I'll update the function, then check for syntax errors"
✗ Wrong: "I'll update the function" (no verification)
```

### Handle Partial Failures Gracefully

If some changes succeed but some fail:
- Report which operations succeeded
- Report which failed and why
- Suggest rollback or manual remediation
- Don't continue assuming everything worked

### Sufficient Context in Replacements

Include 3-5 lines before/after target text to ensure precision:

```python
# ✓ Good - includes context
oldString = """
def helper():
    return x

def my_function():
    value = helper()
    return value * 2
"""

# ✗ Bad - no context, could match multiple locations
oldString = "return value * 2"
```

### Don't Assume File Structure

Always search/list before assuming paths or structure:

```
✓ Correct: "Let me find where this file actually lives"
✗ Wrong: "I'll edit src/utils/helpers.ts" (assumes structure)
```

---

## Real-World Example: Documentation Update

Task: Update all references to an API function from `parseConfig` to `parseConfiguration`

**Composition Approach**:

```
1. semantic_search for "parseConfig" usage patterns
2. grep_search for exact matches to find all references
3. file_search in docs/ to find documentation files
4. multi_replace to update all references in docs with consistent formatting
5. get_errors to check for broken links or syntax issues
6. Report: "Updated X references in Y files"
```

**Why composition works here**:
- Search tools locate all relevant occurrences (no missed updates)
- Single multi_replace operation maintains consistency
- Verification catches broken cross-references
- Clear reporting shows scope of change

---

## Anti-Patterns to Avoid

### ❌ Tool Misuse

**Problem**: Using wrong tool for task
- Example: Using `file_search` then `grep_search` then `semantic_search` for same goal (inefficient)
- Solution: Pick best tool for job; combine only when different information needed

### ❌ Modify Without Context

**Problem**: Making changes without reading surrounding code
- Example: `replace_string_in_file` without reading the file first
- Solution: Always `read_file` before targeted edits

### ❌ Skip Verification

**Problem**: Applying changes then assuming success
- Example: "I've updated the code" without checking for syntax errors
- Solution: Always run `get_errors` after modifications

### ❌ Hidden Assumptions

**Problem**: Assuming project structure, file locations, or naming conventions
- Example: Assuming config is in `src/config.ts`
- Solution: Search first, assume second

---

## References

- **Related**: [Tool Restrictions and Safety](<./tool-restrictions-and-safety.md>) — scope principles for tool access
- **Related**: [Instruction Engineering Best Practices](<./instruction-engineering-best-practices.md>) — how to guide agents in tool composition
- **Related**: [Common Failure Modes](<./common-failure-modes.md>) — failures of poor tool composition
