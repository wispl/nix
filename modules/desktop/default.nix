# This module takes us out of the tty and into a real desktop. Wayland is
# enabled along with an idle service, notification service, bar, and
# lockscreen. Oh and xdg is also enabled, it has desktop in its name after all.
# Some small tweaks are also made to gtk and cursor.
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
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
  imports = [./ui.nix ./term.nix ./riverwm.nix];
  options.modules.desktop = {
    enable = mkEnableOption "wayland desktop";
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
      chayang # gradually dim screen before locking screen

      xdg-utils # mime and xdg-open

      adwaita-icon-theme # icons

      swaylock
      swayidle
      mako
      adw-gtk3
      cfg.cursor.package
    ];

    # cursor theme
    home.environment.sessionVariables = {
      XCURSOR_PATH = "\${XCURSOR_PATH}:~/.local/share/icons";

      XCURSOR_SIZE = cfg.cursor.size;
      XCURSOR_THEME = cfg.cursor.name;
    };

    # use adw-gtk3 to have consistent themes between gtk4 and gtk3
    home.files = {
      ".config/gtk-3.0/gtk.css".text = css;
      ".config/gtk-4.0/gtk.css".text = css;

      ".config/gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-cursor-theme-name=${cfg.cursor.name}
        gtk-cursor-theme-size=${toString cfg.cursor.size}
        gtk-theme-name=adw-gtk3
      '';

      ".config/gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-cursor-theme-name=${cfg.cursor.name}
        gtk-cursor-theme-size=${toString cfg.cursor.size}
        gtk-theme-name=adw-gtk3
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

    # this is used by some apps
    home.files = {
      ".config/user-dirs.dirs".text = ''
        XDG_DESKTOP_DIR="$HOME/"
        XDG_DOCUMENTS_DIR="$HOME/documents"
        XDG_DOWNLOAD_DIR="$HOME/tmp"
        XDG_MUSIC_DIR="$HOME/music"
        XDG_PICTURES_DIR="$HOME/pictures"
        XDG_PUBLICSHARE_DIR="$HOME/"
        XDG_TEMPLATES_DIR="$HOME/"
        XDG_VIDEOS_DIR="$HOME/"
      '';

      ".config/user-dirs.conf".text = ''
        enabled=False
      '';
    };

    # swaylock
    home.files.".config/swaylock/config".text = ''
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
    systemd.user.services.swayidle = {
      unitConfig = {
        Description = "Idle manager for Wayland";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart =
          "${pkgs.swayidle}/bin/swayidle -w"
          + " timeout 300 \"${pkgs.chayang}/bin/chayang && ${pkgs.swaylock}/bin/swaylock -f\""
          + " timeout 305 \"${pkgs.wlopm}/bin/wlopm --off '*'\""
          + " resume \"${pkgs.wlopm}/bin/wlopm --on '*'\""
          + " before-sleep \"${pkgs.swaylock}/bin/swaylock -f\"";
      };
      wantedBy = ["graphical-session.target"];
    };

    # notification daemon
    # mako starts itself when it receives a notification so there is no need to
    # make a service file.
    home.files.".config/mako/config".text = ''
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
  };
}
