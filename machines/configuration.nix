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
  ];

  #
  # Nix settings
  #
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = ["/etc/nix/path"];
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      experimental-features = ["nix-command" "flakes" "ca-derivations"];
      auto-optimise-store = true;
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

  zramSwap.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

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
    # TODO: see if we need pkgs.openocd
    udev.packages = [pkgs.platformio-core.udev];
  };

  # We still need dbus even if using dbus-broker, something about dbus references
  environment.systemPackages = with pkgs; [vim dbus];

  fonts.packages = with pkgs; [
    wqy_zenhei
    dejavu_fonts
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.symbols-only
    julia-mono
    fantasque-sans-mono
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr];
    config = {
      common = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
        "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
      };
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
    users.wisp = import ../home/home.nix;
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
