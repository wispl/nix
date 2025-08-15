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
  inherit (lib) mkMerge mkIf mkEnableOption;
  cfg = config.modules.packages.apps;
in {
  options.modules.packages.apps = {
    firefox.enable = mkEnableOption "firefox";
    sioyek.enable = mkEnableOption "sioyek";
  };

  # good browser
  config = mkMerge [
    (mkIf cfg.firefox.enable {
      home.packages = [pkgs.firefox];
      home.files = {
        ".mozilla/firefox/profiles.ini".text = ''
          [General]
          StartWithLastProfile=1
          Version=2

          [Profile0]
          Default=1
          IsRelative=1
          Name=default
          Path=default

          [Profile1]
          Default=0
          IsRelative=1
          Name=spare
          Path=spare
        '';
        ".mozilla/firefox/default/chrome/userChrome.css".text =
          #css
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
    })

    # good pdf viewer
    (mkIf cfg.sioyek.enable {
      home.packages = [pkgs.sioyek];
      xdg.mime.defaultApplications = {
        "application/pdf" = ["sioyek.desktop"];
      };
      home.xdg.config.files = {
        "sioyek/prefs_user.config".text = ''
          should_launch_new_window  1
          startup_commands          toggle_dark_mode 1
          collapsed_toc             1

          status_bar_font_size  18;
          font_size             24;

          text_highlight_color     #${config.colors.yellow}
          search_highlight_color   #${config.colors.yellow}
          link_highlight_color     #${config.colors.blue}
          synctex_highlight_color  #${config.colors.green}

          ui_text_color            #${config.colors.fg}
          ui_background_color      #${config.colors.bg}
          ui_selected_text_color   #${config.colors.bg}

          status_bar_color         #${config.colors.bgL}
          status_bar_text_color    #${config.colors.fg}

          dark_mode_background_color    #${config.colors.bg}
          ui_selected_background_color  #${config.colors.yellow}
        '';
        "sioyek/keys_user.config".text = ''
          open_document_embedded  o
          screen_down             <C-f>
          screen_up               <C-b>
          close_window            q
        '';
      };
    })
  ];
}
