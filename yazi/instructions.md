## Yazi 26.5.6 Setup Summary

### 1. Breaking changes when upgrading

- Remove `"$schema" = "..."` from **all** `.toml` config files (`yazi.toml`, `keymap.toml`, etc.)
- Add `group` field to all `fetchers` entries in `yazi.toml`

---

### 2. Install plugins

```powershell
ya pkg add yazi-rs/plugins:git yazi-rs/plugins:full-border yazi-rs/plugins:jump-to-char yazi-rs/plugins:smart-filter yazi-rs/plugins:diff
```

If any fail to deploy, run:

```powershell
ya pkg install
```

---

### 3. `init.lua`

Create at `%AppData%\yazi\init.lua`:

```lua
require("full-border"):setup()
require("git"):setup()
```

---

### 4. `yazi.toml` — add to `[plugin]`

```toml
prepend_fetchers = [
  { id = "git", group = "git", url = "*",  run = "git" },
  { id = "git", group = "git", url = "*/", run = "git" },
]

fetchers = [
  { id = "mime", group = "mime", url = "*/",         run = "mime.dir",    prio = "high" },
  { id = "mime", group = "mime", url = "local://*",  run = "mime.local",  prio = "high" },
  { id = "mime", group = "mime", url = "remote://*", run = "mime.remote", prio = "high" },
]
```

---

### 5. `keymap.toml` — add to bottom of `[mgr]` keymap

```toml
# Plugins
{ on = "F",     run = "plugin jump-to-char", desc = "Jump to char" },
{ on = "`",     run = "plugin diff",         desc = "Diff selected files" },
{ on = "<A-f>", run = "plugin smart-filter", desc = "Smart filter" },
```

---

### 6. Fix default opener (nvim before vscode)

In `yazi.toml` under `[opener]`, reorder `edit` so nvim is first for windows:

```toml
edit = [
  { run = "${EDITOR:-vi} %s", desc = "$EDITOR", for = "unix", block = true },
  { run = 'nvim %*',          desc = "nvim",    for = "windows", block = true },
  { run = "code %s",          desc = "code",    for = "windows", orphan = true },
  { run = "code -w %s",       desc = "code (block)", for = "windows", block = true },
]
```

---

### Keybind reference

| Key                | Action                        |
| ------------------ | ----------------------------- |
| `F`                | jump-to-char                  |
| `Alt+f`            | smart-filter                  |
| `` ` ``            | diff two selected files       |
| `z`                | fzf fuzzy find                |
| `Z`                | zoxide jump                   |
| `ms` / `mm` / `mo` | linemode size / mtime / owner |
