---
description: Create a detailed pull request with structured title and body
agent: build
subtask: true
---

Create a GitHub pull request for the current branch's changes against the default branch.

## User Context

$ARGUMENTS

## Instructions

1. **Gather context**: Run these commands to understand the changes:
   - `git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'` to get the default branch
   - `git log --oneline <default-branch>..HEAD` to see commits on this branch
   - `git diff <default-branch>...HEAD --stat` to see files changed
   - `git diff <default-branch>...HEAD` to see the actual changes

2. **Identify the scope**: Determine which component(s) or area(s) the changes relate to:
   - Look at file paths and changes to understand the scope
   - Common scopes: api, cli, config, docs, ui, core, tests, ci, build
   - Use the most specific scope that captures the changes

3. **Create the PR title**: Use conventional commit format: `type(scope): description`
   - **Type**: feat, fix, docs, style, refactor, test, chore, perf, ci, build
   - **Scope**: Component or area affected (optional but recommended)
   - **Description**: Short description under 50 characters
   - Use imperative mood (add, fix, update, remove)
   - Examples:
     - `feat(api): add user authentication endpoint`
     - `fix(cli): resolve crash on invalid input`
     - `docs: update installation guide`
     - `refactor(core): simplify error handling logic`

4. **Write the PR body**:
   - Start with 1-2 sentences explaining **WHY** this PR exists (the motivation/context)
   - Follow with a short bulleted list of major changes (< 6-7 words per line)
   - Do NOT include headers like "## Summary" or "## Changes"
   - Do NOT include a line-by-line play-by-play of every file changed
   - Do NOT include verbose explanations or implementation details
   - Keep the entire body under 10 lines

5. **Create the PR**: Use `gh pr create` with the title and body:
   ```bash
   gh pr create --title "type(scope): short description" --body "body content"
   ```

## Example PR Body

```
Adds support for WebSocket connections to enable real-time data streaming in the API.

- Add WebSocket handler middleware
- Update connection manager with WS support
- Add reconnection logic with exponential backoff
- Fix memory leak in connection cleanup
```

## Output

Show the PR URL when complete.
