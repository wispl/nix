{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkEnableOption mkMerge mkIf;
  inherit (lib.types) str;
  cfg = config.modules.desktop.term;
in {
  options.modules.desktop.term = {
    default = mkOption {
      type = str;
      description = "default terminal to use";
    };
    foot.enable = mkEnableOption "foot";
  };

  config = mkMerge [
    (mkIf (cfg.default != "") {
      home.environment.sessionVariables.TERMINAL = cfg.default;
    })

    (mkIf cfg.foot.enable {
      home.packages = [pkgs.foot];
      home.files.".config/foot/foot.ini" = {
        generator = lib.generators.toINI {};
        value = {
          main = {
            font = "FantasqueSansM Nerd Font Mono:size=20,Julia Mono:size=18";
            pad = "40x40center";
          };
          colors = {
            alpha = "0.99";
            foreground = "${config.colors.fg}";
            background = "${config.colors.bg}";

            selection-foreground = "${config.colors.selectedFg}";
            selection-background = "${config.colors.selectedBg}";

            regular0 = "${config.colors.black}";
            regular1 = "${config.colors.red}";
            regular2 = "${config.colors.green}";
            regular3 = "${config.colors.yellow}";
            regular4 = "${config.colors.blue}";
            regular5 = "${config.colors.magenta}";
            regular6 = "${config.colors.cyan}";
            regular7 = "${config.colors.white}";

            bright0 = "${config.colors.brightBlack}";
            bright1 = "${config.colors.brightRed}";
            bright2 = "${config.colors.brightGreen}";
            bright3 = "${config.colors.brightYellow}";
            bright4 = "${config.colors.brightBlue}";
            bright5 = "${config.colors.brightMagenta}";
            bright6 = "${config.colors.brightCyan}";
            bright7 = "${config.colors.brightWhite}";

            "16" = "${config.colors.extraColor1}";
            "17" = "${config.colors.extraColor2}";
          };
          tweak = {
            box-drawing-base-thickness = 0.06;
          };
        };
      };
    })
  ];
}
