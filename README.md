> [!Warning]
> Still learning and trying out nix

# NixOS Configuration

Flake configuration for my system.

## System

- btrfs with lzo compression
- zram
- impermanence
- root on tmpfs, home on btrfs subvolume
- luks encryption
