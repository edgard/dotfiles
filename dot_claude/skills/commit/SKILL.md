---
description: Create local git commit with conventional format
context: fork
disable-model-invocation: true
model: haiku
---

# Commit Changes

Create a local git commit using Conventional Commits format.

## Scope

- **MUST follow Conventional Commits specification**
- Stage and commit local changes only
- DO NOT push to remote
- DO NOT create pull requests
- DO NOT use gh CLI

## Instructions

1. **Check repository state**:
   - Run `git status` (see staged/unstaged)
   - Run `git log --oneline -10` (see commit style patterns)

2. **Stage files**:
   - If nothing staged: `git add .`
   - Or stage specific: `git add <files>`

3. **Review what's being committed**:
   - Run `git diff --cached --stat` then `git diff --cached`
   - Analyze to understand the changes

4. **Assess if changes should be split**:
   - Multiple unrelated changes? Suggest splitting
   - Single logical change? Proceed

5. **Write Conventional Commit message** (REQUIRED):
   ```
   <type>[optional scope]: <description>

   [optional body]

   [optional footer]
   ```

   **Types** (required):
   - feat, fix, docs, style, refactor, perf, test, chore, ci, build

   **Scope** (recommended):
   - Component/area affected: auth, api, cli, parser, etc.

   **Description** (required):
   - Under 50 chars, imperative mood, lowercase, no period

   **Body** (optional):
   - Wrap at 72 chars, explain WHY not WHAT

   **Footer** (optional):
   - `Fixes #123` or `Refs #456` or `BREAKING CHANGE:`

6. **Execute commit**:
   - Single line: `git commit -m "type(scope): description"`
   - Multiline: Use heredoc:
     ```bash
     git commit -m "$(cat <<'EOF'
     type(scope): description

     Body explaining why.
     EOF
     )"
     ```
   - Pre-commit hooks run automatically
   - If hooks fail, fix issues and create NEW commit

7. **Verify and display**:
   - Run `git log -1 --oneline`
   - Run `git status` to confirm clean state

## Output

Display the commit result to user with format: `<sha> <message>`

## Examples

```
feat(auth): add JWT token validation

Implements token expiry and signature verification.
```

```
fix(parser): handle null values correctly
```

## Constraints

- Never use `--no-verify` unless explicitly requested
- Never use `--amend` unless explicitly requested
- Never push after committing
- Stay local only
