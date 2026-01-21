---
description: Remove AI code slop from the current branch
context: fork
disable-model-invocation: true
model: sonnet
---

# Remove AI Code Slop

Remove all AI-generated slop introduced in this branch compared to base.

## Scope

- Identify and remove AI-generated code patterns
- Edit files to clean up slop
- DO NOT commit changes (user commits after)
- DO NOT push or create PRs
- Focus only on cleanup

## Instructions

1. **Analyze branch changes**:
   - Get base: `git rev-parse --abbrev-ref origin/HEAD` (or assume main/master)
   - Commits: `git log --oneline <base>..HEAD`
   - Files: `git diff <base>...HEAD --stat`
   - Full diff: `git diff <base>...HEAD`

2. **Identify and remove slop**:

   Look for and remove:

   - **Excessive comments**: Comments that a human wouldn't add or are inconsistent with the rest of the file
   - **Over-defensive code**: Extra defensive checks or try/catch blocks abnormal for that area (especially in trusted/validated codepaths)
   - **Type hacks**: Casts to `any` to bypass type issues
   - **Style inconsistencies**: Code that doesn't match the file's existing style
   - **Unnecessary emojis**: Emoji usage in code/comments
   - **Verbose error messages**: Overly detailed error messages inconsistent with the codebase
   - **Redundant validation**: Input validation in internal functions that receive already-validated data
   - **Over-engineering**: Abstractions, helpers, or patterns for one-time use
   - **Backwards-compat hacks**: Unused `_vars`, re-exports, `// removed` comments when code is actually deleted

3. **Execute cleanup**:
   - Use Edit tool to remove identified slop from each file
   - Keep changes minimal and focused on removing slop
   - Preserve all legitimate functionality

4. **Verify changes**:
   - Review the diff: `git diff`
   - Run tests if available to verify nothing broke

## Output

Display 1-3 sentence summary of what slop was removed and which files were affected.

## Constraints

- NEVER commit changes automatically
- NEVER push or create PRs
- Only edit files - let user review and commit
- Preserve all legitimate functionality

## Examples of Slop

**Excessive comments**:
```typescript
// Bad - AI slop
// This function calculates the total by iterating through items
// and summing up their prices. It handles edge cases like null
// and undefined values gracefully.
function calculateTotal(items) { ... }

// Good - matches codebase style (no comment or minimal)
function calculateTotal(items) { ... }
```

**Over-defensive code**:
```typescript
// Bad - AI slop in internal function
function processValidatedUser(user) {
  if (!user) throw new Error('User is required');
  if (!user.id) throw new Error('User ID is required');
  if (typeof user.id !== 'string') throw new Error('User ID must be string');
  // ... actual logic
}

// Good - user already validated by caller
function processValidatedUser(user) {
  // ... actual logic
}
```

**Type hacks**:
```typescript
// Bad - AI slop
const result = (data as any).property;

// Good - fix the type properly
interface Data {
  property: string;
}
const result = (data as Data).property;
```
