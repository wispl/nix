{...}: let
in {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        height = 45;
        margin-top = 10;
        margin-left = 8;
        margin-right = 8;
        modules-left = ["memory" "network"];
        # modules-center = ["sway/workspaces"];
        modules-center = ["river/tags"];
        modules-right = ["pulseaudio" "pulseaudio/slider" "backlight" "backlight/slider" "battery" "clock"];

        "river/tags" = {
          "num-tags" = 6;
        };

        "sway/workspaces" = {
          "format" = "{icon}";
          "persistent-workspaces" = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
            "6" = [];
          };
        };

        "sway/mode" = {
          "format" = "Mode [{}]";
          "tooltip" = false;
        };

        "mpd" = {
          "format" = "{stateIcon} <{title}>";
          "format-disconnected" = "Disconnected";
          "format-stopped" = "Stopped";
          "unknown-tag" = "N/A";
          "interval" = 2;
          "state-icons" = {
            "paused" = "";
            "playing" = "";
          };
          "tooltip-format" = "MPD (connected)";
          "tooltip-format-disconnected" = "MPD (disconnected)";
        };

        "clock" = {
          "interval" = 60;
          "format" = "{:%e %b %R}";
          "format-alt" = "{:%e %b, %a %R}";
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "cpu" = {
          "interval" = 10;
          "format" = " {usage}% ";
        };

        "memory" = {
          "interval" = 30;
          "format" = " {used} GB";
        };

        "backlight" = {
          "device" = "amdgpu_bl0";
          "format" = "{icon}";
          "format-icons" = ["󰃝" "󰃞" "󰃟" "󰃠"];
          "tooltip" = false;
        };

        "backlight/slider" = {
          "min" = 0;
          "max" = 100;
          "orientation" = "horizontal";
        };

        "battery" = {
          "interval" = 60;
          "states" = {
            "good" = 80;
            "warning" = 30;
            "critical" = 15;
          };

          "format" = "{icon} {capacity}%";
          "format-charging" = "󰂄 {capacity}%";
          "format-icons" = ["󰂎" "󰁻" "󰁽" "󰁿" "󰂁" "󰁹"];
        };

        "network" = {
          "format-wifi" = "󰤨 {essid}";
          "format-disconnected" = "󰤭";
          "tooltip" = false;
        };

        "pulseaudio" = {
          "format" = "{icon} ";
          "format-icons" = {
            "headphone" = "󰋋";
            "default" = ["󰕿" "󰖀" "󰕾"];
          };
          "format-muted" = "󰸈";
          "tooltip" = false;
          "scroll-step" = 1;
        };

        "pulseaudio/slider" = {
          "min" = 0;
          "max" = 100;
          "orientation" = "horizontal";
        };
      };
    };
    style = builtins.readFile ./style.css;
  };
}
