# Recruitment Rationale: @skill-builder

## Capability Gap Identified

**What problem was identified?**

The workspace operates 10+ specialist agents generating code, documentation, scripts, patterns, and workflows, but there is **no agent specializing in identifying, packaging, and publishing reusable skills**. Skills (in SKILL.md format) are the atomic unit of reusability in the GitHub Copilot ecosystem, yet patterns remain scattered across:
- @bash-ops script implementations
- @doc documentation templates
- @research methodologies
- Agent instructions and examples
- Scattered workflow utilities

**Without @skill-builder**, valuable patterns are:
- **Rediscovered**, not reused (agents reinvent solutions)
- **Inaccessible**, not documented (patterns exist but in scattered locations)
- **Non-composable**, not indexed (skills can't be composed with CLI modes or discovered via keywords)
- **Non-observable**, not measurable (Hindsight can't track which patterns are most valuable)

**Why existing agents insufficient?**

- **@bash-ops**, **@doc**, **@research**: Create valuable patterns but don't package them as reusable skills
- **@ar-upskiller**: Improves agent instructions but doesn't extract patterns as discrete skills
- **@explore-codebase**: Discovers code patterns but doesn't package them for reuse
- **No existing agent**: Specializes in pattern extraction, SKILL.md format, keyword discovery, or skills library maintenance

The workspace has the *capability to generate* patterns but lacks the *capability to package and publish* them as reusable skills.

## New Agent Solution

**Agent**: @skill-builder
**Domain**: Skills packaging, knowledge reuse, pattern extraction, skill maintenance
**Primary Responsibilities**:
1. Pattern discovery across code, workflows, and agent behaviors
2. Skill interface design and boundary definition
3. SKILL.md creation with complete frontmatter and instructions
4. Supporting asset generation (scripts, examples, integration guides)
5. Keyword engineering for discovery
6. Quality assurance and integration testing
7. Skills library maintenance and evolution
8. Hindsight-driven improvement based on adoption patterns

**Consuming Agents**: @bash-ops (primary), @doc, @evaluator, @research, @git-ops, Ben (routing hints), all agents (skill discovery)

**Memory Bank**: `workspace-agentic-hub` (shared with all agents)

## Problem Solved

@skill-builder enables the workspace to **convert scattered patterns into discoverable, composable, reusable skills**. This solves:

1. **Knowledge Reuse**: Patterns extracted as skills are automatically discoverable and reusable by all agents
2. **Reduced Duplication**: @bash-ops scripts package as skills → other agents invoke skills instead of reimplementing
3. **Skills Composition**: Skills designed to compose with CLI modes (c-ask, c-plan, c-edit, c-agent) enable new workflow compositions
4. **Observable Patterns**: Hindsight tracks skill adoption, enabling continuous improvement and portfolio learning
5. **Orchestrator Routing**: Ben can route tasks to skills (e.g., "use @deployment-checker skill") with precise keywords

**New capability**: Workspace can now convert 1 valuable pattern → 1 reusable skill → discoverable via keywords, invocable by 5+ agents, measurable adoption via Hindsight.

## Portfolio Integration

**Complements**:
- **@bash-ops**: Extracts shell scripts as "shell-unit-test", "log-analyzer", "deployment-checker" skills
- **@doc**: Packages documentation patterns as "api-docs-generator", "changelog-generator" skills
- **@research**: Extracts methodologies as reusable research skills
- **@git-ops**: Packages git automation as "commit-validator", "release-orchestrator" skills
- **Ben (orchestrator)**: Uses skill keywords as routing hints for task delegation

**Distinct from**:
- **@ar-upskiller**: Improves agent instructions; @skill-builder extracts patterns as separate skills
- **@explore-codebase**: Discovers patterns; @skill-builder packages and publishes them
- **@doc**: Writes documentation; @skill-builder writes skill discoveryintegration (metadata + interface + keywords)

**Lifecycle**: Permanent addition (skills library is core workspace capability for knowledge reuse)

## Design Decisions

**Why these 8 responsibilities?**

Skills require complete lifecycle management: discovery → design → packaging → documentation → testing → publication → maintenance. Each responsibility is distinct and measurable.

- **Pattern Discovery**: Identifies which patterns are worth extracting (prevent over-packaging low-value utilities)
- **Skill Design**: Defines clear interfaces so skills compose correctly (prevents vague, incomprehensible skills)
- **SKILL.md Creation**: Ensures format compliance for discoverability (format matters for routing and invocation)
- **Supporting Assets**: Tests and examples prove skill actually works (prevent shipping broken skills)
- **Keyword Engineering**: Enables discovery via semantic search and orchestrator routing (makes skills findable)
- **Documentation**: Enables consuming agents to invoke skills without architect involvement (reduces dependencies)
- **Quality Assurance**: Catches errors before publication (prevents pollution of skills library)
- **Maintenance**: Tracks adoption, deprecates obsolete skills (keeps library healthy and discoverable)

**Why these constraints?**

- **Production-ready skills only**: Untested/undocumented skills create technical debt and reduce adoption
- **Follow SKILL.md strictly**: Format compliance enables automation (discovery, routing, composition detection)
- **Coordinate before publishing**: Ensures consuming agents actually need the skill and can integrate it
- **Version & deprecate**: Prevents breaking changes when consuming agents rely on skills
- **Don't duplicate ecosystem skills**: Prevents redundancy and confusion with standard Copilot ecosystem
- **No untested publication**: Quality gate prevents low-quality skills from entering library

**Why these tools?**

- **semantic_search**: Discover patterns across scattered code/workflows
- **read/readFile**: Extract implementation details from existing patterns
- **edit/createFile**: Create SKILL.md files and supporting scripts
- **vscode/askQuestions**: Clarify requirements with Ben and consuming agents
- **hindsight/***: Track adoption patterns, improve based on real usage, share institutional memory
- **vscode/memory**: Persist skill creation decisions and design patterns

## Success Criteria

**Successful @skill-builder recruitment means**:

### Impact Metrics
1. **Skills Published**: 2-3 production-ready skills in first month (e.g., shell-unit-test, deployment-checker, changelog-generator each tested and documented)
2. **Consuming Agent Integration**: Each published skill integrated with 2+ consuming agents; documented invocation patterns in agent instructions
3. **Adoption Tracking**: Hindsight tracks skill invocations, providing metrics on which skills are most valuable (feedback loop for improvement)
4. **Keyword Effectiveness**: Skills discoverable via semantic_search using defined keywords (proof that keyword engineering works)

### Quality Metrics
1. **Production Readiness**: 100% of published skills have complete SKILL.md + supporting scripts + integration guides + examples
2. **Integration Success**: All published skills compose with target CLI modes (c-ask, c-plan, c-edit, c-agent) without issue
3. **Documentation Completeness**: Users/agents can invoke skills from documentation alone (no architect needed)
4. **Zero Breaking Changes**: First 3 released skills have zero breaking changes for 2 maintenance cycles (proof of stability)

### Capability Metrics
1. **Pattern Extraction Rate**: @skill-builder able to identify, design, and publish 1 new skill per 2-week cycle (sustainable velocity)
2. **Consuming Agent Satisfaction**: Ben and consuming agents report improved workflow composition (skills enable new workflows)
3. **Library Growth**: Skills library reaches 8-10 skills by 6 months (proof that skilled reuse is working)
4. **Hindsight Integration**: Skill adoption patterns observable in memory bank; improvement decisions data-driven

## Design Decisions Validated Against Best Practices

### 6-Element Specialization Framework ✓

1. **Domain**: Skills packaging and reusability (narrow, well-defined, non-overlapping) ✓
2. **Responsibilities**: 8 specific, measurable, distinguishable deliverables ✓
3. **Constraints**: 6 explicit "can do" + 4 explicit "cannot do" boundaries ✓
4. **Tools**: 8 tools justified for pattern discovery, creation, testing, hindsight integration ✓
5. **Success Criteria**: Measurable outcomes (publication rate, adoption tracking, keyword effectiveness) ✓
6. **Escalation Paths**: Defined when to ask Ben for clarity, when to coordinate with consuming agents ✓

### 7-Section Instruction Engineering ✓

1. **Role**: Clear specialization + primary responsibility ✓
2. **Responsibilities**: 8 specific bulletpoints with examples ✓
3. **Constraints**: Explicit boundaries preventing scope creep ✓
4. **Quality Standards**: Success/non-success criteria with examples ✓
5. **Tool Usage Guidance**: 3 composition patterns + 8-step workflow + decision rules ✓
6. **Escalation Paths**: When to ask Ben, when to coordinate with consuming agents, when to query hindsight ✓
7. **Decision Framework**: How to prioritize, balance granularity, handle deprecation ✓

### Portfolio Integration ✓

- **No duplication**: No existing agent specializes in skills packaging
- **Clear complementarity**: @skill-builder works upstream with @bash-ops, @doc, @research; downstream with Ben and all agents
- **Clean orchestrator routing**: Ben can route "extract this pattern as a skill" to @skill-builder with clear context
- **Shared memory**: Uses workspace-agentic-hub hindsight bank (same as all agents) for portfolio learning

## Lessons Applied from Past Agent Designs

**From @bash-ops recruitment**: Specialization works best when agent has single clear output type (scripts for @bash-ops, skills for @skill-builder). Avoiding dual responsibilities (don't make @bash-ops responsible for testing AND package management — separate into @skill-builder)

**From @ar-director recruitment**: Agents with upskilling/improvement responsibilities benefit from hindsight memory. @skill-builder follows same pattern: retain skill designs, recall past patterns, improve based on adoption data.

**From @ar-upskiller recruitment**: Agents modifying other agents' artifacts need explicit coordination boundaries. @skill-builder works similarly: coordinates with consuming agents before publishing, doesn't modify agent instructions unilaterally.

**From @evaluator recruitment**: Agents generating recommendations benefit from sourced reasoning. @skill-builder applies: keyword choices are justified, design decisions are reasoned, improvements are data-driven (adoption patterns).

**What we learned NOT to do**:
- Don't create agents with 5+ unrelated responsibilities (causes scope creep, unclear specialization)
- Don't design agents without explicit escalation paths (leads to confusion about when to ask for help)
- Don't create agents without hindsight integration (knowledge is siloed, patterns aren't learned)

---

**Created**: 2026-03-31
**Verified Against**: 6-Element Specialization Framework, 7-Section Instruction Engineering, Portfolio Integration Checklist, Pre-Deployment Verification
**Status**: RECRUITMENT COMPLETE

**Next Steps**:
1. ✓ Agent file created at `.github/agents/skill-builder.agent.md`
2. ✓ Ben's Available Agents table updated
3. ✓ Workspace instructions updated (Agent Directory)
4. ✓ Recruitment rationale documented
5. → Ready for hindsight observability setup and first skill extraction project
