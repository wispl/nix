{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    # ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
  ];

  modules = {
    username = "wisp";
    profile = "server";
    hardware = ["redist"];
    persist = {
      enable = true;
      directories = [
        "/var/lib/iwd" # save network configurations
        "/var/lib/incus/" # prevent incus from blowing up
      ];
    };
    presets = {
      iwd.enable = true;
    };
    packages.extras = with pkgs; [vim];
  };

  # disko
  disko.devices = {
    disk.main = {
      device = "<placeholder>";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            name = "ESP";
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077" "noexec" "nosuid" "nodev"];
            };
          };
          nix = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/nix";
              mountOptions = ["defaults"];
            };
          };
        };
      };
    };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=2G"
        "defaults"
        "mode=755"
        "noexec"
      ];
    };
  };

  # incus
  user.users.wisp.extraGroups = ["incus-admin"];
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
  };
  virtualisation.incus.preseed = {
    networks = [
      {
        config = {
          "ipv4.address" = "10.0.100.1/24";
          "ipv4.nat" = "true";
        };
        name = "incusbr0";
        type = "bridge";
      }
    ];
    profiles = [
      {
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
        name = "default";
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

  #incus bootstrap script
  # home.packages = with pkgs; [
  #   (writeShellScriptBin "incus-deploy" ''
  #   '')
  # ];
}
