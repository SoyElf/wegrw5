# Agent Skills Library

Skills are reusable, agent-discoverable units of domain knowledge. Each skill is:
- **Entry point** for learning (not encyclopedia)
- **Navigable** for non-linear reading
- **Metadata-rich** for programmatic discovery
- **Linked** to guides/research for deep learning

## Available Skills

[As skills are added, list them here with short descriptions]

### cli-modes-skill (Coming Soon)
Entry point to CLI mode orchestration patterns, decision frameworks, and safety workflows.
- Status: In redesign
- Estimated read time: 20 minutes
- Keywords: cli-modes, orchestration, delegation, safety

## Creating New Skills

### Before You Start
1. Read [[Skill Name]](SKILL-TEMPLATE.md)
2. Review [docs/research/agent-skills-best-practices.md](../../docs/research/agentic-workflows/agent-skills-best-practices.md) for guidelines
3. Complete the [Skill Design Checklist](<#skill-design-checklist>) before delegating

### Skill Design Checklist

**Metadata (Required)**:
- [ ] `name`: Clear, lowercase with hyphens (not underscores)
- [ ] `description`: One sentence, agent-discoverable keywords
- [ ] `keywords`: 3-5 search terms agents might use
- [ ] `audience`: Who should use this skill?
- [ ] `prerequisites`: What knowledge is assumed?
- [ ] `difficulty`: Beginner/Intermediate/Advanced
- [ ] `version`: Semantic versioning (1.0.0)

**Structure (Required)**:
- [ ] Overview (100-200 words)
- [ ] When to Use (use/skip scenarios)
- [ ] Entry Points (multiple navigation paths)
- [ ] Core Concepts (500-800 words)
- [ ] How to Use (500-1000 words with examples)
- [ ] Common Patterns (300-500 words)
- [ ] See Also (links to guides/research/skills)

**Quality Gates (Required)**:
- [ ] Word count: 1,500-2,500 (use `wc -w`)
- [ ] Markdown passes linting (no syntax errors)
- [ ] No duplication with other skills/guides
- [ ] All links are relative and working
- [ ] Examples are concrete (not hypothetical)
- [ ] Written for agent discovery (searchable keywords)

**Before Submission**:
- [ ] Read the entire skill (does it navigate well?)
- [ ] Try each entry point (can you jump in?)
- [ ] Check word count (1,500-2,500?)
- [ ] Verify metadata (all 8 fields complete?)
- [ ] Test links (all relative paths work?)
- [ ] Confirm no duplication (unique content vs guides?)

## Skill Guidelines

### Size Targets
- **Too short**: <500 words (expand or abandon)
- **Minimal viable**: 500-1,500 words
- **Sweet spot**: 1,500-2,500 words ✅
- **Consider split**: 2,500-3,500 words
- **Too heavy**: >3,500 words (split into multiple skills)

### Content Boundaries
- **IN a skill**: Entry points, navigation, core concepts, quick patterns
- **IN a guide**: Comprehensive learning, sequential narratives, deep dives
- **IN reference**: Lookup tables, checklists, quick commands
- **IN research**: "Why" analysis, synthesis, patterns, evidence

### Discovery & Usage
Skills are found via:
1. Explicit request: "@skill-name"
2. Orchestrator routing: "Use this skill for X"
3. Metadata search: keyword matching
4. Directory enumeration: ls and browse

**This means**: Keywords and "when to use" sections are critical.

## Related Documentation

- **[Agent Skills Best Practices](../../docs/research/agentic-workflows/agent-skills-best-practices.md)** — Research on skill design patterns
- **[[Skill Name]](SKILL-TEMPLATE.md)** — Template for new skills
- **[Guides Directory](../../docs/guides/)** — Learning materials (sequential)
- **[Research Directory](../../docs/research/)** — Technical findings and synthesis

---

**Last Updated**: March 31, 2026  
**Status**: Foundational infrastructure in place
