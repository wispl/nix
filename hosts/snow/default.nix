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
     127.0.0.1    ldap.localhost.edu
     127.0.0.1    saml.localhost.edu
     127.0.0.1    admin.localhost.edu
     127.0.0.1    idp.localhost.edu
  '';

  zramSwap.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

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

  services.resolved.enable = true; # Default DNS resolver for iwd, alternative is pure resolveconf
  networking = {
    # use nftables for firewall
    nftables.enable = true;
    # Enables wireless support via iwd.
    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          EnableNetworkConfiguration = true;
          # network address randomization seems to cause problems sometimes.
          AddressRandomization = "once";
          AddressRandomizationRange = "nic";
        };
      };
    };
    dhcpcd.enable = false; # Use iwd's builtin dhcp client
  };

  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
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

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.swaylock = {};
    pam.loginLimits = [
      {
        domain = "@users";
        item = "rtprio";
        type = "-";
        value = 1;
      }
    ];
  };

  #
  # Services and Packages
  #
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services = {
    flatpak.enable = true;
    fwupd.enable = true;
    power-profiles-daemon.enable = true;
    # Use dbus broker as the dbus implementation, this comes with the caveat of
    # a lot of ignored "..." file errors, which are apparantly harmless.
    dbus.implementation = "broker";
  };

  environment.systemPackages = with pkgs; [vim];

  fonts.packages = with pkgs; [
    wqy_zenhei # good enough cjk coverage
    dejavu_fonts # good overall coverage
    nerd-fonts.fantasque-sans-mono # programming font of choice
    nerd-fonts.symbols-only # not sure why I have this?
    julia-mono # extensive math coverage
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # we can set this for now since we only one portal
    config.common.default = "*";
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
