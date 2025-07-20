# Config of the config, bascially the important top level configuration
# options. These should be options which are either commonly set on most of my
# machines, like git, editors or configurations which have sweeping changes,
# like services and color/theme.
{
  config,
  lib,
pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules;
in {
  imports = [./colors.nix ./theme.nix ./editors.nix ./services.nix];
  options.modules = {
    git.enable = mkEnableOption "configure git";
  };

  config = mkIf (config.user.name == "wisp" && cfg.git.enable) {
    home.packages = [pkgs.git];
    home.files.".config/git/config" = {
      generator = (pkgs.formats.gitIni {}).generate "config";
      value = {
	user = {
	  name = "wispl";
	  email = "wispl.8qbkk@slmail.me";
	};
	aliases = {
	  lg = "log --graph --oneline --color";
	};
	init.defaultBranch = "main";
	diff.algorithm = "histogram";
	merge.conflictStyle = "zdiff3";
      };
    };

    home.files.".config/git/ignore".text = ''
      .direnv
    '';
  };
}
