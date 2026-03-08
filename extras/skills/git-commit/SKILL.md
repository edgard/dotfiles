---
name: git-commit
description: Create Git commits using Conventional Commits v1.0.0 with messages that explain why the change is needed, not a file-by-file change log. Use when asked to git commit, write a commit message, or amend a commit message.
---

# Git Commit

Create high-signal commit messages and execute commits using Conventional Commits.

## Workflow

1. Inspect commit scope.
- Run `git status --short`.
- Run `git diff --staged --stat` and `git diff --staged`.
- If nothing is staged, stop and ask whether to stage files first.

2. Identify rationale before writing.
- Derive the problem, intent, or risk reduction from the conversation and staged diff.
- If rationale is ambiguous, ask one focused question before committing.
- Never invent motivation.

3. Choose Conventional Commit header.
- Format: `<type>[optional scope][!]: <summary>`.
- Prefer these types: `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `build`, `ci`, `chore`, `revert`.
- Keep summary concise and outcome-focused.
- Avoid restating file operations in the summary.

4. Write commit body focused on why.
- Add a body unless the rationale is obvious and already explicit in the subject.
- Lead with motivation, constraint, or user impact.
- Include relevant context and tradeoff notes.
- Keep implementation detail minimal; include only details needed to justify decisions.

5. Add required footers when applicable.
- Use `BREAKING CHANGE: ...` when behavior or contracts change.
- Add issue references when available (for example `Refs: #123`).

6. Execute and verify.
- Commit with separate subject/body, for example:
  - `git commit -m "<type(scope): summary>" -m "<body paragraphs>"`
- Verify with `git show --stat --format=fuller -1`.

## Message Quality Rules

- Prioritize why over what changed.
- Do not produce a diff summary as the body.
- Do not use vague subjects like "update" or "fix stuff".
- Keep subject preferably under 72 characters.
- Match tense and tone used in existing repository history.
