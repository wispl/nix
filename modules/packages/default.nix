{
  lib,
  config,
  ...
}: let
  cfg = config.modules.packages;
in {
  imports = [./apps.nix ./tui.nix ./dev.nix ./shell.nix];
  options.modules.packages = {
    extras = lib.mkOption {
      type = with lib.types; listOf package;
      default = [];
      description = "extra package to install";
    };
  };
  config = {
    home.packages = cfg.extras;
  };
}
