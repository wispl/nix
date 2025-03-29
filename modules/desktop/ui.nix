{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.desktop.ui;
in {
  options.modules.desktop.ui = {
    # launcher
    fuzzel.enable = mkEnableOption "fuzzel";
  };

  config = mkMerge [
    (mkIf cfg.fuzzel.enable {
      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            font = "monospace, Symbols Nerd Font:size=12";
            prompt = "' '";
            # until I find a good icon theme
            icons-enabled = false;
            line-height = 20;
            inner-pad = 40;
            horizontal-pad = 80;
            vertical-pad = 40;
          };
          border = {
            radius = 0;
            width = 6;
          };
          colors = {
            prompt = "${config.colors.yellow}ff";
            placeholder = "${config.colors.fg}90";
            background = "${config.colors.bg}ff";
            text = "${config.colors.fg}ff";
            match = "${config.colors.red}ff";
            selection = "${config.colors.magenta}ff";
            selection-text = "${config.colors.bg}ff";
            counter = "${config.colors.magenta}ff";
            border = "${config.colors.bgL}ff";
          };
        };
      };
    })
  ];
}
