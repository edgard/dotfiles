---
description: Commit changes and create a pull request
agent: build
subtask: true
---

Commit all changes and create a pull request following Conventional Commits format.

The commit message and PR title should follow Conventional Commits:
- Format: type(scope): description
- Common types: feat, fix, docs, style, refactor, test, chore
- Example: "feat(api): add user authentication endpoint"
- Focus on WHY rather than WHAT

The PR summary should be comprehensive and based on ALL commits in the branch, not just the latest commit.

Use `gh pr create` to create the pull request.
