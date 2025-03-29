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
  };
}
