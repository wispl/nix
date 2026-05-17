# This module takes us out of the tty and into a real desktop. Wayland is
# enabled along with an idle service, notification service, bar, and
# lockscreen. Oh and xdg is also enabled, it has desktop in its name after all.
# Some small tweaks are also made to gtk and cursor.
#
# Way man, take me by the hand, lead me to the land that you understand
# Sorry
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf makeBinPath;
  inherit (lib.types) str int package;
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
    window, decoration, window.background, window.titlebar {
     	border-radius: 0px;
    }
  '';
in {
  options.modules.desktop = {
    enable = mkEnableOption "wayland desktop";
    session = mkOption {
      type = str;
      description = "default session command for greetd";
    };
    cursor = {
      package = mkOption {
        type = package;
        description = "cursor package to use ";
      };
      size = mkOption {
        type = int;
        default = 32;
        description = "size of cursor";
      };
      name = mkOption {
        type = str;
        description = "name of cursor to use";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg ? session;
        message = "desktop is enabled but there is no session set for greetd";
      }
    ];

    home.packages = with pkgs; [
      cfg.cursor.package
      dconf # ...
      brightnessctl # brightness control
      wlopm # turn on and off display
      grim # screenshot
      slurp # grab area of screen
      libnotify # notification (notify-send)
      swaybg # set wallpaper
      wf-recorder # screen record
      wl-clipboard # clipboard
      chayang # gradually dim screen before locking screen

      xdg-utils # mime and xdg-open

      adwaita-icon-theme # icons

      swaylock # screenlock
      swayidle # idle daemon
      adw-gtk3 # gtk theme
      tuigreet # greeter
    ];

    # Fonts
    fonts.packages = with pkgs; [
      wqy_zenhei # good enough cjk coverage
      dejavu_fonts # good overall coverage
      nerd-fonts.fantasque-sans-mono # programming font of choice
      nerd-fonts.symbols-only # not sure why I have this?
      julia-mono # extensive math coverage
    ];

    # Wayland setup
    hardware.graphics.enable = true;
    # Some stuff for swaylock
    security = {
      polkit.enable = true;
      pam.services.swaylock = {};
      pam.loginLimits = [
        {
          domain = "@users";
          item = "rtprio";
          type = "-";
          value = 1;
        }
      ];
    };

    # Greetd
    # This is a bit better than the tty autologin hack and also ensures
    # if the compositor crashes we are not dropped into an unlocked session.
    # Also environment sourcing works a bit better.
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --window-padding 4 --cmd ${cfg.session}";
          user = "greeter";
        };
      };
    };

    # I only use screencasting so wlr is good enough
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      config.common.default = "wlr";
    };

    # Cursor theme
    home.environment.sessionVariables = {
      XCURSOR_PATH = "\${XCURSOR_PATH}:~/.local/share/icons";

      XCURSOR_SIZE = cfg.cursor.size;
      XCURSOR_THEME = cfg.cursor.name;
    };

    # Use adw-gtk3 to have consistent themes between gtk4 and gtk3
    home.xdg.config.files = {
      "gtk-3.0/gtk.css".text = css;
      "gtk-4.0/gtk.css".text = css;

      "gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-cursor-theme-name=${cfg.cursor.name}
        gtk-cursor-theme-size=${toString cfg.cursor.size}
        gtk-theme-name=adw-gtk3-dark
        gtk-application-prefer-dark-theme=1
      '';

      "gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-cursor-theme-name=${cfg.cursor.name}
        gtk-cursor-theme-size=${toString cfg.cursor.size}
      '';
    };

    # xdg dir variables
    home.environment.sessionVariables = {
      XDG_DESKTOP_DIR = "$HOME";
      XDG_DOCUMENTS_DIR = "$HOME/documents";
      XDG_DOWNLOAD_DIR = "$HOME/tmp";
      XDG_MUSIC_DIR = "$HOME/music";
      XDG_PICTURES_DIR = "$HOME/pictures";
      XDG_PUBLICSHARE_DIR = "$HOME";
      XDG_TEMPLATES_DIR = "$HOME";
      XDG_VIDEOS_DIR = "$HOME";
    };

    # This is used by some apps
    home.xdg.config.files = {
      "user-dirs.dirs".text = ''
        XDG_DESKTOP_DIR="$HOME/"
        XDG_DOCUMENTS_DIR="$HOME/documents"
        XDG_DOWNLOAD_DIR="$HOME/tmp"
        XDG_MUSIC_DIR="$HOME/music"
        XDG_PICTURES_DIR="$HOME/pictures"
        XDG_PUBLICSHARE_DIR="$HOME/"
        XDG_TEMPLATES_DIR="$HOME/"
        XDG_VIDEOS_DIR="$HOME/"
      '';

      "user-dirs.conf".text = ''
        enabled=False
      '';
    };

    # Swaylock
    home.xdg.config.files."swaylock/config".text = ''
      indicator-radius=75
      color=${background}
      bs-hl-color=${red}
      caps-lock-bs-hl-color=${red}
      caps-lock-key-hl-color=${yellow}

      key-hl-color=${yellow}
      layout-text-color=${foreground}}

      ring-color=${magenta}
      ring-clear-color=${red}
      ring-wrong-color=${red}
      ring-caps-lock-color=${yellow}
      ring-ver-color=${blue}

      text-color=${foreground}
      text-clear-color=${red}
      text-wrong-color=${red}
      text-caps-lock-color=${yellow}
      text-ver-color=${blue}

      layout-bg-color=${blank}
      layout-border-color=${blank}
      separator-color=${blank}

      inside-color=${blank}
      inside-clear-color=${blank}
      inside-caps-lock-color=${blank}
      inside-ver-color=${blank}
      inside-wrong-color=${blank}

      line-color=${blank}
      line-clear-color=${blank}
      line-caps-lock-color=${blank}
      line-ver-color=${blank}
      line-wrong-color=${blank}
    '';

    # dim and lock screen after 5 minutes, also turn off the screen as well.
    # systemd.user.services.swayidle = {
    #   unitConfig = {
    #     Description = "Idle manager for Wayland";
    #     ConditionEnvironment = "WAYLAND_DISPLAY";
    #     PartOf = ["graphical-session.target"];
    #     After = ["graphical-session.target"];
    #   };
    #   serviceConfig = {
    #     Type = "simple";
    #     Restart = "always";
    #     Environment = ["PATH=${makeBinPath [pkgs.bash]}"];
    #     ExecStart =
    #       "${pkgs.swayidle}/bin/swayidle -w"
    #       + " timeout 300 \"${pkgs.chayang}/bin/chayang && ${pkgs.swaylock}/bin/swaylock -f\""
    #       + " timeout 305 \"${pkgs.wlopm}/bin/wlopm --off '*'\""
    #       + " resume \"${pkgs.wlopm}/bin/wlopm --on '*'\""
    #       + " before-sleep \"${pkgs.swaylock}/bin/swaylock -f\"";
    #   };
    #   wantedBy = ["graphical-session.target"];
    # };

    # Use non-chayang until niri adds wp_single_pixel_buffer_manager_v1
    # also use niri to power off monitor, until niri adds wlr_power_management
    systemd.user.services.swayidle = {
      unitConfig = {
        Description = "Idle manager for Wayland";
        ConditionEnvironment = "WAYLAND_DISPLAY";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        Environment = ["PATH=${makeBinPath [pkgs.bash]}"];
        ExecStart =
          "${pkgs.swayidle}/bin/swayidle -w"
          + " timeout 300 \"${pkgs.swaylock}/bin/swaylock -f\""
          + " timeout 305 \"${pkgs.niri}/bin/niri msg action power-off-monitors\""
          + " resume \"${pkgs.niri}/bin/niri msg action power-on-monitors\""
          + " before-sleep \"${pkgs.swaylock}/bin/swaylock -f\"";
      };
      wantedBy = ["graphical-session.target"];
    };
  };
}
