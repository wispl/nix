# Gate to all the modules, this has the very important, crucially
# important task of setting up users (singular), setting nix options,
# and importing all modules into scope for use. There will be nix...
{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption filterAttrs isType mapAttrs mapAttrs' mapAttrsToList;
  inherit (lib.types) str;
in {
  imports = [./home.nix ./dbus.nix ./system ./packages ./desktop ./config];

  options.user = {
    name = mkOption {
      type = str;
      description = "Name of user";
    };
  };

  config = {
    assertions = [
      {
        assertion = config.user ? name;
        message = "config.user.name is not set!";
      }
    ];

    # Create user
    users.mutableUsers = false;
    # TODO: automate this somehow, for now manually create the file, do not forget to change permissions!
    users.users.${config.user.name} = {
      # initialPassword = "password";
      hashedPasswordFile = "/nix/persist/passwords/${config.user.name}";
      isNormalUser = true;
      extraGroups = ["wheel"]; # Enable 'sudo' for the user.
    };

    # Nice nix settings
    nix = let
      flakeInputs = filterAttrs (_: isType "flake") inputs;
    in {
      # Make flake registry and nix path match flake inputs
      registry = mapAttrs (_: flake: {inherit flake;}) flakeInputs;
      nixPath = mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      channel.enable = false;
      optimise.automatic = true;
      settings = {
        trusted-users = [
          "root"
          "@wheel"
        ];
        experimental-features = ["nix-command" "flakes" "ca-derivations"];
        flake-registry = "";
        use-xdg-base-directories = true;
      };
    };

    nixpkgs.config.allowUnfree = true;

    environment.etc =
      mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

    boot = {
      # Use the systemd-boot EFI boot loader.
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      loader.systemd-boot.configurationLimit = lib.mkDefault 10;
      loader.systemd-boot.editor = lib.mkDefault false;

      bcache.enable = false;
      tmp.useTmpfs = true;
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
  };
}
