# Sometimes you just have to use big apps with big tookits like gtk and qt and
# ttt. Maybe not the last one but... this module contains configuration for
# applications. Applications without configuration should just be passed to
# home.packages or something like that.
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.packages.apps;
in {
  options.modules.packages.apps = {
    firefox.enable = lib.mkEnableOption "firefox";
    sioyek.enable = lib.mkEnableOption "sioyek";
  };

  # good browser
  config = lib.mkMerge [
    (lib.mkIf cfg.firefox.enable {
      programs.firefox = {
        enable = true;
        profiles = {
          default = {
            id = 0;
            name = "default";
            isDefault = true;
            userChrome =
              # css
              ''
                              /* Remove window control buttons */
                              .titlebar-buttonbox-container {
                              	display: none !important;
                              }
                              .titlebar-close {
                              	display: none !important;
                              }

                              /* remove one pixel line at top of nav-bar */
                              #nav-bar {
                              	border-top: 1px solid transparent !important;
                              }

                              /* remove outline and shadow around the content when using sidebar */
                              #tabbrowser-tabbox {
                              	outline: none !important;
                              	box-shadow: none !important;
                              }

                /* center letterboxing content */
                :root:not([inDOMFullscreen]) .browserContainer > .browserStack:not(.exclude-letterboxing) {
                              	place-content: center center !important;
                              }
                              /* round letterboxing content */
                :root:not([inDOMFullscreen]) .browserContainer > .browserStack:not(.exclude-letterboxing) > browser {
                              	border-radius: 8px;
                              }
              '';
          };
          spare = {
            id = 1;
            name = "spare";
          };
        };
      };
    })

    # good pdf viewer
    (lib.mkIf cfg.sioyek.enable {
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
