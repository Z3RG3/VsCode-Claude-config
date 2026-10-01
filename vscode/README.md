# VS Code

## Extensions

Install a group: `xargs -n1 code --install-extension < vscode/extensions/<group>.txt`.
Export what's installed now: `code --list-extensions`.

| Group | Extension | Why |
|---|---|---|
| `ai` | `anthropic.claude-code` | Claude Code in the editor panel |
| `python` | `ms-python.python` | Python. Also installs Pylance, debugpy and Python Environments |
| `python` | `ms-toolsai.jupyter` | Notebooks and the interactive window. Also installs keymap, renderers, cell tags and slideshow |
| `databricks` | `databricks.databricks` | Workspace sync, run on cluster, Databricks Connect, bundles |
| `databricks` | `camilesing.hive-sql-helper` | Provides the `spark-sql` language. **`settings.json` depends on it** (`files.associations`, colour scopes) |
| `databricks` | `lucien-martijn.parquet-visualizer` | Opens `.parquet` files as tables |
| `dev` | `redhat.vscode-yaml` | YAML schema validation (`databricks.yml`, CI files) |
| `dev` | `ms-azuretools.vscode-containers`, `ms-azuretools.vscode-docker` | Docker/containers |
| `dev` | `ms-vscode-remote.remote-containers` | Dev Containers |
| `dev` | `github.codespaces` | GitHub Codespaces |
| `dev` | `4ops.terraform` | Terraform syntax |

## User settings (`settings.json`)

| Setting | Effect |
|---|---|
| `security.workspace.trust.untrustedFiles: open` | Opens loose files without the trust prompt |
| `workbench.secondarySideBar.defaultVisibility: hidden` | Right-hand sidebar starts closed |
| `diffEditor.renderSideBySide: false` | Diffs inline instead of split |
| `git.autofetch`, `git.confirmSync: false` | Background fetch, sync without a confirmation |
| `redhat.telemetry.enabled: false` | YAML extension telemetry off |
| `claudeCode.preferredLocation: panel` | Claude opens in the bottom panel |
| `claudeCode.hideOnboarding` | Skips the Claude onboarding screen |
| `files.associations` `*.sql → spark-sql` | Spark SQL highlighting for every `.sql` file |
| `editor.tokenColorCustomizations` | Colours Spark SQL keywords like the default SQL theme |

Left out on purpose: `databricks.lastActiveConnection` (machine state), and empty keys.

## Per-project template: `templates/databricks-project/.vscode/settings.json`

Copy it into a Databricks repo's `.vscode/`. It makes `# COMMAND ----------` (the separator in Databricks `.py` notebooks) a cell marker, so *Run Cell* works in the interactive window.

**Settings Sync:** VS Code's built-in sync covers the same files. Use either sync or this repo as the source of truth, not both, or they will overwrite each other.
