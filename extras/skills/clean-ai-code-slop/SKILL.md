---
name: clean-ai-code-slop
description: Remove AI-generated code slop from the current Git branch with minimal, targeted diffs. Use when a user asks to clean up AI-generated code issues, remove over-engineered or low-signal patterns, align style with the repository, and preserve legitimate behavior without committing or pushing.
---

# Clean AI Code Slop

Remove low-signal AI-generated patterns from branch changes while preserving intended behavior and repository conventions.

## Priorities

1. Safety: no destructive operations unless explicitly requested.
2. Style: terse, ASCII-only, no emojis, prefer repository-local templates.
3. Workflow: minimal diffs, no broad reformatting, follow existing patterns.
4. Minimalism: avoid over-engineering and unnecessary abstractions.

## Scope

- Analyze branch changes against base.
- Remove AI-generated slop in changed files.
- Keep changes tightly scoped to cleanup.
- Do not commit, push, or open PRs.
- Preserve legitimate functionality.

## Workflow

1. Analyze branch changes.
- Resolve base branch from `origin/HEAD` when available: `git rev-parse --abbrev-ref origin/HEAD`.
- If unavailable, use a sensible default base (`main`, then `master`).
- Inspect commits: `git log --oneline <base>..HEAD`.
- Inspect changed files: `git diff <base>...HEAD --stat`.
- Inspect full patch: `git diff <base>...HEAD`.

2. Identify and remove slop.
- Excessive comments: remove comments that restate obvious code or conflict with file style.
- Over-defensive code: remove redundant guards and try/catch blocks in trusted internal paths.
- Type hacks: remove `any` casts used to bypass type errors; use concrete types.
- Style inconsistencies: align naming, control flow, and error style with nearby code.
- Emoji and novelty text: remove from code and comments.
- Verbose errors: trim over-detailed messages that do not match repository patterns.
- Redundant validation: remove duplicate validation in already-validated paths.
- Over-engineering: inline one-off abstractions/helpers that do not improve reuse.
- Backward-compat clutter: remove stale `_vars`, no-op re-exports, and "removed" comments after deletion.
- General cleanup: remove dead code, unused imports, and speculative branches.

3. Execute cleanup edits.
- Edit only files in scope unless user expands scope.
- Keep interfaces and behavior stable unless user asks for functional changes.
- Prefer deleting noise over introducing new abstractions.

4. Verify.
- Review final diff with `git diff`.
- Run focused tests/checks for affected areas when available.
- Report any unrun or unavailable validation.

5. Report results.
- Return a 1-3 sentence summary listing which slop categories were removed and which files changed.
- Call out remaining risks or deferred cleanup.

## Hard Constraints

- Never commit changes automatically.
- Never push or create PRs.
- Never use destructive Git operations unless explicitly requested.
