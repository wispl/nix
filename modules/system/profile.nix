# Profiles for the machine, or whether I think the machine is a workstation or
# server. The only difference is I do work on a workstation but even more work
# indirectly on a server.
{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkMerge mkOption;
  inherit (lib.types) str;
  cfg = config.modules.profile;
in {
  options.modules.profile = mkOption {
    type = str;
    description = "The profile for this machine, one of workstation or server";
  };

  config = mkMerge [
    (mkIf (cfg == "workstation") {
      boot = {
        # Enable systemd for initrd stage 1, might need further tweaks on some systems
        initrd.systemd.enable = true;
        # Use the systemd-boot EFI boot loader.
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;

        kernelParams = ["quiet" "splash" "nowatchdog"];
        kernelPackages = pkgs.linuxPackages_latest;
        bcache.enable = false;
        tmp.useTmpfs = true;
        kernel.sysctl = {
          "net.ipv4.ip_unprivileged_port_start" = 0;
        };
      };

      # Swap but on ram, great for btrfs so I don't have to
      # make a swapfile.
      zramSwap.enable = true;

      # Use nftables for firewall, cooler than iptables, iptables is like
      # calling a grapefruit a fruit.
      networking.nftables.enable = true;

      # Use dbus broker as the dbus implementation, this comes with the caveat
      # of a lot of ignored "..." file errors, which are apparently harmless.
      services.dbus.implementation = "broker";
    })

    (mkIf (cfg == "server") {
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
    })
  ];
}
