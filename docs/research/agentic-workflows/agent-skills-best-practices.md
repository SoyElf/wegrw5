# Agent Skills Best Practices & Design Patterns

**Comprehensive Research Report**
*Date: March 31, 2026*
*Research Scope: Agent skill definition, structure, discovery, usage patterns, and workspace organization*

---

## Executive Summary

Agent skills are **reusable, packaged units of domain-specific knowledge** designed for AI agents to discover and leverage during problem-solving. Unlike guides (human-readable walkthroughs) or references (parameter lookup), skills are **agent-first**: they include discoverable metadata, clear entry points, and navigable structure optimized for agent consumption.

### Key Findings

1. **Skill is distinct from guide/reference**: A skill packages knowledge with metadata and entry points for agent discovery. Guides provide human-readable learning paths. References provide lookup tables.

2. **Metadata determines usability**: Rich frontmatter (name, description, keywords, audience, prerequisites, difficulty, tags) is **mandatory**. Without metadata, agents can't find or understand when to use the skill.

3. **Target 1500-2500 words**: Most skills should occupy this range—substantial enough to provide real value, lightweight enough for agents to navigate without getting lost. Anything over 3000 words should be split.

4. **Entry points are critical**: Agents don't read linearly. They jump to relevant sections. Skills need multiple entry points ("Start here," "Reference," "Patterns") to accommodate different agent needs.

5. **Skills vs Guides vs References**: Skills are navigation layers (entry points + links). Guides are learning paths (read top-to-bottom). References are lookup tables (search for detail). A well-designed system combines all three, with skills as the discovery layer.

6. **Reusability requires clear domain boundary**: Skills work best when domain-specific, not agent-specific. "@doc-skill" isn't reusable. "documentation-patterns-skill" is.

---

## 1. What IS an Agent Skill?

### Definition

An **agent skill** is a reusable, packaged unit of domain-specific knowledge, capability, or procedural expertise designed to enhance AI agents' effectiveness. A skill:

- **Is agent-first**: Optimized for agents to discover and consume
- **Has clear metadata**: Name, description, keywords, audience, prerequisites
- **Provides multiple entry points**: Different agents have different questions
- **Is discoverable**: Keywords and tags enable finding it
- **Is self-contained**: Doesn't require extensive prerequisite reading
- **Is composable**: Can be combined with other skills
- **Is versioned**: Tracks changes and deprecations

### Purpose

Reasons to package knowledge as a skill:

1. **Enable discovery** — Agents can find specialized knowledge without being explicitly told where it is
2. **Provide procedural guidance** — Complex, domain-specific workflows documented step-by-step
3. **Serve as reference layer** — Agents can query the skill for answers during reasoning
4. **Prevent duplication** — One authoritative source agents can reference
5. **Create composable blocks** — Multiple agents can leverage same knowledge to build complex solutions

### Real-World Examples

#### Example 1: Hindsight Documentation Skill (Workspace)

**What**: Complete Hindsight documentation packaged as an agent skill
**Location**: `/.agents/skills/hindsight-docs/SKILL.md`
**Structure**: YAML frontmatter + organized reference documentation directory with references, SDKs, integrations, cookbook
**Key Insight**: Shows that a skill can wrap extensive reference documentation and provide clear navigation paths for agents to find what they need

This skill works because:
- Clear frontmatter tells agents "This is Hindsight documentation, use when learning memory operations"
- Multiple entry points: "Start with best practices," "See API reference," "Find SDK integration," "Review cookbook examples"
- Organized subdirectories let agents navigate by concern (developer API vs. SDKs vs. patterns)

#### Example 2: Hindsight Documentation Skill (Workspace)

**What**: Complete Hindsight memory system documentation packaged as reusable skill
**Location**: `/.github/agents/skills/hindsight-docs/SKILL.md`
**Pattern**: Organizes extensive reference documentation with clear navigation paths for agents
**Key Insight**: Skills can provide comprehensive reference material with multiple entry points, making complex domains accessible

#### Example 3: Claude Agent Capabilities (Anthropic Pattern)

When Claude agents need to know "What can Claude do?", this is packaged as a discoverable skill with model capabilities, limitations, and versioning. Agents invoke this to understand constraints before designing workflows.

### Skills vs Guides vs References

| Aspect | Skill | Guide | Reference |
|--------|-------|-------|-----------|
| **Purpose** | Navigation + entry points | Learning path | Lookup material |
| **Audience** | Both agents and humans | Primarily humans | Both agents and humans |
| **Structure** | Frontmatter + sections + links | Chapter sequence | Indexed, alphabetical, searchable |
| **Length** | 500-5000 words + links | 2000-10000+ words | Variable (entries are brief) |
| **Discovery** | Keywords, tags, metadata | Linked from skills | Indexed search |
| **Reading Pattern** | Non-linear (jump to section) | Linear (chapter by chapter) | Targeted search |
| **Example** | Hindsight docs skill | "Comprehensive Hindsight tutorial" | "Hindsight API parameter reference" |

---

## 2. Proper Skill Structure: Anatomy of a Well-Designed Skill

### YAML Frontmatter (Metadata)

#### Required Fields

**`name`** (string)
- Human-readable skill name
- Should be searchable and descriptive
- Examples: "Hindsight Documentation," "CLI Modes Reference," "Python Testing Patterns"
- **Best Practice**: Use clear, domain-specific names. Avoid generic names like "Utilities" or "Helpers"

**`description`** (string)
- 1-2 sentence summary of what the skill provides
- When agents should use it
- Examples:
  - "Complete Hindsight documentation for AI agents. Use this to learn about architecture, APIs, and best practices."
  - "Reference guide for GitHub Copilot CLI modes and when to use each mode."
- **Best Practice**: Be specific about domain and use case. Agents use this to decide relevance.

#### Recommended Metadata Fields

**`keywords`** (array)
- Search terms agents might use when looking for this skill
- Include synonyms and related concepts
- Example: For Hindsight skill: `["hindsight", "memory", "retention", "recall", "reflect", "agents", "documentation"]`
- **Best Practice**: Think like an agent asking questions. "I need to remember things" → include "memory" + "retention"

**`audience`** (array)
- Which agents/roles should use this skill
- Helps orchestrators route work
- Example: `["@agentic-workflow-researcher", "@skill-builder", "any agent needing memory patterns"]`
- **Best Practice**: Be explicit. Prevents misuse and wasted discovery.

**`prerequisites`** (array)
- Required knowledge or skills agents need before using this skill
- Example: `["Understanding of agent architecture", "Familiarity with REST APIs"]`
- **Best Practice**: Clear prerequisites prevent agents from getting lost in advanced material.

**`difficulty`** (string)
- Complexity level: `beginner | intermediate | advanced`
- Helps agents self-select appropriate resources
- **Best Practice**: Mix levels in skill structure so agents can start simple.

**`version`** (string)
- Semantic version (e.g., `1.0.0`, `1.2.3`) for tracking skill evolution
- Enables version-aware references
- **Best Practice**: Bump version when substantially updating. Track in changelog.

**`tags`** (array)
- Categorical tags for navigation and filtering
- Examples: `["pattern:agentic-workflows", "category:memory", "domain:AI"]`
- **Best Practice**: Use consistent tagging scheme across all skills.

### Markdown Content Structure

Skills should follow a consistent structure to make them navigable:

#### 1. Overview / Purpose (100-200 words)

**Purpose**: Clearly state WHEN and WHY agents should use this skill

**Content**:
- What problem does this skill solve?
- When should agents reference this skill?
- What will agents learn/accomplish?

**Example**:
> "This skill provides complete documentation for Hindsight, an AI memory system. Use it when you need to: store information to agents' long-term memory, retrieve memories to inform decision-making, or synthesize memories into reasoned answers. This skill covers architecture, APIs, SDKs, and integration patterns."

#### 2. Entry Points / Navigation (200-300 words)

**Purpose**: How agents can navigate the skill. Multiple pathways for different use cases.

**Content**:
- "Start here if you're..." — entry point for beginners
- "Find X by..." — navigation for lookup
- "Quick reference" — summary table for scanning
- "Full API" — comprehensive reference

**Example**:
```
## How to Use This Skill

**Learning Hindsight from scratch?**
Start with: Core Concepts → Your First Memory Bank → Common Patterns

**Looking for specific knowledge?**
Use: Quick Reference table or search keywords

**Need API details?**
See: Reference section organized by operation (retain, recall, reflect)

**Building with SDKs?**
See: SDK Integrations with code examples

**Want to solve a specific problem?**
See: Cookbook → Recipes organized by use case
```

#### 3. Core Concepts (500-800 words)

**Purpose**: Key ideas agents need to understand (brief, not comprehensive)

**Content**:
- Concept 1: Definition + quick context
- Concept 2: Definition + quick context
- Links to detailed sections for deep dives

**Avoid**: Comprehensive explanation (that's for guides). Just enough context to be useful.

#### 4. How to Use This Skill (500-1000 words)

**Purpose**: Procedural guidance for common tasks

**Content**:
- Task 1: Step-by-step workflow
- Task 2: Step-by-step workflow
- Common variations and edge cases

**Example**:
```
## Common Tasks

### Task 1: Store a memory
1. Create memory bank: `bank = create_bank(id='agent-123')`
2. Retain memory: `bank.retain(content='...')`
3. [Worked example with code]

### Task 2: Search memories
1. [Steps]
2. [Worked example]
```

#### 5. Reference / Details (1000-2000 words)

**Purpose**: Comprehensive reference material organized logically

**Content**:
- API endpoints / parameters
- Configuration options
- Code examples
- Best practices

**Note**: If this section exceeds 1500 words, move to separate file: `[topic]-reference.md`

#### 6. Common Patterns (300-500 words)

**Purpose**: How to combine this skill with others for complex workflows

**Content**:
- Pattern 1: How to use this skill with [other skill]
- Pattern 2: Multi-step workflow combining skills
- When NOT to use this skill (guard against misuse)

**Example**:
```
## Common Patterns

### Pattern: Agent with Memory
Use hindsight-docs to understand memory patterns + implement persistent storage
→ Agent can use memory banks to persist knowledge across sessions

### When NOT to use Hindsight
If you need temporary session context only → Use .github/context/ (ephemeral)
If you need long-term learning across sessions → Use hindsight (persistent)
```

---

## 3. Size & Scope Guidelines

### Minimal Viable Skill (500-1000 words)

**What**: Minimum a skill needs to provide actionable value

**Required Components**:
- Clear frontmatter (name, description, keywords)
- One primary use case + entry point
- Core concepts explained (500-800 words)
- One worked example or procedure
- Links to deeper material if needed

**When Appropriate**:
- Narrow domain with clear singular use case
- Common reference material
- Temporary/evolving knowledge

**Example**: "GitHub CLI Modes Quick Reference" — explains modes, when to use each, with examples. For comprehensive tutorial, links to guide.

### Comprehensive Skill (2000-5000 words)

**What**: Well-structured skill with both breadth and depth

**Structure**:
- Rich frontmatter (keywords, audience, prerequisites, difficulty, tags)
- Overview + multiple entry points
- Core concepts explained
- Several use cases with examples
- Linked subdirectories with detailed reference
- Patterns showing composition with other skills
- Version history and limitations

**When Appropriate**:
- Complex domain with multiple use cases
- Deep reference material needed
- Foundational to multiple agents

**Example**: Hindsight docs skill (2000+ words + supporting references directory)

### Overweight Skill: Anti-Pattern

**Signs of overweight skill**:
- Single .md file >5000 words (should split or link to guides)
- Trying to cover everything (becomes unwieldy)
- Heavy narrative prose (agents scan, don't read essays)
- Unclear when to use (too broad)
- No clear entry points (agents get lost)
- Assumes sequential reading (modern agents navigate laterally)

**Solution**: Split into focused skills
- Core skill (1000-2000 words) for entry point
- Separate guides (2000+ words) for comprehensive learning
- Separate references for lookup material
- Link them together

### Word Count Targets

| Length | Assessment | Action |
|--------|-----------|--------|
| **<500 words** | Too brief. Not enough value. | Expand it or leave as summary in a guide |
| **500-1500 words** | Minimal viable skill. Narrow domain. | Good for well-defined single use case |
| **1500-3000 words** | Sweet spot for most skills | Covers domain with breadth and depth |
| **3000-5000 words** | Complex domain, multiple use cases | Consider whether this should be 2 skills |
| **>5000 words** | Almost certainly too heavy | Split into multiple skills or link to guides |

### Decision Framework: When to Split a Skill

**Question 1**: Are there distinct use cases with different prerequisites?
- **YES** → Split. Example: "Hindsight for Beginners" vs "Hindsight API Reference"

**Question 2**: Would agents ask fundamentally different questions about this topic?
- **YES** → Split. Example: "CLI Modes Overview" vs "CLI Mode Parameter Reference"

**Question 3**: Is there supporting material (deep dives, tutorials, code examples) that's >1000 words?
- **YES** → Link to guides/references. Keep skill as entry point and navigation layer.

**Heuristic**: If you imagine an agent asking "How do I do X with this skill?" and can't answer clearly in 500 words, split it.

---

## 4. Discovery and Usage Patterns

### How Agents Find Skills

1. **Explicit invocation** — Agent knows skill exists and calls it: `@skill-name`

2. **Orchestrator routing** — Ben analyzes task and hints: *"Review hindsight-docs to understand memory patterns"*

3. **Semantic search** — Agent uses `semantic_search` or `grep`: *"Find documentation about memory operations"*

4. **Directory enumeration** — Agent lists `.github/agents/skills/` and reads frontmatter to discover available skills

5. **Metadata matching** — Agent searches by keyword from skill metadata: *"Find skills about agents"*

### How Agents Use Skills

1. **Read entire skill + navigate by section** — Agent needs comprehensive understanding of domain

2. **Extract specific section** — Agent asks *"What does Reference section say about parameters?"* and uses just that part

3. **Follow entry point** — Agent uses *"Start Here"* guidance to navigate to relevant subsection

4. **Compose with other skills** — Agent uses Skill A + Skill B together to solve larger problem. Example: Use CLI modes skill + agent architecture skill

5. **Reference during reasoning** — Agent includes skill excerpt in reasoning context to improve decision-making when designing workflows

### Cross-Linking Patterns

**Skill-to-Skill**: Skills link when composable
> "See [Agent Architecture Skill] for context on how agents work. This skill focuses specifically on memory operations."

**Skill-to-Guide**: Skill links to guides for deeper learning
> "For detailed tutorial, see docs/guides/hindsight-comprehensive-guide.md. This skill is a reference; guides provide learning paths."

**Skill-to-Research**: Skill links to research for best practices/patterns
> "For analysis of agent memory patterns in mature systems, see docs/research/agentic-workflows/"

**Guides-to-Skill**: Guides reference skills for looking up details
> "When implementing agent memory, @skill-builder recommends consulting hindsight-docs skill for API parameter definitions."

### Metadata Enables Programmatic Discovery

**Keywords field**: Enables semantic matching
> Agent: "I need to know about memory operations"
> System: Semantic search finds skill with keywords `["memory", "retention", "recall"]`

**Audience field**: Helps orchestrators route
> Ben: "@research agent needs historical context. Should I provide skill?"
> Check: Does "audience" field include "@agentic-workflow-researcher"? → YES, route it.

**Prerequisites field**: Prevents misuse
> Agent checks: "Does this skill have prerequisite I'm missing?"
> Agent: "Memory patterns skill requires understanding agent architecture. Let me get that first."

**Tags field**: Enables category filtering
> Ben: "Show me all pattern: tags"
> System filters by tag and returns all pattern documentation

**Difficulty field**: Helps agents select learning path
> Agent: "I'm new to this. Show me beginner content first"
> System shows beginner sections before advanced content

---

## 5. Documentation Hierarchy in Agentic Systems

### The Four-Layer Model

```
┌─────────────────────────────────────────────────────────────┐
│ SKILL (Entry Point & Navigation Layer)                      │
│ Purpose: Help agents find what they need                    │
│ - Metadata (keywords, tags, audience)                       │
│ - Multiple entry points ("Start here", "Reference", etc)    │
│ - Links to deeper material                                  │
└─────────────────────────────────────────────────────────────┘
        ↓ Link to guide for learning
┌─────────────────────────────────────────────────────────────┐
│ GUIDE (Human Learning Path Layer)                           │
│ Purpose: Comprehensive walkthrough from intro → advanced    │
│ - Chapter structure that flows logically                    │
│ - Assumes reader is learning (not just looking up detail)   │
│ - 2000-10000+ words                                        │
└─────────────────────────────────────────────────────────────┘
        ↓ Linked from prose
┌─────────────────────────────────────────────────────────────┐
│ REFERENCE (Lookup Detail Layer)                             │
│ Purpose: Parameter tables, API docs, type definitions       │
│ - Organized alphabetically or by category                   │
│ - Each entry self-contained (1-2 sentences)                 │
│ - For people who know what they're looking for              │
└─────────────────────────────────────────────────────────────┘
        ↓ Synthesizes findings from
┌─────────────────────────────────────────────────────────────┐
│ RESEARCH (Synthesized Findings Layer)                       │
│ Purpose: Best practices, patterns, sources, recommendations │
│ - Executive summary + findings + sources                    │
│ - For decision-makers evaluating approaches                 │
│ - 2000-5000 words with citations                            │
└─────────────────────────────────────────────────────────────┘
```

### Layer Details

| Layer | Purpose | Audience | Structure | Length | Reading Pattern |
|-------|---------|----------|-----------|--------|-----------------|
| **Skill** | Navigation + entry points | Agents & users | YAML frontmatter + sections + nav | 500-5000 + links | Non-linear: jump to section |
| **Guide** | Learning path | Primarily humans | Chapter sequence, intro → advanced | 2000-10000+ | Linear: chapter by chapter |
| **Reference** | Lookup detail | Developers/agents | Indexed, alphabetical | Variable | Target search |
| **Research** | Synthesized findings | Decision-makers | Exec summary + findings + sources | 2000-5000 | Scan summary, deep-dive findings |

### Mature System Examples

**Anthropic Claude**: API reference (reference) + Guides (tutorials) + Cookbook (patterns)

**VS Code**: Getting started (guides) + API reference (reference) + Extension examples (patterns)

**Kubernetes**: Concepts (guides) + API reference (reference) + Tasks (how-to guides) + Deployments (patterns)

**Hindsight in this workspace**: Architecture (guide) + API reference (reference) + SDK integrations (patterns) + Cookbook (recipes)

### Separation of Concerns

| Layer | Concern |
|-------|---------|
| **Skill** | "Here's how to navigate this domain. Entry points for different needs." |
| **Guide** | "Here's how to learn this domain from the ground up." |
| **Reference** | "Here's the specific detail you're looking for." |
| **Research** | "Here's what we learned from investigating this. Best practices & recommendations." |

---

## 6. Workspace Organization Best Practices

### Recommended Directory Structure

```
.github/agents/skills/
├── README.md                        # Index of all skills (generated or maintained)
├── hindsight-docs/
│   ├── SKILL.md                     # Entry point
│   ├── references/                  # Detailed reference material
│   ├── sdks/                        # SDK integration docs
│   ├── integrations/                # Framework integrations
│   └── cookbook/                    # Recipes and examples
├── agent-architecture-patterns/
│   ├── SKILL.md                     # Entry point
│   └── supporting-references.md     # Details
└── [more skills...]
```

**Rationale**: Skills are discovered via `.github/agents/skills/`. Each skill is a directory with SKILL.md (entry point) + supporting materials. This keeps skills focused and navigable.

### Naming Conventions

**Skill directory**: lowercase-with-hyphens
- Examples: `hindsight-docs`, `agent-patterns`, `bash-automation`
- Rationale: Matches common package naming. Easy to reference in docs.

**Skill file**: Always `SKILL.md` (uppercase) inside skill directory
- Rationale: Makes pattern clear. Agents know entry point location.

**Reference files**: `[topic]-reference.md` or `[topic].md`
- Examples: `modes-reference.md`, `api.md`

### Navigation & Discoverability

#### 1. Create `.github/agents/skills/README.md`

A simple index listing all skills:

```markdown
# Agent Skills

Available skills for discovery and reuse:

| Skill | Description | Keywords | For |
|-------|---|---|---|

| [Hindsight Documentation Skill](hindsight-docs/SKILL.md) | Complete Hindsight documentation | hindsight, memory, agents, API | Agents needing memory patterns |
| [Agent Patterns](agent-architecture-patterns/SKILL.md) | Agentic workflow patterns | agent, architecture, design | Agents designing orchestration |
```

**Benefit**: One place for agents/users to see all options. Simple navigation.

#### 2. Extract Metadata Automatically (if possible)

Tool: Parse skill YAML frontmatter and generate index automatically
- Reduces maintenance burden
- Keeps index current with skills

Or: Maintain manually with discipline

#### 3. Documentation Hierarchy Mapping

```
Skills Layer: .github/agents/skills/
    ├── Agent-first, discoverable, entry points
    └── Links to comprehensive guides/references
         ↓
    Guides Layer: docs/guides/
         ├── Human-readable walkthroughs
         └── Links to skills and references
         ↓
    Reference Layer: docs/research/ + linked references
         ├── API docs, lookup material, parameters
         └── Cross-linked from skills
         ↓
    Research Layer: .github/context/
         ├── Research findings with sources
         └── Informs skill design (not agent-consumed)
```

### Cross-Linking Strategy

**Skill → Guides**: Skill says
> "For comprehensive tutorial, see [docs/guides/hindsight-comprehensive-guide.md](docs/guides/hindsight-comprehensive-guide.md)"

**Guide → Skills**: Guide says
> "Reference this during agent workflows using `@hindsight-docs` skill"

**Skills ↔ Skills**: Related skills link
> "See also: [Hindsight Docs Skill](../hindsight-docs/) for memory operation details"

**All layers**: Each links down and up
- Skills link to guides + references + research
- Guides reference skills for API details
- Research informs skill design

### Maintenance Responsibility

| Layer | Owner | Responsibility |
|-------|-------|-----------------|
| **Skills** | `@skill-builder` | Maintain skill quality, structure, metadata, organization |
| **Guides** | `@doc` | Write and maintain comprehensive walkthroughs |
| **References** | Domain maintainer | Keep parameter definitions, API docs current |
| **Research** | `@agentic-workflow-researcher` | Create and update research findings with sources |

### Version Control Patterns

**Skills in Git**:
- SKILL.md and supporting files version-controlled
- Enables history, diffs, and rollback

**Semantic Versioning**:
- Each skill has version field (e.g., 1.2.0)
- Bump when substantially updating skill

**Changelog**:
- Maintain simple CHANGELOG or version annotations in SKILL.md
- Document what changed between versions

**Deprecation Strategy**:
- Don't delete old skills
- Mark deprecated with replacement link
- Example: `status: deprecated as of v2.0, see new-skill-name instead`

---

## 7. Best Practices (DO THIS)

### 1. Start with Clear Metadata

**Why**: Agents need to know what your skill is about before reading. Metadata determines discoverability.

**How**:
```yaml
name: CLI Modes Reference
description: Quick reference for GitHub Copilot CLI modes and when to use each one.
keywords: [cli, modes, github, copilot, cli-modes, reference]
audience: [any agent using Copilot CLI]
prerequisites: [basic understanding of GitHub Copilot]
difficulty: beginner
tags: [reference, cli, github-copilot]
```

### 2. Include Clear Entry Points & Navigation

**Why**: Agents don't read documents end-to-end. They jump to sections. Help them navigate.

**How**:
```markdown
## How to Use This Skill

**Picking a CLI mode?** → See Mode Comparison Table

**Learning modes from scratch?** → Start with Concepts, then Examples

**Need mode parameters?** → See Reference section

**Want to use modes in a workflow?** → See Common Patterns
```

### 3. Write for Agent Discovery

**Why**: Agents will use semantic search or grep. Think like an agent asking questions.

**How**:
- If agents ask "How do I run Copilot in different modes?" → include "modes," "run," "configurations" in keywords
- If agents ask "What are CLI parameters?" → include "parameters," "flags," "options"
- Think: What question would bring an agent to this skill?

### 4. Provide Worked Examples for Procedures

**Why**: Agents learn by example. Procedural content needs concrete instances.

**Good**:
```bash
# Run in specific mode
copilot run --mode agentic-workflow

# Expected output:
# [Copilot output in agentic-workflow mode]
```

**Avoid**:
> "Configure the mode using the mode selector"

### 5. Link to Guides & References

**Why**: Skill is entry point, not complete encyclopediaedia. Link to comprehensive content.

**How**:
> "For detailed CLI modes tutorial with advanced examples, see [CLI Mode Patterns & Orchestration Heuristics: Comprehensive Skill Guide](<../../guides/cli-modes-comprehensive-guide.md>)"

### 6. State Prerequisites & Target Audience

**Why**: Prevents agents from getting lost. Helps orchestrators route appropriately.

**How**:
```yaml
prerequisites: [understanding of GitHub Copilot basics, basic CLI knowledge]
audience: [@any-agent-using-cli, developers]
```

### 7. Use Consistent Section Headers

**Why**: Agents recognize patterns. Consistency makes skills predictable.

**Recommended structure for all skills**:
1. Overview
2. When to Use
3. How to Use This Skill
4. Core Concepts
5. Common Patterns
6. Reference / Details
7. Further Reading

### 8. Include Version & Deprecation Info

**Why**: Skills evolve. Agents/users need to know if skill is current.

**How**:
```yaml
version: 1.2.0
status: active
deprecated_in: null
```

Or if deprecated:
```yaml
version: 2.0.0  # Last working version
status: deprecated as of 2.0
replacement: new-cli-modes-skill-v3
```

---

## 8. Anti-Patterns (DON'T DO THIS)

### ❌ Writing Skill Like a Guide

**Problem**: Heavy narrative, trying to cover everything. Agents get lost. "Read all or nothing."

**Instead**: Write skill as entry point layer. Narrative goes in docs/guides/

### ❌ Unclear When to Use Skill

**Problem**: "This is about stuff" — Agents can't determine relevance. Wasted discovery.

**Instead**: State clearly: "Use this when you [specific problem]. DON'T use this for [what it's NOT]"

### ❌ Mixing Multiple Concerns

**Problem**: Agent design + tool patterns + orchestration = unmaintainable, confusing

**Instead**: One skill per focused domain. Cross-link related skills.

### ❌ No Keywords or Metadata

**Problem**: Skills are undiscoverable. Agents can't find them.

**Instead**: Rich metadata is mandatory. Keywords, audience, prerequisites, tags.

### ❌ Assuming Agent Context

**Problem**: "You already know how X works" → Skill isn't self-contained

**Instead**: State prerequisites explicitly. Assume minimal context.

### ❌ No Clear Structure/TOC

**Problem**: Agents can't navigate. Have to read everything.

**Instead**: Section headers, internal links, and nav guidance. Make scanning easy.

### ❌ Skill-Specific to One Agent

**Problem**: "@doc-skill" isn't reusable. Other agents can't leverage it.

**Instead**: Create domain skills (@doc uses them, but so can other agents)

### ❌ Outdated Skills with No Deprecation Info

**Problem**: Agents use stale information. Creates confusion.

**Instead**: Version all skills. Mark deprecated clearly. Link to replacements.

---

## 9. Design Recommendations for This Workspace

### R1: Adopt Consistent SKILL.md Structure

**What**: Define and enforce standard SKILL.md template.

**Why**: Consistency makes skills predictable. Agents and users recognize patterns.

**Action**:
- Create `.github/agents/skills/SKILL-TEMPLATE.md` with required sections
- Require all new skills to follow template
- @skill-builder enforces in reviews

**Template sections**:
1. Frontmatter with required metadata
2. Overview
3. When to Use
4. Entry Points / Navigation
5. Core Concepts
6. How to Use This Skill
7. Common Patterns
8. Reference / Details
9. Further Reading

### R2: Require Rich Frontmatter Metadata

**What**: Mandatory metadata fields in YAML.

**Why**: Metadata enables programmatic discovery and routing. Without it, skills are hidden.

**Required fields**:
- `name` — Human-readable skill name
- `description` — 1-2 sentence summary
- `keywords` — Array of search terms
- `audience` — Who should use this

**Recommended fields**:
- `prerequisites` — What agents need to know first
- `difficulty` — beginner/intermediate/advanced
- `tags` — Categorical tags for filtering
- `version` — Semantic version

**Action**:
- Create frontmatter schema document
- @skill-builder validates in PR reviews
- Consider automated YAML schema validation if tooling available

### R3: Create `.github/agents/skills/README.md` Index

**What**: Maintain index of all available skills.

**Why**: One place for agents to discover available skills. Improves discoverability!

**Content**:
- Table or list of all skills
- Name, description, keywords, audience for each
- Links to each skill's SKILL.md

**Action**:
- Generate index from skill metadata (if possible via tool)
- Or maintain manually with discipline
- Update whenever new skill created

**Example format**:
```markdown
| Skill | Description | Keywords | For |
|-------|---|---|---|

```

### R4: Establish Skill/Guide/Reference/Research Boundary

**What**: Document when content belongs in skill vs guide vs reference vs research.

**Why**: Clear separation prevents duplication and confusion. Users understand where to look.

**Decision tree**:
- Agent-first + discoverable + entry points? → **Skill**
- Human learning path + sequential? → **Guide**
- Lookup detail + parameter tables? → **Reference**
- Synthesized findings + sources? → **Research**

**Action**:
- Document decision framework in workspace docs
- Include in skill design reviews
- Help @doc and @skill-builder coordinate

### R5: Target 1500-2500 Words for Most Skills

**What**: Use word count as quality gate.

**Why**: Sweet spot between comprehensive and navigable. Evidence from workspace examples.

**Guidelines**:
- <500 words: Too brief, grow it
- 500-1500: Minimal viable skill, OK for narrow domains
- 1500-2500: Sweet spot for most skills
- 2500-3500: Consider whether worth splitting
- >3500: Almost certainly too heavy, split into multiple skills

**Action**:
- Document in skill design checklist
- Include word count in PR reviews
- If >3000 words, require justification

### R6: Always Include "When to Use" & "Common Patterns"

**What**: Mandatory sections in every skill.

**Why**: Helps agents determine relevance. Enables understanding how skill composes with others.

**"When to Use"**:
- Use this skill when you [specific problem]
- Don't use this skill for [what it's NOT]

**"Common Patterns"**:
- Pattern 1: How to use this skill with [other skill]
- Pattern 2: Multi-step workflow

**Action**:
- Add to SKILL-TEMPLATE.md
- Include in skill design reviews

### R7: Link Heavy Reference Material as Supporting Files

**What**: Move >1000-word reference sections to separate files.

**Why**: Keeps skill entry point lean. Agents can drill down for details.

**Example**:
```
hindsight-docs/
├── SKILL.md                    # Entry point, nav, concepts (~1500 words)
├── modes-reference.md          # Detailed parameter reference (~2000 words)
└── modes-comparison-table.md   # Quick lookup table
```

**Action**:
- Document in skill design guide
- Include in reviews

### R8: Establish Keyword Engineering Guidelines

**What**: Document how to identify keywords for skills.

**Why**: Keywords determine discoverability. Need clear process.

**Process**:
1. Think: How would an agent ask for this knowledge?
2. List question variations
3. Extract key terms from questions
4. Add synonyms and related concepts
5. Include 8-12 keywords per skill

**Example**:
- Agent question: "I need to remember things across sessions"
- Keywords: memory, retention, long-term, persistence, sessions, storage

**Action**:
- Document in SKILL-TEMPLATE.md
- Create keyword engineering guide for @skill-builder

### R9: Create Skill Template & Checklist for @skill-builder

**What**: Formalize skill creation process with template and checklist.

**Why**: Ensures new skills follow standards and best practices.

**Contents**:
- SKILL-TEMPLATE.md with all required sections
- Pre-filled frontmatter
- Section guidance and examples
- Quality checklist before PR

**Checklist items**:
- [ ] Frontmatter complete and accurate
- [ ] Keywords include search terms agents would use
- [ ] Audience is explicit
- [ ] Prerequisites documented
- [ ] Entry points clear and navigation guidance provided
- [ ] Word count in target range (1500-2500)
- [ ] Includes "When to Use" and "Common Patterns"
- [ ] Heavy reference moved to supporting files
- [ ] Version field set correctly
- [ ] Linked to guides/research where appropriate
- [ ] Metadata review by @ben

**Action**:
- Create `.github/agents/skills/SKILL-TEMPLATE.md`
- Create `.github/agents/skills/SKILL-DESIGN-CHECKLIST.md`
- Share with @skill-builder

### R10: Consider Metadata Caching

**What**: Store skill metadata in `.github/context/` for easy programmatic access.

**Why**: Multiple agents might search skills. Caching metadata enables fast lookup.

**Implementation**:
- Create `.github/context/skills-metadata.json`
- Extract from all SKILL.md files
- Include name, description, keywords, audience, tags from each skill
- Update when new skill created

**Format**:
```json
{
  "skills": [
    {
      "id": "hindsight-docs",
      "name": "Hindsight Documentation",
      "description": "...",
      "keywords": [...],
      "audience": [...],
      "path": ".github/agents/skills/hindsight-docs/SKILL.md"
    }
  ]
}
```

**Benefit**: Agents can run single query to discover relevant skills instead of scanning files.

---

## 10. Implementation Roadmap

### Phase 1: Foundation (Immediate)

- [ ] Document skill/guide/reference/research distinction
- [ ] Create `.github/agents/skills/README.md` index
- [ ] Create `.github/agents/skills/SKILL-TEMPLATE.md`
- [ ] Create `.github/agents/skills/SKILL-DESIGN-CHECKLIST.md`
- [ ] Review existing hindsight-docs skill against recommendations
- [ ] Redesign cli-modes-skill with proper skill structure and entry points

### Phase 2: Standardization (Near-term)

- [ ] Audit all existing skills for metadata completeness
- [ ] Update skills to match template structure
- [ ] Ensure all skills have frontmatter and entry points
- [ ] Create metadata validation (manual or automated)

### Phase 3: Enhancement (Medium-term)

- [ ] Create `.github/context/skills-metadata.json` cache
- [ ] Implement automated metadata extraction (if feasible)
- [ ] Create keyword engineering guide
- [ ] Train @skill-builder on design standards

### Phase 4: Optimization (Ongoing)

- [ ] Monitor skill usage patterns
- [ ] Gather feedback from agents using skills
- [ ] Refine discovery mechanisms based on usage
- [ ] Update guidelines based on lessons learned

---

## Glossary

**Agent Skill**: Reusable, packaged unit of domain-specific knowledge with metadata and entry points for agent discovery.

**Entry Point**: Section in skill that helps agents navigate. Examples: "Start Here," "Quick Reference," "API Details"

**Frontmatter**: YAML metadata at top of skill documenting name, description, keywords, audience, etc.

**Metadata**: Structured information about skill (keywords, tags, audience, prerequisites, difficulty) enabling discovery.

**Navigation**: Multiple pathways through skill content for different agent needs/questions.

**Composability**: Ability to combine multiple skills to solve larger problems.

**Discovery**: Process by which agents find relevant skills (semantic search, keywords, orchestrator routing, etc.)

---

## Sources

- **Workspace**: [Hindsight Documentation Skill](/.agents/skills/hindsight-docs/SKILL.md) — Production example of comprehensive skill
- **Workspace**: [Skill-Builder Agent](/.github/agents/skill-builder.agent.md) — Defines skill design expectations
- **Workspace**: [VS Code Agent Specification](/docs/research/agentic-workflows/vscode-agent-file-specification.md) — Agent metadata and discovery patterns
- **Official**: [Anthropic Claude API](https://docs.anthropic.com) — Official Claude documentation
- **Official**: [GitHub Copilot](https://github.com/features/copilot) — Official GitHub documentation
- **Official**: [VS Code Copilot](https://code.visualstudio.com/docs/copilot) — Official VS Code documentation

---

**Research Completed**: March 31, 2026
**Researcher**: @agentic-workflow-researcher (GitHub Copilot)
**Format**: Comprehensive markdown report + structured JSON research document
**Report Status**: Ready for workspace implementation
