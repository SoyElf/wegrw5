# Recruitment Rationale: @housekeeper

## Capability Gap Identified

**What problem was identified?**

The workspace suffers from structural disorganization that creates friction and maintenance burden:
- Root directory cluttered with 9 markdown docs + 3 executable scripts (should be in subdirectories)
- Dual skills directories (./.agents/skills vs ./.github/agents/skills) creating confusion
- 13 old evaluation reports mixed with active context files in ./.github/context/
- Deprecated documentation (dated reports, 9 evaluation evals) not archived
- Duplicate files with identical content (.md and .txt versions) taking up space
- Cross-references and links brittle when files move manually
- No single agent responsible for enforcing organization patterns consistently

This disorganization creates cognitive overhead, makes navigation difficult, and introduces risk of broken links during file reorganization.

**Why existing agents insufficient?**

- **@git-ops**: Handles git operations only; cannot decide what to move or where
- **@doc**: Writes documentation; doesn't reorganize or archive existing files
- **@bash-ops**: Creates scripts; doesn't organize workspace infrastructure
- **Ben**: Orchestrator only; cannot execute organizational work directly
- **@explore-codebase**: Reads code; doesn't modify structure
- **@research**: External research; not workspace maintenance

No existing agent has the responsibility of systematically organizing and maintaining workspace structure while validating links and coordinating with other specialists.

## New Agent Solution

**Agent**: @housekeeper
**Domain**: Workspace file organization and structure maintenance
**Primary Responsibilities**:
1. Directory Organization — Organize scattered files into appropriate hierarchies
2. Link Validation & Updates — Prevent broken cross-references when files move
3. Archival Management — Move stale files to archive while preserving git history
4. Structure Enforcement — Maintain and enforce workspace organization patterns
5. Sub-Orchestration — Coordinate with @git-ops for moves and @doc for link updates

## Problem Solved

**What this agent enables**:
- Methodically reorganize workspace without manual work or broken links
- Archive old evaluation reports and dated decisions cleanly
- Consolidate duplicate files (e.g., quick-reference.md + .txt)
- Enforce consistent directory structure (docs/, scripts/, .github/context/, etc.)
- Keep workspace clean and discoverable for users and other agents
- Move files safely with git history preserved and all references updated

Users and orchestrators can now request "clean up the workspace" and @housekeeper will:
- Propose a detailed reorganization plan
- Validate all cross-references
- Delegate file operations to @git-ops (safe moves with git history)
- Delegate link updates to @doc
- Verify final structure and document changes

## Portfolio Integration

**Complements**:
- **@git-ops**: Housekeeper proposes moves; @git-ops executes them safely with `git mv` and atomic commits
- **@doc**: Housekeeper identifies link updates needed; @doc updates references and validates syntax
- **Ben**: Housekeeper executes workspace maintenance on Ben's coordination; Ben delegates to @housekeeper when workspace structure work is needed

**Distinct from**:
- **@housekeeper vs @git-ops**: Housekeeper decides what to move and where; @git-ops executes with git. No overlap.
- **@housekeeper vs @doc**: Housekeeper organizes existing files; @doc writes new documentation. Complementary, not duplicative.
- **@housekeeper vs Ben**: Housekeeper executes specific structural work; Ben coordinates. Ben delegates housekeeping tasks to @housekeeper.

**Lifecycle**: Permanent addition. Workspace maintenance is ongoing responsibility to prevent disorganization and debt.

## Design Decisions

**Why these responsibilities?**

The 5 responsibilities map directly to the identified problems:
1. Directory Organization → addresses root clutter and scattered files
2. Link Validation & Updates → prevents link breakage migration risk
3. Archival Management → handles dated reports and deprecated files
4. Structure Enforcement → maintains patterns to prevent future disorganization
5. Sub-Orchestration → coordinates specialist agents for safe execution

These responsibilities are tightly scoped to structural organization; they exclude content creation, architectural decisions, and code modification.

**Why these constraints?**

- **Cannot create content**: Housekeeper organizes existing files; it's not a content creator like @doc
- **Cannot delete files**: All removals go to archive/ to preserve git history and reversibility
- **Cannot skip git operations**: All moves delegated to @git-ops to maintain correct git history (not direct filesystem moves)
- **Cannot bypass link validation**: Links are validated before and after moves to prevent silent breakage
- **Cannot execute moves directly**: Delegation to @git-ops ensures safe operations and Conventional Commits compliance
- **Cannot assume structure**: Always verifies with file_search first (defensive programming)

**Why these tools?**

- `search/fileSearch`: Discover all files in workspace root and subdirectories (map current structure)
- `read/readFile`: Read files to understand purpose and content
- `search/textSearch`: Find all cross-references and links (validate before/after moves)
- `edit/createDirectory`: Create archive directories and new subdirectories as needed
- `edit/editFiles`: Update all cross-references and links after moves (batch updates with multi-replace)
- `search/codebase`: Search codebase patterns and dependencies (understand impact of moves)
- `read/problems`: Verify file syntax after link updates (no broken markdown)
- `agent`: Delegate to @git-ops and @doc as needed (sub-orchestration)

Tools are minimal and focused: navigation, validation, and delegation. No destructive operations (all delegated to @git-ops).

## Success Criteria

**How to measure if @housekeeper is working**:

1. **Root Clean** — Root directory contains only essential files (README.md, .workspace, .github/, .git/, config)
2. **Documentation Organized** — All docs in docs/ with guides/ for user-facing and research/ for technical
3. **Scripts Organized** — All executable scripts in scripts/ directory
4. **Context Structured** — Active context in .github/context/, old files in .github/context/archive/
5. **Links Verified** — No broken cross-references; all links tested and working
6. **Structure Documented** — Directory structure documented in workspace README with clear rationale
7. **Duplicates Removed** — Only one version of files (prefer .md over .txt)
8. **Git History Preserved** — All moves preserve history (git mv not rm+add)

**First execution success criteria** (initial recruitment validation):
- Example: Propose and execute archival of 9+ dated evaluation reports to .github/context/archive/
- Consolidate quick-reference.md and .txt into single .md file
- Move root documentation files to docs/ with all links updated and verified

## Design Decisions Applied from Patterns

This recruitment applied several established patterns:

1. **6-Element Specialization Framework**: Domain (workspace organization), Responsibilities (5 items), Constraints (10 items protecting scope), Tools (justified for domain), Success Criteria (measurable), Escalation Paths (5 scenarios)

2. **Sub-Agent Pattern**: @housekeeper is sub-agent only (user-invocable: false) because it's invoked as part of workspace orchestration, not directly by users. Ben routes to @housekeeper when workspace structure work is needed.

3. **Tool Composition Pattern**: Uses Search-Then-Modify pattern
   - search/fileSearch → discover structure
   - read/readFile → understand content
   - search/textSearch → find affected references
   - edit/editFiles → update all references (batch)
   - read/problems → verify syntax

4. **Delegation Pattern**: Housekeeper proposes moves but delegates execution
   - Analysis/planning: @housekeeper
   - File moves: @git-ops (safe, preserves history)
   - Link updates: @doc (validates syntax, maintains style)
   - Coordination: Ben (oversees workflow)

5. **Scope Boundary Enforcement**: Multiple constraints prevent mission creep
   - Cannot create content (stays out of @doc's domain)
   - Cannot modify code (stays out of application territory)
   - Cannot execute moves directly (enforces @git-ops coordination)

---

**Created**: 2026-03-31
**Verified by**:
- ✓ Capability Gap Analysis (clear, well-defined problem)
- ✓ 6-Element Specialization Framework (all 6 elements complete)
- ✓ 7-Section Instruction Engineering (all 7 sections present)
- ✓ Portfolio Integration Verification (distinct from existing agents, complements @git-ops and @doc)
- ✓ Pre-Deployment Verification (YAML valid, tools valid, file in correct location)

**Status**: ✅ **DEPLOYED** — Agent is complete, registered, and ready for use.
