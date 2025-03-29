{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.apps;
in {
  options.modules.apps = {
    blender.enable = mkEnableOption "blender";
    inkscape.enable = mkEnableOption "inkscape";
    keepassxc.enable = mkEnableOption "keepassxc";
    syncthing.enable = mkEnableOption "syncthing";
    openconnect.enable = mkEnableOption "openconnect";
    renderdoc.enable = mkEnableOption "renderdoc";
    firefox.enable = mkEnableOption "firefox";
    qemu.enable = mkEnableOption "qemu";
    sioyek.enable = mkEnableOption "sioyek";
  };

  config = mkMerge [
    # TODO: better method?
    (mkIf cfg.blender.enable {home.packages = [pkgs.blender];})
    (mkIf cfg.inkscape.enable {home.packages = [pkgs.inkscape];})
    (mkIf cfg.keepassxc.enable {home.packages = [pkgs.keepassxc];})
    (mkIf cfg.syncthing.enable {home.packages = [pkgs.syncthing];})
    (mkIf cfg.openconnect.enable {home.packages = [pkgs.openconnect];})
    (mkIf cfg.renderdoc.enable {home.packages = [pkgs.renderdoc];})
    (mkIf cfg.qemu.enable {home.packages = [pkgs.qemu];})

    (mkIf cfg.firefox.enable {
      programs.firefox = {
        enable = true;
        profiles = {
          default = {
            id = 0;
            name = "default";
            isDefault = true;
            userChrome = builtins.readFile ./userChrome.css;
          };
          spare = {
            id = 1;
            name = "spare";
          };
        };
      };
    })

    (mkIf cfg.sioyek.enable {
      xdg.mimeApps.defaultApplications = {
        "application/pdf" = ["sioyek.desktop"];
      };

      programs.sioyek = {
        enable = true;
        bindings = {
          # use embedded file picker by default, it is much faster
          "open_document_embedded" = "o";
          "screen_down" = "<C-f>";
          "screen_up" = "<C-b>";
          "close_window" = "q";
        };
        config = {
          "should_launch_new_window" = "1";
          "startup_commands" = "toggle_dark_mode 1";
          "collapsed_toc" = "1";

          "status_bar_font_size" = "18";
          "font_size" = "24";

          "text_highlight_color" = "#${config.colors.yellow}";
          "search_highlight_color" = "#${config.colors.yellow}";
          "link_highlight_color" = "#${config.colors.blue}";
          "synctex_highlight_color" = "#${config.colors.green}";

          "status_bar_color" = "#${config.colors.bgL}";
          "status_bar_text_color" = "#${config.colors.fg}";

          "dark_mode_background_color" = "#${config.colors.bg}";

          "ui_text_color" = "#${config.colors.fg}";
          "ui_background_color" = "#${config.colors.bg}";
          "ui_selected_text_color" = "#${config.colors.bg}";
          "ui_selected_background_color" = "#${config.colors.yellow}";
        };
      };
    })
  ];
}
