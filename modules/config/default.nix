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
  inherit (lib) mkOption mkEnableOption mkMerge mkIf;
  inherit (lib.types) str;
  cfg = config.modules;
in {
  imports = [./colors.nix ./theme.nix ./editors.nix ./services.nix];
  options.modules = {
    username = mkOption {
      type = str;
      default = "wisp";
      description = "name of user to create";
    };
    git.enable = mkEnableOption "configure git";
  };

  config = mkMerge [
    (mkIf (cfg.username == "wisp") {
      user.name = "wisp";
      time.timeZone = "America/New_York";
      i18n.defaultLocale = "en_US.UTF-8";
    })

    (mkIf (cfg.username == "wisp" && cfg.git.enable) {
      home.packages = [pkgs.git];
      home.xdg.config.files = {
        "git/config" = {
          generator = (pkgs.formats.gitIni {}).generate "config";
          value = {
            user = {
              name = "wispl";
              email = "wispl.8qbkk@slmail.me";
            };
            alias = {
              lg = "log --graph --oneline --color";
            };
            init.defaultBranch = "main";
            diff.algorithm = "histogram";
            merge.conflictStyle = "zdiff3";
          };
        };
        "git/ignore".text = ''
          .direnv
        '';
      };
    })
  ];
}
