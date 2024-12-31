# Base set of packages and configurations for desktop wayland.
# Wayland compositors should import this file which sets up
#	graphical settings: gtk, qt, cursors, icons, etc...
#	screenlock
#	notification
#	idle daemon
#	bar
{
  lib,
  pkgs,
  theme,
  ...
}: let
  # These are for swaylock, which requires setting like a million options
  # to the same value so having them predefined is good for my sanity.
  blank = "00000000";
  foreground = "${theme.fg}ff";
  background = "${theme.bg}ff";

  red = "${theme.red}ff";
  green = "${theme.green}ff";
  yellow = "${theme.yellow}ff";
  blue = "${theme.blue}ff";
  magenta = "${theme.magenta}90";
in {
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
  };

  # Screenlock
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

  # Notifiations
  services.mako = {
    enable = true;
    font = "DejaVu Sans Mono 12";
    borderSize = 2;
    borderRadius = 2;
    icons = true;
    padding = "10";
    defaultTimeout = 3000;
    width = 400;

    textColor = "#${theme.fg}";
    backgroundColor = "#${theme.bg}";
    borderColor = "#${theme.blue}";
    progressColor = "over #${theme.yellow}";

    extraConfig = "[urgency=high]\nborder-color=#${theme.red}\ndefault-timeout=0";
  };

  # idle daemon
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

  # TODO: use symlinks for config? Since waybar can reload on config change
  # Bar
  programs.waybar = {
    enable = true;
    settings.mainBar = lib.importJSON ./waybar_conf/pills/config.jsonc;
    style = ''
      @define-color fg #${theme.fg};

      @define-color bg0 #${theme.bgDDD};
      @define-color bg1 #${theme.bgDD};
      @define-color bg2 #${theme.bgD};
      @define-color bg  #${theme.bg};
      @define-color bg4 #${theme.bgL};
      @define-color bg5 #${theme.bgLL};
      @define-color bg6 #${theme.bgLLL};

      @define-color red     #${theme.red};
      @define-color green   #${theme.green};
      @define-color yellow  #${theme.yellow};
      @define-color blue    #${theme.blue};
      @define-color magenta #${theme.magenta};
      @define-color cyan    #${theme.cyan};

      @define-color bright-red     #${theme.brightRed};
      @define-color bright-green   #${theme.brightGreen};
      @define-color bright-yellow  #${theme.brightYellow};
      @define-color bright-blue    #${theme.brightBlue};
      @define-color bright-magenta #${theme.brightMagenta};
      @define-color bright-cyan    #${theme.brightCyan};
      ${builtins.readFile ./waybar_conf/pills/style.css}
    '';
  };
}
