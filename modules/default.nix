{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption filterAttrs isType mapAttrs mapAttrs' mapAttrsToList;
  inherit (lib.types) str;
in {
  imports = [./home.nix ./system ./packages ./desktop ./config];

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
      extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    };

    # Nice nix settings
    nix = let
      flakeInputs = filterAttrs (_: isType "flake") inputs;
    in {
      # Make flake registry and nix path match flake inputs
      registry = mapAttrs (_: flake: {inherit flake;}) flakeInputs;
      nixPath = mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
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
    };

    environment.etc =
      mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;
  };
}
