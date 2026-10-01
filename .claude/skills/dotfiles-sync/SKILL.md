---
name: dotfiles-sync
description: Use whenever you create, edit, or delete a personal config or dotfile on this machine (Hyprland ~/.config/hypr, ~/.config/omarchy, ~/.bashrc, ~/.local/bin scripts, systemd user units, ~/.claude/skills) or when the user says "back up", "commit my config", or "dotfiles". Explains the bare-repo dotfiles setup and how to commit and push changes with dotsync.
---

# Dotfiles sync

This machine's personal configuration is backed up to the **public** GitHub repo
`christiantobin/dotfiles`, branch **`omarchy`** (the default branch). It is a bare repo at
`~/.dotfiles` with `$HOME` as the work tree, so files live at their real paths. Git
commands use the `dotfs` alias, or explicitly:

```bash
git --git-dir=$HOME/.dotfiles --work-tree=$HOME <command>
```

Only explicitly added files are tracked (`status.showUntrackedFiles` is off). The
`~/README.md` file lists what is tracked.

## When you change config

After you finish a change to a tracked file, or add a new personal config, script or skill:

1. Tell the user it is not backed up yet, or back it up if they asked you to.
2. Back it up with the helper, which commits and pushes:

   ```bash
   dotsync "Short description of the change"
   dotsync -a .config/new/file "Track a new file"   # -a starts tracking a new path
   ```

   `dotsync` stages every changed tracked file, refreshes the package lists in
   `~/.config/dotfiles/`, commits, and pushes `origin omarchy`.
3. Do not push without the user's go-ahead unless they have asked for backups in this
   session. Commit messages end with the usual attribution trailer.

## Rules

- **The repo is public. Never track secrets**: tokens, API keys, `gh`/SSH credentials,
  browser profiles, keyrings, `.env` files. Scan new files before `-a`, for example with
  `grep -niE "token|secret|passw|api[_-]?key|BEGIN .*PRIVATE" <file>`.
- Never track `*.bak*` files (the Hyprland edits leave timestamped backups) or generated
  files such as `~/.config/omarchy/themes/aether/`, `~/.local/state/`, caches, wallpapers.
- Stay on the `omarchy` branch. `master` is the old Arch setup and
  `omarchy-usb-install-guide` holds the install guide. Do not force-push or rewrite them.
- Do not use `git add -A` or `git add .` against the bare repo, because the work tree is the
  whole home directory.
- Hyprland Lua files in `~/.config/hypr/` are validated with `hyprctl reload` then
  `hyprctl configerrors`. Do that before committing.
- Add a new tracked file to the table in `~/README.md` if it is a new category.
