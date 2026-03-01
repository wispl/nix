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
        ".mozilla/firefox/default/chrome/userChrome.css".text = builtins.readFile ../../config/firefox/userChrome.css;
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
