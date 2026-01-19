---
description: Remove AI code slop
---

Check the diff against the default branch and remove all AI generated slop introduced in this branch.

## User Context

$ARGUMENTS

## Instructions

1. **Gather context**: Run these commands to understand the changes:
   - `git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'` to get the default branch
   - `git log --oneline <default-branch>..HEAD` to see commits on this branch
   - `git diff <default-branch>...HEAD --stat` to see files changed
   - `git diff <default-branch>...HEAD` to see the actual changes

2. **Execute cleanup**: Check the diff against that branch and remove slop.
  - Extra comments that a human wouldn't add or is inconsistent with the rest of the file
  - Extra defensive checks or try/catch blocks that are abnormal for that area of the codebase (especially if called by trusted / validated codepaths)
  - Casts to any to get around type issues
  - Any other style that is inconsistent with the file
  - Unnecessary emoji usage

## Output

Report at the end with only a 1-3 sentence summary of what you changed.
