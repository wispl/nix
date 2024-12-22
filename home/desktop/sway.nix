{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with pkgs; let
  wallpaper_dir = "$XDG_PICTURES_DIR/wallpapers/";
  filename = "hk_room.png";
  mod4 = "Mod4";
  bg = "#${theme.bg}181616";
  fg = "#${theme.fg}";
  border = "#${theme.bgL}";
  inactive = "#${theme.bgD}";
  urgent = "#${theme.red}";
in {
  imports = [./wayland.nix];

  wayland = {
    windowManager = {
      sway = {
        enable = true;
        config = rec {
          modifier = "${mod4}";
          gaps = {
            inner = 8;
            outer = 0;
          };
          startup = [
            {command = "${swaybg}/bin/swaybg --mode fill -i ${wallpaper_dir}${filename}";}
          ];
          input = {
            "type:touchpad" = {
              dwt = "disabled";
              tap = "enabled";
              middle_emulation = "enabled";
              pointer_accel = "0.5";
            };

            "type:keyboard" = {
              repeat_delay = "200";
              # swap ctrl and capslock
              xkb_options = "ctrl:swapcaps";
            };
          };
          window = {
            titlebar = false;
            border = 4;
          };
          bars = [
            {
              command = "waybar";
            }
          ];
          keybindings = lib.mkOptionDefault {
            "${mod4}+d" = "exec fuzzel";
            "${mod4}+i" = "exec ~/.local/bin/noteshow";

            "${mod4}+Tab" = "workspace back_and_forth";
            "${mod4}+q" = "kill";
            "${mod4}+b" = "exec firefox";
            "${mod4}+p" = "exec keepassxc";
            # audio control
            "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+";
            "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-";
            "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

            # mic control
            "${mod4}+XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 2%+";
            "${mod4}+XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 2%-";
            "${mod4}+XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

            # player control
            "XF86AudioPlay" = "exec playerctl play-pause --player=%any,mpv,mpd";
            "XF86AudioPrev" = "exec playerctl previous --player=%any,mpv,mpd";
            "XF86AudioNext" = "exec playerctl next --player=%any,mpv,mpd";
            "XF86AudioStop" = "exec playerctl play-pause --player=%any,mpv,mpd";

            # brightness
            "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
            "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
          };
          colors = {
            focused = {
              background = bg;
              border = border;
              indicator = border;
              childBorder = border;
              text = fg;
            };
            focusedInactive = {
              background = bg;
              border = inactive;
              indicator = inactive;
              childBorder = inactive;
              text = fg;
            };
            unfocused = {
              background = bg;
              border = inactive;
              indicator = inactive;
              childBorder = inactive;
              text = fg;
            };
            urgent = {
              background = bg;
              border = urgent;
              indicator = urgent;
              childBorder = urgent;
              text = fg;
            };
            placeholder = {
              background = bg;
              border = border;
              indicator = border;
              childBorder = border;
              text = fg;
            };
          };
        };
      };
    };
  };
}