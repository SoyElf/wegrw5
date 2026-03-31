# Skills Organization Guide

This workspace maintains two skill directories serving different purposes. Understanding the distinction helps you work effectively with agent skills.

## External Skills: ./.agents/skills/

**Location**: `/.agents/skills/`

**Purpose**: Skills installed via the `npx skills` package manager (like npm packages for agents).

**Management**: Automatically managed by `npx skills` CLI
- `npx skills add <url>` — Install new external skills
- `npx skills update` — Update existing skills (digest-based change detection)
- `npx skills list` — Show all installed skills
- `npx skills remove` — Uninstall skills

**Current External Skills**:
- **hindsight-docs** — Complete Hindsight memory system documentation (70+ files covering APIs, SDKs, integrations, and cookbook recipes)

**Important Warning**: Do NOT manually move or rename files in this directory. The `npx skills` package manager expects a specific structure and location. Moving files may break the `npx skills update` mechanism.

**Directory Structure**:
```
.agents/skills/
├── hindsight-docs/
│   ├── SKILL.md (Entry point)
│   ├── references/ (API documentation)
│   ├── developer/ (Implementation guides)
│   ├── sdks/ (SDK documentation)
│   └── changelog/ (Version history)
```

## Custom Skills: ./.github/agents/skills/

**Location**: `./.github/agents/skills/`

**Purpose**: Custom workspace skills designed by and for this team. Used to package domain-specific knowledge reusable across the workspace.

**Management**: Team-maintained; follows SKILL-TEMPLATE.md structure

**Current Custom Skills**:
- **cli-modes-skill** — CLI modes reference, decision trees, and delegation patterns for GitHub Copilot CLI modes

**Design Files**:
- **SKILL-TEMPLATE.md** — Template and example structure for creating new custom skills
- **README.md** — Skills library index with metadata guidelines and best practices

**Directory Structure**:
```
.github/agents/skills/
├── SKILL-TEMPLATE.md (Template for new skills)
├── README.md (Library index & guidelines)
├── README-SKILLS-ORGANIZATION.md (This file)
└── cli-modes-skill/
    └── SKILL.md (Custom skill entry point)
```

## How Agents Discover Skills

Agents discover skills from **both locations** using three mechanisms:

### 1. Metadata Discovery
Agents search `SKILL.md` metadata fields:
- **keywords** — Search terms agents might use
- **tags** — Categorical filtering
- **audience** — Which agents/roles benefit from this skill
- **description** — What the skill teaches

Example: Agent asks "How do I pick the right CLI mode?" → System finds `cli-modes-skill` via keywords `["cli-modes", "delegation"]`

### 2. Topic-Based Routing
Ben orchestrator explicitly routes agents to specific skills based on task type.

Example: "This task requires understanding CLI mode orchestration patterns" → Ben routes to `cli-modes-skill`

### 3. Direct Request
Agents or users can directly invoke a skill if they know its name.

Example: `@my-agent "Use the cli-modes-skill to explain the decision framework"`

## When to Use External vs. Custom

| Scenario | Location | Tool | Example |
|----------|----------|------|---------|
| Need Hindsight API docs | `./.agents/skills/hindsight-docs/` | `npx skills list` | "How do I use hindsight.retain()?" |
| Create team-specific knowledge | `./.github/agents/skills/` | Copy SKILL-TEMPLATE.md | "Document our auth patterns" |
| Keep reusable patterns | `./.github/agents/skills/` | Manual creation | "Store CLI modes skill" |
| Find existing skills | Either location | Metadata search | Agent discovery via keywords |

## Moving or Reorganizing Skills

### External Skills (./.agents/skills/)
**Rule**: Do NOT move manually. Let `npx skills` manage entirely.

If you need to reorganize external skills:
1. Uninstall via `npx skills remove <skill-name>`
2. Reinstall via `npx skills add <source>`

This ensures package manager metadata stays consistent.

### Custom Skills (./.github/agents/skills/)
**Rule**: Safe to reorganize if you maintain metadata consistency.

Before moving:
- [ ] SKILL.md `name` field matches folder name
- [ ] All relative links within skill still work
- [ ] Update cross-references in agent discovery rules
- [ ] Test that agents can still find skill via metadata

Example safe move:
```bash
# Before: .github/agents/skills/cli-modes-skill/SKILL.md
# After: .github/agents/skills/orchestration/cli-modes-skill/SKILL.md
# This is OK as long as metadata stays consistent
```

Example unsafe move:
```bash
# Before: .agents/skills/hindsight-docs/
# After: .github/agents/skills/hindsight-docs/
# This breaks npx skills update mechanism—DON'T DO THIS
```

## Creating a New Custom Skill

To create a new custom skill for your workspace:

1. **Copy the template**:
   ```bash
   cp .github/agents/skills/SKILL-TEMPLATE.md .github/agents/skills/my-skill/SKILL.md
   ```

2. **Fill in metadata** (YAML frontmatter):
   - name (human-readable)
   - description (1-2 sentences)
   - keywords (agent search terms)
   - audience (which agents benefit)
   - prerequisites (required knowledge)
   - difficulty (beginner/intermediate/advanced)
   - tags (categorical)
   - version (semantic)

3. **Write skill content** (7 sections):
   - Overview (what the skill teaches)
   - Entry Points (different ways to navigate)
   - Core Concepts (essential knowledge)
   - How to Use (practical guidance)
   - Common Patterns (composition examples)
   - Reference (lookup details)
   - See Also (links to guides/research)

4. **Follow size guidelines**:
   - Minimum: 500 words
   - Optimal: 1,500-2,500 words
   - If >3,000: consider splitting into multiple skills

5. **Test discoverability**:
   - Agents search by keywords. Do your keywords match how agents would ask?
   - Ben searches by role. Does audience field cover intended users?
   - Users search by metadata. Is everything filled in?

See **.github/agents/skills/README.md** for complete design checklist and best practices.

## Guidelines for Skill Management

### Do's ✅
- ✅ Create custom skills for workspace-specific knowledge
- ✅ Use SKILL-TEMPLATE.md as foundation for new skills
- ✅ Keep metadata consistent (name field matches folder)
- ✅ Link from skills to guides/research (don't duplicate)
- ✅ Test that agents can find skills via keywords
- ✅ Document new skills in .github/agents/skills/README.md
- ✅ Update this file when skills change

### Don'ts ❌
- ❌ Don't manually edit files in ./.agents/skills/ (let npx manage)
- ❌ Don't move external skills between directories
- ❌ Don't create skills >3,000 words (split instead)
- ❌ Don't duplicate content (link to guides instead)
- ❌ Don't leave metadata incomplete (agents won't find it)
- ❌ Don't forget to update agent discovery rules

## Related Documentation

- **Creating Skills**: See [[Skill Name]](SKILL-TEMPLATE.md)
- **Skills Library Index**: See [Agent Skills Library](<./README.md>)
- **Agent Routing**: See [.github/copilot-instructions.md](../copilot-instructions.md)
- **Research on Skills**: See [Agent Skills Best Practices & Design Patterns](<../../../docs/research/agentic-workflows/agent-skills-best-practices.md>)

---

Last updated: March 31, 2026
