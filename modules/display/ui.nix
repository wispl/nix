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
    eww.enable = mkEnableOption "eww";
    quickshell.enable = mkEnableOption "quickshell";
    mako.enable = mkEnableOption "mako";
  };

  config = mkMerge [
    # launcher
    (mkIf cfg.fuzzel.enable {
      home.packages = [pkgs.fuzzel];
      home.xdg.config.files."fuzzel/fuzzel.ini" = {
        generator = lib.generators.toINI {};
        value = {
          main = {
            font = "monospace, Symbols Nerd Font:size=12";
            prompt = "' '";
            icons-enabled = false;
            line-height = 20;
            inner-pad = 10;
            horizontal-pad = 40;
            vertical-pad = 20;
          };
          border = {
            radius = 16;
            width = 8;
            selection-radius = 4;
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

    # gtk based widget system
    (mkIf cfg.eww.enable {
      home.packages = with pkgs; [inotify-tools mpc eww];
      home.xdg.config.files."eww".source = ../../config/eww;
    })

    # qtquick based widget system
    (mkIf cfg.quickshell.enable {
      home.packages = with pkgs; [quickshell];
      services.upower.enable = true;
      home.xdg.config.files."quickshell".source = ../../config/quickshell;
    })

    # simple notification daemon
    (mkIf cfg.mako.enable {
      # Notification daemon
      # mako starts itself when it receives a notification so there is no need to
      # make a service file.
      home.packages = [pkgs.dbus];
      dbus.packages = [pkgs.mako];
      home.xdg.config.files."mako/config".text = ''
        font=DejaVu Sans Mono 16
        outer-margin=8
        border-size=8
        border-radius=4
        icons=true
        padding=10
        default-timeout=3000
        width=400
        height=300

        text-color=#${config.colors.fg}
        background-color=#${config.colors.bg}
        border-color=#${config.colors.bgDD}
        progress-color=over #${config.colors.yellow}

        [urgency=high]
        border-color=#${config.colors.red}
        default-timeout=0
      '';
    })
  ];
}
