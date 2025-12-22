> [!Warning]
> Still learning and trying out nix

# NixOS Configuration

Flake configuration for my system.

## System

Highlights are mainly:

- btrfs with lzo compression
- zram
- impermanence
- root on tmpfs, `/home` and `/nix` on btrfs subvolumes
- LUKS encryption
- home-manager

Other minor changes are

- dbus-broker instead of regular dbus
- systemd in initrd stage 1
- iwd and resolved for networking
- nftables instead iptables for firewall

## Setup

These notes are for me, yes me. Note that the `sector-size=4096` is not always
available. There is also a [risk](https://wiki.archlinux.org/title/Dm-crypt/Specialties#Discard/TRIM_support_for_solid_state_drives_(SSD)) with TRIM regarding encrypted SSD drives.

1. luks encryption with `--sector-size=4096 --perf-no_read_workqueue --allow-discards` see [this](https://www.reddit.com/r/Fedora/comments/rzvhyg/default_luks_encryption_settings_on_fedora_can_be/)
2. create two partitions, `/boot` and `/`
3. format `boot` with fat32
4. format `/` with btrfs and [lzo compression](https://gist.github.com/braindevices/fde49c6a8f6b9aaf563fb977562aafec) and `noatime`
5. create subvolumes for `/nix` and `/home`
6. no swap since zram is used
7. continue as usual with nix flake installation

The root directory is then mounted on tmpfs while `/nix` and `/home` are on
persistent subvolumes (this means enough memory should be available).

> [!Warning]
> Passwords are done using a password file stored under
> `/nix/persist/passwords/<username>` and have to be manually created and
> edited! Enter `mkpasswd -m help` to see a list of encryption methods.

> [!Important]
> Symlinks are used for neovim config and scripts, set the environmental
> variable `FLAKE` to point to the root flake directory.

## Todo

- Since btrfs has `discard=async` enabled by default since 6.2, should fstrim be disabled?
- Decide if autofragment (use autodefrag? maybe not) and scrub should be enabled.
- Set [battery thresholds](https://github.com/teleshoes/tpacpi-bat) for thinkpads?
    - often discharge < 20%: start charging at 95%, stop charging at 100%
    - between 50% and 100%: start charging at 75%, stop charging at 80%
    - mostly on AC: start charging at 45%, stop charging at 50%
    - echo values to /sys/class/power_supply/BAT0/charge_control_{start,end}_threshold
    - these might reset on reboot so a systemd service might be a good idea
- Set stricter umask?
- Configure swappiness?
- `kernel.unprivileged_userns_clone=1`?
- `kernel.kexec_load_disabled = 1`?

## References

https://github.com/hlissner/dotfiles
