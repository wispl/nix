{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.packages;
in {
  imports = [./cli.nix ./dev.nix ./tui.nix];
  # options.modules.packages = {
  # 	extras = mk
  #
  # 	};
  # };
}
