---
description: Create a detailed pull request with structured title and body
---

# Create Pull Request

Create a GitHub pull request for the current branch's changes.

## Arguments

$ARGUMENTS

## Instructions

1. **Gather context**:
   - Get default branch: `git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'`
   - See commits: `git log --oneline <default-branch>..HEAD`
   - See files changed: `git diff <default-branch>...HEAD --stat`
   - See actual changes: `git diff <default-branch>...HEAD`
   - Check if branch is pushed: `git branch -vv`

2. **Identify scope**:
   - Look at file paths and changes to determine the scope
   - Common scopes: api, cli, config, docs, ui, core, tests, ci, build
   - Use the most specific scope that captures the changes

3. **Create PR title** using conventional commit format:
   ```
   type(scope): description
   ```

   **Format**:
   - Type: feat, fix, docs, style, refactor, test, chore, perf, ci, build
   - Scope: Component or area (optional but recommended)
   - Description: Under 50 chars, imperative mood

   **Examples**:
   - `feat(api): add user authentication endpoint`
   - `fix(cli): resolve crash on invalid input`
   - `docs: update installation guide`
   - `refactor(core): simplify error handling logic`

4. **Write PR body**:
   - Start with 1-2 sentences explaining WHY (motivation/context)
   - Follow with short bulleted list of major changes (6-7 words max per line)
   - Do NOT include headers like "## Summary" or "## Changes"
   - Do NOT include line-by-line file changes
   - Do NOT include verbose explanations
   - Keep entire body under 10 lines

   **Example**:
   ```
   Adds support for WebSocket connections to enable real-time data streaming in the API.

   - Add WebSocket handler middleware
   - Update connection manager with WS support
   - Add reconnection logic with exponential backoff
   - Fix memory leak in connection cleanup
   ```

5. **Push if needed**:
   - If branch isn't pushed: `git push -u origin HEAD`

6. **Create PR**:
   ```bash
   gh pr create --title "type(scope): description" --body "body content here"
   ```

7. **Show result**:
   - Display the PR URL

## Output

Return the PR URL when complete.
