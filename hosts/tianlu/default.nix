{
  lib,
  config,
  pkgs,
  ...
}: {
  modules = {
    username = "wisp";
    profile = "server";
    hardware = ["redist"];
    persist = {
      enable = true;
      directories = ["/var/lib/iwd"]; # save network configurations
    };
    presets = {
      iwd.enable = true;
    };
    packages.extras = with pkgs; [vim];
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
}
