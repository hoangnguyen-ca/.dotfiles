# Shared Codex configuration

`config.toml` contains portable model and WSL desktop preferences. Authentication,
local sessions, caches, logs, databases, managed plugins, system skills, project
trust entries, and machine-specific MCP executable paths are excluded.

No global `AGENTS.md` or custom skills existed when this configuration was added.
To version them later, add `.codex/AGENTS.md` or a custom skill directory containing
`SKILL.md` under `.codex/skills/`. Review all files for secrets before committing.

## Install

From the repository root:

```bash
bash scripts/codex.sh
```

The main bootstrap also runs this script. It links individual files and custom
skill directories into `${CODEX_HOME:-$HOME/.codex}`. Existing destinations are
moved into adjacent, uniquely named `.backup.*` directories before linking.
Rerunning leaves matching links alone. Authentication and other local state are
left in place. Removing a tracked skill does not automatically remove its link.

Installing the shared config replaces the active config with a symlink; existing
machine-specific settings remain in the backup rather than being merged. Restore
needed MCP configuration locally after installation, taking care not to commit
machine paths or secrets. Codex settings changes may modify the linked file in
this repository. Review diffs before committing.

Merely adding these files to the repository does not change the active Codex
configuration. Restart Codex after installing to ensure the settings are loaded.
