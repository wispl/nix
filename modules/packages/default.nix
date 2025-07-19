{config, ...}: let
  cfg = config.modules.packages;
in {
  imports = [./apps.nix ./tui.nix ./dev.nix ./cli.nix ./colors.nix ./theme.nix];
  # options.modules.packages = {
  # 	extras = mk
  #
  # 	};
  # };
}
