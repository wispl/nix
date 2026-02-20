{
  lib,
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
  ];
  # fixes touchscreen
  boot.extraModprobeConfig = "blacklist raydium_i2c_ts";

  networking.hostName = "snow";
  networking.hosts = {
    # 127.0.0.1    ldap.localhost.edu
    "127.0.0.1" = ["localhost.edu" "api.localhost.edu" "cas.localhost.edu" "saml.localhost.edu" "admin.localhost.edu" "idp.localhost.edu"];
  };

  services.flatpak.enable = true;
  services.fwupd.enable = true;
  services.netbird.clients.default = {
    port = 51820;
    name = "netbird";
    interface = "wt0";
    hardened = true;
  };

  # enable openssh, but do not run server by default (I use it ocassionally for scp)
  services.openssh = {
    enable = true;
  };
  systemd.services.sshd.wantedBy = lib.mkForce [];

  modules = {
    username = "wisp";
    theme = "kanagawa";
    git.enable = true;
    profile = "workstation";
    hardware = ["redist" "bluetooth" "audio" "tlp"];
    persist = {
      enable = true;
      directories = [
        "/var/lib/iwd" # save network configurations
        "/var/lib/netbird" # for netbird connections
      ];
    };
    presets = {
      wayland.enable = true;
      podman.enable = true;
      iwd.enable = true;
      fonts.enable = true;
    };
    editors = {
      default = "nvim";
      nvim.enable = true;
      emacs.enable = true;
    };
    services = {
      mpd.enable = true;
      ssh-agent.enable = true;
      psd.enable = true;
    };
    desktop = {
      enable = true;
      cursor = {
        package = pkgs.rose-pine-cursor;
        size = 32;
        name = "BreezeX-RosePine-Linux";
      };
      niri.enable = true;
      term = {
        default = "foot";
        foot.enable = true;
      };
      ui = {
        fuzzel.enable = true;
        eww.enable = true;
      };
    };
    packages = {
      apps = {
        firefox.enable = true;
        sioyek.enable = true;
        openrocket.enable = true;
      };
      tui.nnn.enable = true;
      dev = {
        cc.enable = true;
        sh.enable = true;
        rust.enable = true;
        tex.enable = true;
        java.enable = true;
        kube.enable = true;
        embedded.enable = true;
      };
      shell = {
        bash.enable = true;
        common.enable = true;
        direnv.enable = true;
        scripts.enable = true;
        storage.enable = true;
        media.enable = true;
        system.enable = true;
      };
      extras = with pkgs; [
        alejandra
        blender
        inkscape
        keepassxc
        syncthing
        openconnect
        # renderdoc
        qemu
        podman-compose
        quickshell
        rnote
        freecad
      ];
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
