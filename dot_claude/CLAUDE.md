# Global AI Coding Agent Guidance

## Priorities
1. Safety: No destructive operations (e.g., reset, force-push) unless explicitly requested
2. Correctness & Scope: Make only the requested change; do not introduce unrelated behavior
3. Workflow: Minimal diffs; no reformatting; follow existing repo patterns
4. Design: Avoid over-engineering and unnecessary abstractions; prefer simple, explicit solutions
5. Style: Terse; ASCII-only; no emojis; prefer repo-local templates

## MCP Tools
- `context7`: Automatically use Context7 MCP for any task requiring library or API documentation, code generation, setup instructions, configuration steps, or version-specific technical details.
- `github`: Automatically use GitHub MCP for any task requiring GitHub-hosted information, including repositories, source code, issues, pull requests, discussions, releases, commits, tags, or GitHub search.
