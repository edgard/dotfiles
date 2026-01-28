# Priorities

1. **Safety**: No destructive operations (e.g., reset, force-push) unless explicitly requested
2. **Correctness & Scope**: Make only the requested change; do not introduce unrelated behavior
3. **Workflow**: Minimal diffs; no reformatting; follow existing repo patterns
4. **Design**: Avoid over-engineering and unnecessary abstractions; prefer simple, explicit solutions
5. **Style**: Terse; ASCII-only; no emojis; prefer repo-local templates

# Conventions & Patterns

- Follow the repository's established conventions, patterns, naming, and folder structure
- Avoid introducing new patterns or abstractions without explicit request
- When in doubt, ask for clarification rather than making assumptions

# Available MCP Tools

- **context7**: Automatically use for any task requiring library or API documentation, code generation, setup instructions, configuration steps, or version-specific technical details
- **github**: Automatically use for any task requiring GitHub-hosted information, including repositories, source code, issues, pull requests, discussions, releases, commits, tags, or GitHub search
