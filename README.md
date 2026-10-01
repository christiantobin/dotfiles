# dotfiles (Omarchy, MacBookPro16,1 / T2)

Personal config for an [Omarchy](https://omarchy.org) install (Arch + Hyprland) on a
2019 MacBook Pro. This is the `omarchy` branch. The older Arch/dwm-style setup lives on
`master`, and the USB install notes and T2 `/etc` backups live on
`omarchy-usb-install-guide`.

The repo is a **bare repository** at `~/.dotfiles` with `$HOME` as its work tree, so files
sit in their real locations. Only files that were explicitly added are tracked.

## What's here

| Path | What |
|---|---|
| `.config/hypr/*.lua` | Hyprland overrides on top of Omarchy defaults: bindings, input, look and feel, monitors |
| `.config/hypr/macmode.lua` | Mac-style Cmd shortcuts (Cmd is `ALT` after the Super/Alt swap) |
| `.config/hypr/floatmode.lua` | dwm-style per-workspace float mode (`Super+grave`) |
| `.config/omarchy/shell.json`, `plugins/` | Bar layout and the cloned 6-workspace widget |
| `.config/systemd/user/aether-wallpaper-watch.service` | Recolors the Aether theme when the wallpaper changes |
| `.local/bin/` | `wallpaper-theme`, `aether-wallpaper-watch`, `claude-scratchpad`, `dotsync` |
| `.bashrc` | Aliases on top of Omarchy's shell defaults |
| `.config/dotfiles/pkglist-*.txt` | Installed packages (native and AUR), refreshed by `dotsync` |
| `.claude/skills/dotfiles-sync/` | Claude Code skill so agents know about this repo |

Key choices: Super and Alt are swapped (`altwin:swap_alt_win`), the layout is `master`,
and the phantom `eDP-2` monitor is disabled.

## Everyday use

```bash
dotsync "Describe the change"          # commit tracked changes and push
dotsync -a .config/foo/bar.conf "Add"  # also start tracking a new file
dotfs status                           # git against the bare repo (alias)
```

## Restore on a fresh Omarchy install

```bash
git clone --bare https://github.com/christiantobin/dotfiles.git ~/.dotfiles
alias dotfs='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dotfs config status.showUntrackedFiles no
dotfs checkout omarchy      # if files conflict, move the existing ones aside first
systemctl --user enable --now aether-wallpaper-watch.service
```

Never commit secrets: this repository is public.
