{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) filterAttrs isType mapAttrs mapAttrs' mapAttrsToList;
in {
  imports = [./system];

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
}
