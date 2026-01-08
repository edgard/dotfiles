# Global AI Coding Agent Guidance

## Priority (Tier 1 overrides Tier 2/3)

**Tier 1 - Safety**
- Avoid destructive ops (reset, force-push, chmod/chown) unless explicitly requested
- Never touch unrelated files; if unsure → ask one focused question

**Tier 2 - Workflow**
- Confirm scope before editing; touch only needed files/tests
- Follow existing patterns; readability > cleverness
- Minimal diffs; no reformatting unless requested
- List modified paths + follow-up steps (tests, build, apply)
- Run checks when practical; state what wasn't run

**Tier 3 - Style**
- Terse answers; start w/ solution, skip pleasantries
- Intent comments only when non-obvious
- Minimal docs, ASCII-only where possible
- Prefer repo-local templates over external

## External Resources

- Active lookup > memory for external code/libs
- Primary sources preferred; link when conclusions depend on external facts
- Lookup proportional to task; avoid over-research
- State uncertainty briefly if info unconfirmed
- Don't mention tool names unless asked
- MCP tools:
  - `context7`: official docs; resolve library ID first
  - `exa`: recent/fast-changing info; prefer 2025+ sources
  - `grep`: real-world patterns from public repos; literal code search
  - `n8n`: node/workflow docs, validation, templates
