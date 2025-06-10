{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.packages;
in {
  imports = [./cli.nix];
  # options.modules.packages = {
  # 	extras = mk
  #
  # 	};
  # };
}
