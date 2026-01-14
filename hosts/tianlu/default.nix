{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking.hostName = "tianlu";
  services.openssh.enable = true;
  modules = {
    username = "wisp";
    git.enable = true;
    profile = "server";
    hardware = ["redist"];
    persist = {
      enable = true;
      directories = [
        "/var/lib/iwd" # save network configurations
        "/var/lib/incus/" # prevent incus from blowing up
      ];
      userDirectories = [
        "flakes"
        "services"
      ];
    };
    presets = {
      iwd.enable = true;
    };
    editors = {
      default = "nvim";
      nvim.enable = true;
    };
    packages.extras = with pkgs; [vim alejandra];
  };

  # incus
  users.users.wisp.extraGroups = ["incus-admin"];

  networking.firewall.interfaces.incusbr0.allowedTCPPorts = [53 67];
  networking.firewall.interfaces.incusbr0.allowedUDPPorts = [53 67];
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
    package = pkgs.incus;
  };
  virtualisation.incus.preseed = {
    # this opens incus to outside of the machine, but I kinda don't want to
    # config = {
    #    "core.https_address" = ":8443";
    # };
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

  networking.firewall.allowedTCPPorts = [80 443];
  # services.caddy = {
  # 	enable = true;
  # 	virtualHosts.localhost.extraConfig = ''
  # 		reverse_proxy http://10.0.100.50
  # 	'';
  # };
  #  networking.nftables.tables = {
  #    nat = {
  #      content = ''
  #	chain prerouting {
  #	  type nat hook prerouting priority -100; policy accept;
  #	  ip daddr 10.0.0.121 tcp dport { 80 } dnat to 10.0.100.50:80
  #	  ip daddr 10.0.0.121 tcp dport { 443 } dnat to 10.0.100.50:443
  #	}
  #      '';
  #      family = "ip";
  #    };
  #  };

  #incus bootstrap script
  # home.packages = with pkgs; [
  #   (writeShellScriptBin "incus-deploy" ''
  #   '')
  # ];
  system.stateVersion = "25.11";
}
