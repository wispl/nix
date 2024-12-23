# Desktop related stuff, sets up
#	screen lock
#	screen idle
#	notification
#	window manager
#	bar
{
  pkgs,
  specialArgs,
  ...
}: {
  imports = with specialArgs.theme; [
    ./lock.nix
    ./mako.nix
    ./river.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    brightnessctl
    grim
    libnotify
    slurp
    swaybg
    wf-recorder
    wl-clipboard
    wlopm
  ];

  services = {
    swayidle = {
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
  };
}
