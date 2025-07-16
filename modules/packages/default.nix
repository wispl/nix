{config, ...}: let
  cfg = config.modules.packages;
in {
  imports = [./cli.nix ./dev.nix ./tui.nix ./apps.nix];
  # options.modules.packages = {
  # 	extras = mk
  #
  # 	};
  # };
}
