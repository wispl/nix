{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.packages;
in {
  imports = [./cli.nix ./dev.nix];
  # options.modules.packages = {
  # 	extras = mk
  #
  # 	};
  # };
}
