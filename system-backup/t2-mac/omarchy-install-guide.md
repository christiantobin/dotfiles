# Omarchy USB Installer Guide — MacBookPro16,1 (2019 16", T2, AMD dGPU)

Your hardware: Intel UHD 630 (iGPU) + AMD Radeon Pro 5300M/5500M (Navi 14, dGPU) + Apple T2 chip.
This wipes the whole internal disk — there is currently a leftover macOS APFS data
partition (465GB, `nvme0n1p2`) alongside your Linux install; both get erased. No
dual-boot with macOS afterward. Config is already backed up to
github.com/christiantobin/dotfiles (`system-backup/t2-mac/`).

## 1. What you need
- A USB drive, 8GB or larger (this guide assumes you're using the Lexar 64GB you
  just plugged in) — it will be **completely erased**.
- This Mac, with internet access, to download the ISO and write the USB.
- ~20-30 min for the download + write, then a separate session to actually run
  the installer (that part wipes this machine, so do it only when ready).

## 2. Download the Omarchy ISO
1. Go to https://omarchy.org and find the download/install page, grab the
   latest ISO (and its checksum file, usually `.sha256` or similar, if offered).
2. Verify the download:
   ```
   sha256sum omarchy-*.iso
   ```
   Compare against the checksum published on the site. Don't skip this — a
   corrupted ISO is the #1 cause of installer-boot failures.

## 3. Identify the USB drive — DO NOT SKIP THIS
Internal disk is `/dev/nvme0n1` — never target that. Find the USB's device name:
```
lsblk -o NAME,SIZE,MODEL,TRAN,MOUNTPOINT,FSTYPE,LABEL
```
Look for a `usb` TRAN entry sized ~64G (adjust for actual reported size, often
slightly under 64GB, e.g. 57.3G). It'll show as `/dev/sdX` (X = a letter, e.g.
`sda`). If it doesn't show up at all, unplug/replug, try a different port, and
re-run `lsblk`.

**Triple-check the device name before the next step.** Writing to the wrong
device destroys that disk's data instantly and silently.

## 4. Write the ISO to the USB
Unmount any auto-mounted partitions from the USB first:
```
sudo umount /dev/sdX* 2>/dev/null
```
Then write the ISO (replace `sdX` with what you confirmed in step 3, and the
filename with your actual downloaded ISO):
```
sudo dd if=~/Downloads/omarchy-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
sync
```
This takes several minutes depending on ISO size and USB write speed. Wait for
the prompt to return — don't unplug early. `sync` at the end makes sure every
buffered write actually lands on the drive before you pull it.

## 5. Mac-specific boot prep
Your current Arch install already boots an unsigned `linux-t2` kernel via
systemd-boot, which means Secure Boot / external-media policy on this T2 chip
is almost certainly already set permissively from your original Arch install.
You likely don't need to touch this. If the USB fails to appear in the boot
picker in step 6, then:
1. Shut down fully.
2. Boot holding **Cmd+R** (local Recovery) or **Cmd+Option+R** (internet
   Recovery, if no local Recovery partition remains — likely, since this disk
   is now Linux-formatted).
3. Utilities menu → Startup Security Utility → select your boot disk →
   set security to **"No Security"** and enable **"Allow booting from external
   or removable media."**
4. Restart.

## 6. Boot from the USB installer
1. Shut the Mac down completely (not restart — a cold shutdown is required for
   the Option-key boot picker to appear reliably on T2 Macs).
2. Press the power button, then immediately press and hold **Option (⌥)**.
3. Keep holding until the boot device picker (Startup Manager) appears.
4. Select the USB drive — it'll show as an orange **"EFI Boot"** icon.
5. Press Enter/Return.

## 7. Run the Omarchy installer
1. It'll boot to the Omarchy installer (TUI-based, similar in spirit to
   `archinstall`). Follow the prompts: keyboard layout, timezone, hostname,
   user account + password, disk target.
2. **Disk target: select the internal disk** (will show as `nvme0n1`, ~932GB).
   Confirm the wipe when prompted — this erases the current Linux install and
   the leftover macOS APFS partition both.
3. Let it run through base install + the patched `linux-t2` kernel + bootloader
   setup. It'll prompt to reboot when done — remove the USB when it does.

## 8. First boot — model-specific hardware package
1. Log in, open a terminal, confirm you're on Wi-Fi (Broadcom firmware should
   already work per Omarchy's T2 support).
2. Install the T2-specific tuning package for this exact model
   (MacBookPro16,1 — this package explicitly checks for and refuses to run on
   any other model, so it's safe here):
   ```
   yay -S omarchy-t2      # or paru, whichever AUR helper Omarchy ships with
   omarchy-t2 setup --dry-run   # review the plan first
   omarchy-t2 setup             # apply — touchpad, battery ceiling, fan curve,
                                 # audio DSP, GPU-toggling compat layer
   ```

## 9. If you hit the known AMD dGPU bug
Known Omarchy issue on 2019 MacBook Pros with AMD dGPUs: fans spike, screen
goes black, and it shuts down shortly after login. If this happens:
1. Force a shutdown (hold power ~10s), boot back up.
2. At the systemd-boot/GRUB menu, edit the boot entry to add
   `apple_gmux.force_igd=1` as a one-time boot param and see if it boots clean.
3. If that works, make it permanent, and/or pull the known-good fix files from
   your GitHub backup (`system-backup/t2-mac/etc/modprobe.d/amdgpu-blacklist.conf`
   and `apple-gmux.conf`) and drop them into `/etc/modprobe.d/` on the new
   install, then `sudo mkinitcpio -P` (or Omarchy's equivalent) and reboot.

## 10. Optional: restore small QoL bits
Not required for the "fresh Omarchy defaults" approach, but available in the
GitHub backup if wanted later: `tiny-dfr` (Touch Bar binary, likely unneeded —
Omarchy's T2 kernel has built-in Touch Bar support per their manual),
`track-printer-ip`, and the pacman pkglist hook. All in
`system-backup/t2-mac/usr/local/bin/` and `etc/pacman.d/hooks/` in the repo.
