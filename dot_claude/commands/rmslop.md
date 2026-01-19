---
description: Remove AI code slop from the current branch
---

# Remove AI Code Slop

Check the diff against the default branch and remove all AI-generated slop introduced in this branch.

## Arguments

$ARGUMENTS

## Instructions

1. **Gather context**:
   - Get default branch: `git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'`
   - See commits: `git log --oneline <default-branch>..HEAD`
   - See files changed: `git diff <default-branch>...HEAD --stat`
   - Get full diff: `git diff <default-branch>...HEAD`

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
   - Review the diff to ensure nothing important was removed
   - Run tests if available to verify nothing broke

## Output

Report at the end with a 1-3 sentence summary of what you changed.

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
