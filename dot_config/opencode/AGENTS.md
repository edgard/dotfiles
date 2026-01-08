# Global AI Coding Agent Guidance

## Communication & Safety
- **Avoid destructive actions** (resets, force pushes, chmod/chown) unless explicitly requested; never touch unrelated files. If unsure, ask one focused question.
- **Keep answers terse and practical;** start with the solution. Skip pleasantries.

## Code & Workflow
- **Confirm scope before editing;** locate related files/tests and touch only what's needed.
- **Follow existing patterns;** prioritize readability and maintainability over cleverness.
- **Prefer minimal diffs;** avoid reformatting or style-only changes unless requested.
- **Add concise intent comments** only when the code is non-obvious.
- **Keep documentation minimal** and ASCII-only where possible.
- **Always list modified file paths** and any necessary follow-up steps (tests, build, apply).
- **Run relevant checks** when practical; otherwise state what was not run.
- **Prefer repo-local templates/snippets** over external ones.

## External Resources & Tools
- **Prefer active lookup over memory** when dealing with external code or libraries.
- **Prefer primary sources** and link them when conclusions depend on external facts.
- **Keep lookup proportional to the task;** avoid over-research for straightforward questions.
- **State the uncertainty briefly** if reliable or current information cannot be confirmed.
- **Do not mention tool names** in the final answer unless explicitly asked.
- **Use the following MCP tools** when appropriate:
  - `context7`: official library/framework docs; resolve the library ID first.
  - `exa`: recent or fast-changing info; prefer authoritative sources (2025+).
  - `grep`: real-world usage patterns from public repos; search for literal code.
  - `n8n`: node/workflow docs, validation, or template-based changes.
