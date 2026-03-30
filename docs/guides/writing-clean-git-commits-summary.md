# Writing Clean Git Commit Messages: Summary

**Source**: "Writing Clean Git Commit Messages: Lessons From My Own Messy History" by Mathews Jose, Level Up Coding

---

## Main Thesis

Git isn't just a version control tool—**it's a communication tool**. Commit messages are a code's journal entries that tell the story of how a project grew, improved, and occasionally fell apart. Writing clean commit messages is an act of empathy toward teammates, open-source contributors, and your future self. A meaningful Git history serves as a breadcrumb trail of intent, not just a trash can of poorly named alterations.

---

## Core Philosophy & Key Takeaways

### Why Clean Commit Messages Matter

The author learned this painfully through experience. When first reviewing their own Git logs, they were horrifying—filled with unhelpful messages like "fix stuff," "update again," and "final-final-version (really this time)."

**Clean commit messages serve multiple critical purposes:**

1. **Understanding Intent** — The "what" is visible in the code; the commit message explains the "why"
2. **Collaboration** — Teammates don't have to read diffs to guess intent
3. **Debugging** — Ability to trace bugs through meaningful history when knee-deep in Git blame
4. **Automation** — Tools like `semantic-release` and `commitlint` rely on structured commit messages
5. **Long-term Value** — Your Git history will always be there, even when code changes and docs rot

**Key Insight**: Think of your Git history as a project diary or autobiography, not a trash can.

---

## The Commit Message Structure (The Formula)

The standard structure follows the Conventional Commits pattern:

```
<type>: <short summary>
<optional body>
<optional footer>
```

### 1. The Type

Describes what kind of change was made. Following the Conventional Commits standard ensures consistency and automation compatibility.

| Type | Meaning |
|------|---------|
| `feat` | A new feature |
| `fix` | A bug fix |
| `docs` | Documentation only |
| `style` | Formatting changes (no logic changes) |
| `refactor` | Code restructuring without behavior change |
| `test` | Adding or updating tests |
| `chore` | Maintenance tasks, dependency updates, etc. |

**Example**: `feat: add user profile page`

### 2. The Short Summary (Subject Line)

The subject line is your headline—it should tell the story at a glance.

**Golden Rules:**
- Use **imperative mood** — say "add," "fix," "update," not "added," "fixed," "updated"
- Keep it **under 50 characters**
- **Don't end with a period**
- Avoid filler words like "update" or "stuff"
- Be specific enough that someone reading it in a list of 1,000 commits will understand what happened

**Valid Examples:**
- ✅ `fix: handle login button click on mobile`
- ✅ `feat: add user profile page`
- ✅ `refactor: extract database config into separate module`

**Invalid Examples:**
- ❌ `fixed the issue where login button didn't work`
- ❌ `update`
- ❌ `update files`
- ❌ `fix bug`

**Why Imperative Mood?** It reads naturally as a command: "Git, please add, fix, or refactor this." Git output like "Apply patch" or "Merge branch" flows beautifully with imperative messages.

### 3. The Body (Optional, But Valuable)

This is where you explain **why** you made the change. The "what" is visible in the code; the "why" belongs in the body.

**When to write the body:**
- If you spent more than five minutes thinking about a change, the body is worth writing
- For complex changes or non-obvious decisions
- For refactors with design decisions or side effects

**Guidelines:**
- Explain why, not just what
- Wrap text at around 72 characters per line
- Mention design decisions, side effects, or limitations
- This becomes "pure gold" when debugging six months later

**Example:**
```
fix: resolve race condition in user session handling

The session middleware was being initialized twice due to concurrent
API requests. Added a mutex to ensure session consistency across
parallel calls.
```

### 4. The Footer (Optional)

The footer provides extra context—issue references, breaking changes, or links. Makes issue tracking and changelog generation seamless.

**Example:**
```
feat: implement new payment gateway integration

Closes #142
BREAKING CHANGE: The old PaymentService class has been replaced
by PaymentGatewayService.
```

---

## Real-Life Example: Before vs. After

### Before (Poor):
```
update files
```

### After (Excellent):
```
refactor: extract database config into separate module

Moved database connection settings from app.js to config/db.js to
improve maintainability and support future database migrations.
```

**The Difference**: The second message tells a complete story—what happened and why—with zero guesswork required.

---

## Best Practices for Writing Clean Commits

### 1. Commit Small, Commit Often

Each commit should represent **one logical change**. This makes it easier to review, revert, and understand.

**Bad:**
```
feat: add login, fix navbar, update footer
```

**Good:**
```
feat: add login feature
fix: correct navbar alignment
chore: update footer links
```

**Benefit**: Small, atomic commits are your best debugging insurance policy. You can isolate and revert changes precisely.

### 2. Keep the Subject Short But Descriptive

Avoid filler words like "update" or "fix bug." Be specific about what changed.

**Test yourself**: "If someone only reads this subject line in a list of 1,000 commits, will they understand what happened?"

If the answer is no, rewrite it.

### 3. Use the Body When It Adds Value

A commit message isn't a tweet—it's okay to explain your reasoning, especially for:
- Complex changes
- Non-obvious refactors
- Database migrations
- Design decisions with side effects

Your future self will silently thank you when trying to remember why you made that change.

### 4. Reference Issues Clearly

Always link related tickets, issues, or tasks. It ties code to context and connects the dots for reviewers.

**Example:**
```
fix: correct validation logic for user age (fixes #217)
```

### 5. Clean Up Before You Merge

Don't let working-in-progress commits contaminate your main branch.

**Messy commits to avoid:**
```
wip
fix again
okay really final
final-final
```

**Solution**: Before merging to `main`, squash or rebase these into meaningful commits. Your teammates and your Git history will appreciate it.

---

## Automation: Enforce Cleanliness Without Relying on Discipline

You don't have to rely on discipline alone. Several tools can enforce commit hygiene automatically:

### Tools for Commit Quality

1. **commitlint** — Checks commit message formatting to ensure they follow Conventional Commits
2. **husky** — Runs Git hooks before commits to enforce policies
3. **semantic-release** — Automates changelogs and versioning based on commit types

### Example Husky Hook

```bash
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"
npx commitlint --edit $1
```

**Benefit**: With these in place, your team's commit messages stay clean—even on Monday mornings.

---

## Common Anti-Patterns to Avoid

Based on the author's own messy history, avoid these commit messages:

| Anti-Pattern | Problem |
|--------------|---------|
| `fix stuff` | Vague—doesn't tell you what was fixed |
| `update` | Too generic—doesn't specify what was updated |
| `final version` | Suggests uncertainty (if it was final, why another?) |
| `final-final-version (really this time)` | Chaotic—shows loss of control |
| `ok now it works` | Unprofessional—doesn't explain what was broken |
| `update again` | Lacks purpose—doesn't explain why again |
| Multiple unrelated changes in one commit | Makes history impossible to navigate and revert |

**Core Problem**: These messages provide no "breadcrumb trail of intent" for future debugging or understanding.

---

## The Philosophy Behind It All

Writing good commits isn't about bureaucracy or process police—**it's about empathy for:**

- **Your teammates**, who review your code
- **Your future self**, who will debug your code six months later
- **Your tools**, which rely on consistent messages to automate workflows
- **Open-source contributors**, who need to understand the project's evolution

**Central Principle**: A clean Git history tells the story of your project's growth—one meaningful commit at a time. It's your project's autobiography.

---

## The TL;DR — The Commit Message Formula

```
<type>: <short summary>
<why/what explanation>
<references or breaking changes>
```

### Quick Example:

```
refactor: simplify authentication middleware

Removed redundant session checks and unified token validation
across endpoints.

Closes #98
```

### The One Simple Rule to Live By

**"If someone reads this commit six months from now, will they understand it?"**

If the answer is yes, you're already ahead of many developers.

---

## Takeaway

Clean commits are small acts of craftsmanship. They take seconds to write, but their value compounds for years. Every time you replace a "fix stuff" with a clear, thoughtful message, you make your project—and yourself—a little more professional.

You don't have to nail this on day one. Just start with that one simple rule, and gradually improve. Small commitments to commit hygiene lead to professional, readable, and maintainable projects.
