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
    inputs.impermanence.nixosModules.impermanence
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
  ];

  #
  # Nix settings
  #
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    # Make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    channel.enable = false;
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      experimental-features = ["nix-command" "flakes" "ca-derivations"];
      auto-optimise-store = true;
      flake-registry = "";
      use-xdg-base-directories = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
    };
  };

  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

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

  zramSwap.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

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

  # use nftables for firewall
  networking = {
    nftables.enable = true;
  };

  # Persistence
  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/systemd/coredump"
      "/var/lib/iwd"
      "/var/lib/nixos"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  modules = {
    hardware = ["redist" "bluetooth" "audio" "ppd"];
    presets = {
      wayland.enable = true;
      podman.enable = true;
      iwd.enable = true;
      fonts.enable = true;
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

  #
  # Services and Packages
  #

  services = {
    flatpak.enable = true;
    # Use dbus broker as the dbus implementation, this comes with the caveat of
    # a lot of ignored "..." file errors, which are apparantly harmless.
    dbus.implementation = "broker";
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
