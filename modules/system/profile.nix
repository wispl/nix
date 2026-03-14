# Profiles for the machine, or whether I think the machine is a workstation or
# server. Workstation comes with barely anything. The server, runs a hardened
# kernel and also comes with incus for running containers and virtual machines.
{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkMerge mkOption mkDefault;
  inherit (lib.types) str;
  cfg = config.modules.profile;
in {
  options.modules.profile = mkOption {
    type = str;
    description = "The profile for this machine, either workstation or server";
  };

  config = mkMerge [
    (mkIf (cfg == "workstation") {
      boot = {
        # Enable systemd for initrd stage 1, might need further tweaks on some systems
        initrd.systemd.enable = true;

        kernelParams = ["quiet" "splash" "nowatchdog"];
        kernelPackages = pkgs.linuxPackages_latest;
        kernel.sysctl = {
          "net.ipv4.ip_unprivileged_port_start" = 0;
        };
      };
    })

    (mkIf (cfg == "server") {
      boot = {
        # Use lts hardened kernel cause why not
        kernelPackages = pkgs.linuxPackages_6_12_hardened;
      };

      # TODO: more server hardening
      # TODO: maybe these should be defaults?
      nix.allowedUsers = ["@wheel"];
      security.sudo.execWheelOnly = true;

      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };

      # incus
      users.users.${config.user.name}.extraGroups = ["incus-admin"];
      networking.firewall.interfaces.incusbr0.allowedTCPPorts = [53 67];
      networking.firewall.interfaces.incusbr0.allowedUDPPorts = [53 67];
      virtualisation.incus = {
        enable = true;
        ui.enable = true;
        package = pkgs.incus;
      };
      virtualisation.incus.preseed = {
        config = {
          "core.https_address" = ":8443";
          "core.metrics_address" = ":8444";
        };
        networks = [
          {
            config = {
              "ipv4.address" = "10.0.100.1/24";
              "ipv6.address" = "none";
              "ipv4.nat" = "true";
            };
            name = "incusbr0";
            type = "bridge";
          }
        ];
        profiles = [
          {
            name = "default";
            devices = {
              eth0 = {
                name = "eth0";
                network = "incusbr0";
                type = "nic";
              };
              root = {
                path = "/";
                pool = "default";
                type = "disk";
              };
            };
          }
        ];
        storage_pools = [
          {
            config = {
              source = "/var/lib/incus/storage-pools/default";
            };
            driver = "dir";
            name = "default";
          }
        ];
      };

      # TODO: most of these are not actually used, remove?
      # 80, 443: for accessing the server normally
      # 8443 8444: for incus
      # 22054: DNS
      networking.firewall.allowedTCPPorts = [80 22054 443 8443 8444];
      networking.nftables.tables = {
        nat = {
          content = ''
            chain prerouting {
              type nat hook prerouting priority -100; policy accept;
              ip daddr 10.0.0.121 tcp dport { 22054 } dnat to 10.0.100.50:53
              ip daddr 10.0.0.121 tcp dport { 80 } dnat to 10.0.100.50:80
              ip daddr 10.0.0.121 tcp dport { 443 } dnat to 10.0.100.50:443
            }
          '';
          family = "ip";
        };
      };
    })
  ];
}
