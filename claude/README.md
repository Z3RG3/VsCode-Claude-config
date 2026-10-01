# Claude Code (`~/.claude/`)

| File | Role |
|---|---|
| `CLAUDE.md` | Global instructions, loaded into every session |
| `settings.json` | Model, effort, theme, **hook registration**, enabled plugins, plugin marketplaces |
| `hooks/jira-ticket-context.sh` | `SessionStart` hook: reads the ticket key from the git branch and tells Claude to fetch it. Needs `jq` (built into macOS) |
| `hooks/install-commit-prefix-hook.sh` | Not a Claude hook: a helper that installs a git `prepare-commit-msg` hook into a repo, prefixing commits with the branch's ticket key |

How it fits together:
- **A hook only runs if `settings.json` registers it.** Copying `hooks/` alone does nothing.
- **Skills come from plugins** (`enabledPlugins` + `extraKnownMarketplaces`) and download on first start. `skills/synced/` is managed by claude.ai, so don't version it.
- **Not versioned:** `projects/*/memory/`, which is personal and per-project. It's a candidate for a private repo later.

## Fill in on restore
The repo copies are sanitised, so don't copy them into `~/.claude/` as they are:
- `<domain>` in `CLAUDE.md` and `hooks/jira-ticket-context.sh` → your Atlassian site
- `default` profile in `CLAUDE.md` → your Databricks profile name, if it isn't `DEFAULT`
