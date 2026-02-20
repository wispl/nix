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
    openrocket.enable = mkEnableOption "openrocket";
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
            #tabbrowser-tabbox .browserContainer {
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

            /* float findbar to the top left, taken from mrotherguy, and added some tweaks:
             *   transparent background and border
             *   top right
             *   icons for options (from biglavis/LittleFox)
             *   remove less useful options
             */
            findbar{
              order: -1;
              margin-bottom: -33px;
              position: relative;
              border-top: none !important;
              padding: 0 !important;
              transition: transform 82ms linear, opacity 82ms linear 32ms !important;
              background: none !important;
              pointer-events: none;
              z-index: 1;
              white-space: nowrap;
              flex-direction: row-reverse;
            }

            .findbar-textbox {
              border: none !important;
            }

            .findbar-container > .findbar-find-fast {
              padding: var(--toolbarbutton-inner-padding) 1px;
              margin: 0 !important;
            }

            findbar[hidden]{ transform: translateY(-30px);}

            findbar > .findbar-container,
            findbar > .close-icon{
              border: 1px solid transparent;
              border-width: 0 0 1px 0px;
              background-color: var(--lwt-accent-color,var(--toolbox-bgcolor)) !important;
              pointer-events: auto;
            }

            findbar > .findbar-container{
              border-bottom-right-radius: 4px;
              border-right-width: 1px;
              height: initial !important;
              margin-inline: 0px !important;
              overflow-inline: visible !important;
            }

            .findbar-find-status{
              display: flex;
              overflow: hidden;
              text-overflow: ellipsis;
              flex-grow: 1;
            }

            .findbar-closebutton{
              margin: 0 !important;
              border-radius: 0 !important;
              padding: 5px !important;
              width: initial !important;
              order: -1;
            }
            .findbar-closebutton > image{ padding: 3px }
            .findbar-closebutton:hover > image{
              background: var(--toolbarbutton-hover-background) !important;
              border-radius: 4px
            }
            findbar > .findbar-container > hbox{ margin: 0 5px }

            findbar::after{
              content:"";
              display: flex;
              flex-grow: 100;
            }

            .findbar-highlight,
            .findbar-match-diacritics {
                display: none !important;
            }

            /* simplify checkboxes */
            .findbar-container > checkbox {
              display: grid !important;
              justify-items: center !important;
              margin-left: 0px !important;
              overflow: hidden !important;
            }
            .findbar-container > checkbox *{
              display: none !important;
            }

            .findbar-container > checkbox:not([checked]):hover {
              background-color: var(--toolbarbutton-hover-background) !important;
              border-radius: 4px !important;
            }
            .findbar-container > checkbox[checked] {
              background-color: var(--toolbarbutton-active-background) !important;
              border-radius: 4px !important;
            }

            .findbar-case-sensitive::before {
              content: "Aa";
              font-weight: bold;
              color: var(--toolbar-color);
              padding: 2px;
            }

            .findbar-entire-word::before {
              content: "ab";
              font-weight: bold;
              color: var(--toolbar-color);
              grid-row: 1;
              grid-column: 1;
              padding: 2px;
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

    # For occasional rocketry
    (mkIf cfg.openrocket.enable {
      # openrocket spits a .openrocket dir which is not configurable
      # so shove this into the jail as well :)
      home.packages = with pkgs; [
        (writeShellScriptBin "openrocket" ''
          export _JAVA_AWT_WM_NONREPARENTING=1
          export _JAVA_OPTIONS="''${_JAVA_OPTIONS} -Duser.home=''${XDG_FAKE_HOME}"
          exec ${pkgs.openrocket}/bin/openrocket "$@"
        '')
      ];
    })
  ];
}
