# This module takes us out of the tty and into a real desktop. Wayland is
# enabled along with an idle service, notification service, bar, and
# lockscreen. Oh and xdg is also enabled, it has desktop in its name after all.
# Some small tweaks are also made to gtk and cursor.
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop;

  blank = "00000000";
  foreground = "${config.colors.fg}ff";
  background = "${config.colors.bg}ff";

  red = "${config.colors.red}ff";
  green = "${config.colors.green}ff";
  yellow = "${config.colors.yellow}ff";
  blue = "${config.colors.blue}ff";
  magenta = "${config.colors.magenta}90";
  css = ''
    window, decoration, decoration-overlay, headerbar, .titlebar {
     	border-radius: 0px;
    }
  '';
in {
  imports = [./riverwm.nix ./swaywm.nix ./term.nix ./ui.nix];
  options.modules.desktop = {
    enable = mkEnableOption "wayland desktop";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dconf # ...
      brightnessctl # brightness control
      wlopm # turn on and off display
      grim # screenshot
      slurp # grab area of screen
      libnotify # notification
      swaybg # set wallpaper
      wf-recorder # screen record
      wl-clipboard # clipboard

      xdg-utils # mime and xdg-open

      adwaita-icon-theme # icons
    ];

    home.pointerCursor = {
      gtk.enable = true;
      size = 32;
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
    };

    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };
      gtk3.extraCss = css;
      gtk4.extraCss = css;
    };

    xdg = {
      userDirs = {
        enable = true;
        desktop = "\$HOME/";
        documents = "\$HOME/documents";
        download = "\$HOME/tmp";
        music = "\$HOME/music";
        pictures = "\$HOME/pictures";
      };
      mimeApps = {
        enable = true;
      };
    };

    programs.swaylock = {
      enable = true;
      settings = {
        indicator-radius = 75;
        color = background;
        bs-hl-color = red;
        caps-lock-bs-hl-color = red;
        caps-lock-key-hl-color = yellow;

        key-hl-color = yellow;
        layout-text-color = foreground;

        ring-color = magenta;
        ring-clear-color = red;
        ring-wrong-color = red;
        ring-caps-lock-color = yellow;
        ring-ver-color = blue;

        text-color = foreground;
        text-clear-color = red;
        text-wrong-color = red;
        text-caps-lock-color = yellow;
        text-ver-color = blue;

        layout-bg-color = blank;
        layout-border-color = blank;
        separator-color = blank;

        inside-color = blank;
        inside-clear-color = blank;
        inside-caps-lock-color = blank;
        inside-ver-color = blank;
        inside-wrong-color = blank;

        line-color = blank;
        line-clear-color = blank;
        line-caps-lock-color = blank;
        line-ver-color = blank;
        line-wrong-color = blank;
      };
    };

    services.swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock}/bin/swaylock -f";
        }
      ];
      timeouts = [
        {
          timeout = 300;
          command = "${pkgs.swaylock}/bin/swaylock -f";
        }
        {
          timeout = 330;
          command = "${pkgs.wlopm}/bin/wlopm  --off '*'";
          resumeCommand = "${pkgs.wlopm}/bin/wlopm  --on '*'";
        }
      ];
    };

    services.mako = {
      enable = true;
      font = "DejaVu Sans Mono 12";
      borderSize = 2;
      borderRadius = 2;
      icons = true;
      padding = "10";
      defaultTimeout = 3000;
      width = 400;

      textColor = "#${config.colors.fg}";
      backgroundColor = "#${config.colors.bg}";
      borderColor = "#${config.colors.blue}";
      progressColor = "over #${config.colors.yellow}";

      extraConfig = "[urgency=high]\nborder-color=#${config.colors.red}\ndefault-timeout=0";
    };

    programs.waybar = {
      enable = true;
      settings.mainBar = lib.importJSON ./waybar/pills/config.jsonc;
      style = ''
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
        ${builtins.readFile ./waybar/pills/style.css}
      '';
    };
  };
}
