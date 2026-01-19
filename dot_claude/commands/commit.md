---
description: Create well-formatted commits with conventional commit format
---

# Smart Git Commit

Create a well-formatted commit following the Conventional Commits specification.

## Arguments

$ARGUMENTS

## Instructions

1. **Check repository state**:
   - Run `git status --porcelain` to see what's staged/unstaged
   - Run `git diff --cached --stat` to see staged changes
   - Run `git diff --stat` to see unstaged changes
   - Run `git log --oneline -5` to see recent commit style

2. **Stage files if needed**:
   - If no files are staged and $ARGUMENTS doesn't specify files, ask which files to stage
   - Use `git add` to stage the appropriate files

3. **Review changes**:
   - Run `git diff --cached` to see the full diff of staged changes
   - Analyze the changes to understand what's being committed

4. **Determine commit type**:
   - Multiple distinct logical changes? Suggest splitting into separate commits
   - Single logical change? Proceed with one commit

5. **Create commit message** following Conventional Commits format:
   ```
   <type>[optional scope]: <description>

   [optional body]

   [optional footer(s)]
   ```

   **Types**:
   - `feat`: New feature
   - `fix`: Bug fix
   - `docs`: Documentation changes
   - `style`: Code style (formatting, missing semicolons, etc)
   - `refactor`: Code restructuring without behavior change
   - `perf`: Performance improvements
   - `test`: Adding or updating tests
   - `chore`: Build process, dependencies, tooling
   - `ci`: CI/CD changes
   - `build`: Build system changes

   **Scope**: Component or area affected (optional but recommended)

   **Description**: Short summary in imperative mood, lowercase, no period

6. **Create the commit**:
   - Use `git commit -m` with the message
   - Include `Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>` in body if meaningful changes

7. **Verify**:
   - Run `git log -1` to show the created commit
   - Run `git status` to confirm clean state

## Best Practices

- Keep the first line under 50 characters
- Wrap body at 72 characters
- Use imperative mood: "add" not "added" or "adds"
- Focus on WHY, not WHAT (the diff shows what changed)
- Reference issues/PRs in footer: `Fixes #123` or `Refs #456`
- For breaking changes, use `BREAKING CHANGE:` footer or ! after type

## Examples

```
feat(api): add user authentication endpoint

Implements JWT-based authentication with refresh tokens.

Refs: #234
```

```
fix(cli): resolve crash on invalid input

Adds input validation before processing to prevent null pointer exception.

Fixes #567
```

```
docs: update installation guide
```

## Important Notes

- Pre-commit hooks will run automatically - do NOT skip them
- If hooks fail, fix the issues and create a NEW commit (don't amend unless explicitly requested)
- Never use `--no-verify` or similar flags unless explicitly requested
