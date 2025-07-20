{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
  ];

  #
  # Boot and System Configuration
  #
  networking.hostName = "snow";
  networking.extraHosts = ''
    127.0.0.1    localhost.edu
     127.0.0.1    api.localhost.edu
     127.0.0.1    cas.localhost.edu
     # 127.0.0.1    ldap.localhost.edu
     127.0.0.1    saml.localhost.edu
     127.0.0.1    admin.localhost.edu
     127.0.0.1    idp.localhost.edu
  '';

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  services.flatpak.enable = true;
  modules = {
    theme = "kanagawa";
    profile = "workstation";
    hardware = ["redist" "bluetooth" "audio" "ppd"];
    persist = {
      enable = true;
      directories = ["/var/lib/iwd"]; # save network configurations
    };
    presets = {
      wayland.enable = true;
      podman.enable = true;
      iwd.enable = true;
      fonts.enable = true;
    };
    desktop = {
      enable = true;
      cursor = {
        package = pkgs.rose-pine-cursor;
        size = 32;
        name = "BreezeX-RosePine-Linux";
      };
      riverwm.enable = true;
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
      };
      tui = {
        lf.enable = true;
        nnn.enable = true;
        ncmpcpp.enable = true;
      };
      dev = {
        cc.enable = true;
        sh.enable = true;
        rust.enable = true;
        tex.enable = true;
      };
      cli = {
        common.enable = true;
        direnv.enable = true;
        scripts.enable = true;
        storage.enable = true;
        media.enable = true;
        system.enable = true;
      };
    };
  };

  #
  # Users and Security
  #
  users.mutableUsers = false;
  # TODO: automate this somehow, for now manually create the file, do not forget to change permissions!
  users.users.wisp = {
    # initialPassword = "password";
    hashedPasswordFile = "/nix/persist/passwords/wisp";
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs outputs;};
    users.wisp = import ./home.nix;
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
