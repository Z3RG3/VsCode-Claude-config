# VsCode-Claude-config
For easy setup my currently used config, it's structure and some draft (-> knowledge) files for easier setup next time.

macOS (Apple Silicon), bash, VS Code (no other IDEs), Claude Code, Databricks.

## What's here and where it lives

| Repo path | Lives at | What it is |
|---|---|---|
| `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` | VS Code user settings ([details](vscode/README.md)) |
| `vscode/extensions/*.txt` | installed with the `code` CLI | Extensions grouped by purpose |
| `vscode/templates/databricks-project/.vscode/` | `<project>/.vscode/` | Per-project settings for Databricks `.py` notebooks |
| `claude/` | `~/.claude/` | Claude Code instructions, settings, hooks ([details](claude/README.md)) |
| `git/gitconfig.template` | `~/.gitconfig` | Fill in name and email, don't commit the real file |
| `git/gitignore_global` | `~/.gitignore_global` | Global ignores |
| `shell/bash_profile` | `~/.bash_profile` | PATH for Homebrew and `~/.local/bin` (uv, Claude CLI) |
| `brew/Brewfile` | — | CLI tools and apps, installed with `brew bundle` |
| `databricks/databrickscfg.template` | `~/.databrickscfg` | Reference only: `databricks auth login` writes the real file |

## Fresh machine: restore order

1. **Homebrew:** install from https://brew.sh, then `brew bundle --file=brew/Brewfile`.
2. **Shell and git:** copy `shell/bash_profile` to `~/.bash_profile` and `git/gitignore_global` to `~/.gitignore_global`. Create `~/.gitconfig` from the template.
3. **VS Code:** install it from https://code.visualstudio.com (not via brew), then run *Shell Command: Install 'code' command in PATH* from the command palette. Copy `vscode/settings.json` into place and install the extension groups you need:
   ```bash
   cat vscode/extensions/{ai,python,databricks,dev}.txt | xargs -n1 code --install-extension
   ```
4. **uv:** `curl -LsSf https://astral.sh/uv/install.sh | sh` (the standalone installer, into `~/.local/bin`), then `uv python install 3.12`.
5. **Claude Code:** install the VS Code extension (in `ai.txt`), then restore `~/.claude/` from `claude/`. Plugins download on first start from `enabledPlugins` in `settings.json`.
6. **Databricks:** `databricks auth login --host <workspace-url> --profile <name>`, then add `cluster_id` to that profile by hand ([template](databricks/databrickscfg.template)). In each project, run `databricks environments setup-local` to get a matching `.venv`.

## Never commit
- `~/.databrickscfg`, `~/.databricks/` (tokens), `~/.ssh/`
- `~/.claude/` runtime state: `history.jsonl`, `sessions/`, `projects/` (transcripts and memory), `cache/`, `plugins/`, `file-history/`, `telemetry/`
- Real work email, internal hostnames, company IDs: this repo is public
