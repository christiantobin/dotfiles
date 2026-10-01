# T2 Mac system-level config backup (pre-Omarchy migration)

Snapshot taken 2026-09-30, before wiping this MacBookPro16,1 to install Omarchy.
These are root-owned files that live outside $HOME, so the bare dotfiles repo
(work-tree=$HOME) never tracked them. Restoring requires sudo + copying each
file back to its real path shown by the directory structure below.

Hardware: MacBookPro16,1 — Intel UHD 630 (iGPU) + AMD Navi 14 Radeon Pro
5300M/5500M (dGPU) + Apple T2 bridge/SEP.

## What's here and why

- etc/modprobe.d/amdgpu-blacklist.conf, apple-gmux.conf, hdmi-audio-blacklist.conf
  — blacklist amdgpu + force_igd=y. This is THE fix for the exact hybrid-graphics
  bug Omarchy users hit on 2019 MBPs (post-login black screen/fans/shutdown).
  If omarchy-t2's "GPU toggling" layer doesn't handle it, drop these back in.
- etc/systemd/system/dgpu-d3hot.service, t2-modules-suspend.service
  + usr/lib/systemd/system-sleep/dgpu-d3hot
  — keeps the dGPU resettable across suspend (hard-off breaks resume on this
  machine; see hypr dotfiles commit history for the full story).
- usr/local/bin/tiny-dfr — Touch Bar driver binary (may be unneeded if Omarchy's
  T2 kernel bundles Touch Bar support directly, per their manual).
- usr/local/bin/dgpu-poweroff.sh — DISABLED, kept for reference only (broke suspend).
- usr/local/bin/track-printer-ip, etc/pacman.d/hooks/pkglist.hook — unrelated QoL.
- boot/loader/entries/*.conf — reference only for the kernel cmdline that was
  needed under vanilla Arch (mem_sleep_default=deep, intel_iommu=on, iommu=pt,
  pcie_ports=compat, pm_async=off, i915.enable_guc=2, modprobe.blacklist=amdgpu,
  brcmfmac.feature_disable=0x82000 for wifi). Omarchy's own T2 kernel may already
  set most of these; don't blindly copy, compare first.
- etc/pacman.conf — reference only.

## Migration context
Going to Omarchy with its own defaults (not porting the custom Hyprland/dwm-style
setup). Omarchy 3.0.0+ supports T2 out of the box; community package `omarchy-t2`
(AUR, github.com/marashiai/omarchy-t2) explicitly targets MacBookPro16,1 and adds
touchpad palm rejection, ISO keyboard layout, battery ceiling, fan curve, audio DSP,
and GPU toggling compat on top of stock Omarchy.
