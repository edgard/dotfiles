---
description: Create GitHub pull request from existing commits
context: fork
disable-model-invocation: true
model: haiku
---

# Create Pull Request

Create a GitHub PR for the current branch. Assumes commits already exist.

## Scope

- Create feature branch (if on main/master)
- Push branch and create GitHub PR
- DO NOT create, modify, or amend commits
- DO NOT stage or commit changes
- DO NOT push to main/master directly
- Use gh CLI exclusively

## Instructions

1. **Check current branch**:
   - Get current: `git branch --show-current`
   - Get base: `git rev-parse --abbrev-ref origin/HEAD` (or assume main/master)
   - If on main/master, create feature branch: `git checkout -b <branch-name>`
   - Branch name format: `<type>/<short-desc>` (e.g., `feat/auth-jwt`, `fix/parser-null`)

2. **Analyze ALL commits for PR**:
   - Commits since base: `git log --oneline <base>..HEAD`
   - File stats: `git diff <base>...HEAD --stat`
   - Full diff: `git diff <base>...HEAD`
   - Understand the CUMULATIVE changes across all commits

3. **Determine scope from paths**:
   - Look at changed file paths across ALL commits
   - Common scopes: api, cli, config, docs, ui, core, tests, ci, build
   - Pick most specific scope

4. **Synthesize PR title from all commits**:
   ```
   type(scope): description
   ```
   - Summarize the collective goal/outcome of ALL commits
   - Under 50 chars, imperative mood
   - Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build
   - DO NOT just copy one commit message

5. **Synthesize PR body from all commits**:
   - 1-2 sentences on WHY (motivation for the entire changeset)
   - Bullet list of major changes across ALL commits (6-7 words each)
   - Under 10 lines total
   - No headers, no verbosity
   - DO NOT list individual commits - synthesize the collective impact

   **Example** (multiple commits):
   ```
   Enables real-time updates via WebSocket connections for improved UX.

   - Add WebSocket handler and middleware
   - Update connection manager with WS support
   - Add reconnection with exponential backoff
   - Fix memory leak in cleanup
   ```

6. **Push branch**:
   - Verify current branch: `git branch --show-current`
   - If on main/master: ABORT (should not happen after step 1)
   - Push feature branch: `git push -u origin HEAD`

7. **Create PR**:
   ```bash
   gh pr create --title "type(scope): description" --body "$(cat <<'EOF'
   Motivation sentence here.

   - Bullet point one
   - Bullet point two
   - Bullet point three
   EOF
   )"
   ```

## Output

Display the PR URL to the user.

## Constraints

- NEVER create, modify, or amend commits
- NEVER stage files or change commit messages
- NEVER push directly to main/master branch
- NEVER rewrite git history
- Always create feature branch if on main/master
- Only use gh CLI for PR creation
- Assume all commits are already made and finalized
