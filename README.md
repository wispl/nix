> [!Warning]
> Still learning and trying out nix

# NixOS Configuration

Flake configuration for my system.

## System

Highlights are mainly:

- btrfs with lzo compression
- zram
- impermanence
- root on tmpfs, `/home` and `/nix` on btrfs subvolume
- LUKS encryption

Other minor changes are

- dbus-broker instead of regular dbus
- configuration using home-manager
- iwd and resolved for networking
- nftables instead iptables for firewall

## Setup

These notes are for me.

- create two partitions, `/boot` and `/`
- format `boot` with fat32
- format `/` with btrfs
- create subvolumes for `/nix` and `/home`
- continue as usual with nix flake installation

> [!Warning]
> Passwords are done using a password file stored under
> `/nix/persist/passwords/<username>` and have to be manually created and
> edited! Enter `mkpasswd -m help` to see a list of encryption methods.

> [!Important]
> Symlinks are used for neovim config and scripts, set the environmental
> variable `FLAKE` to point to the root flake directory.
