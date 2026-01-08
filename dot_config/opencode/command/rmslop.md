---
description: Remove AI code slop
---

Check the diff against the default branch and remove all AI generated slop introduced in this branch.

First, detect the default branch:
```bash
git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'
```

Then check the diff against that branch and remove slop.

This includes:

- Extra comments that a human wouldn't add or is inconsistent with the rest of the file
- Extra defensive checks or try/catch blocks that are abnormal for that area of the codebase (especially if called by trusted / validated codepaths)
- Casts to any to get around type issues
- Any other style that is inconsistent with the file
- Unnecessary emoji usage

Report at the end with only a 1-3 sentence summary of what you changed
