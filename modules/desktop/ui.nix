{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkMerge mkIf;
  cfg = config.modules.desktop.ui;
in {
  options.modules.desktop.ui = {
    fuzzel.enable = mkEnableOption "fuzzel";
    waybar.enable = mkEnableOption "waybar";
    eww.enable = mkEnableOption "eww";
  };

  config = mkMerge [
    # launcher
    (mkIf cfg.fuzzel.enable {
      home.packages = [pkgs.fuzzel];
      home.files.".config/fuzzel/fuzzel.ini" = {
        generator = lib.generators.toINI {};
        value = {
          main = {
            font = "monospace, Symbols Nerd Font:size=12";
            prompt = "' '";
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

    # only bar
    (mkIf cfg.waybar.enable {
      home.packages = [pkgs.waybar];
      home.files = {
        ".config/waybar/config.jsonc".source = lib.importJSON ../../config/waybar/pills/config.jsonc;
        ".config/waybar/style.css".text = ''
          @define-color fg #${config.colors.fg};

          @define-color bg0 #${config.colors.bgDDD};
          @define-color bg1 #${config.colors.bgDD};
          @define-color bg2 #${config.colors.bgD};
          @define-color bg  #${config.colors.bg};
          @define-color bg4 #${config.colors.bgL};
          @define-color bg5 #${config.colors.bgLL};
          @define-color bg6 #${config.colors.bgLLL};

          @define-color red     #${config.colors.red};
          @define-color green   #${config.colors.green};
          @define-color yellow  #${config.colors.yellow};
          @define-color blue    #${config.colors.blue};
          @define-color magenta #${config.colors.magenta};
          @define-color cyan    #${config.colors.cyan};

          @define-color bright-red     #${config.colors.brightRed};
          @define-color bright-green   #${config.colors.brightGreen};
          @define-color bright-yellow  #${config.colors.brightYellow};
          @define-color bright-blue    #${config.colors.brightBlue};
          @define-color bright-magenta #${config.colors.brightMagenta};
          @define-color bright-cyan    #${config.colors.brightCyan};
                 ${builtins.readFile ../../config/waybar/pills/style.css}
        '';
      };
    })

    # gtk based widget system
    (mkIf cfg.eww.enable {
      home.packages = with pkgs; [inotify-tools mpc eww];
      # TODO: symlink?
      home.files.".config/eww".source = ../../config/eww;
    })
  ];
}
