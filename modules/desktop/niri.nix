{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.niri;
in {
  options.modules.desktop.niri = {
    enable = lib.mkEnableOption "niri";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [niri xwayland-satellite];
    home.xdg.config.files."niri/config.kdl".text =
      # kdl
      ''
        spawn-at-startup "eww" "open-many" "bar" "frame"
        spawn-at-startup "sh" "-c" "swaybg --mode fill -i $WALLPAPER"
        input {
            workspace-auto-back-and-forth
            keyboard {
                xkb {
                    layout "us"
                    options "ctrl:nocaps"
                }
                repeat-delay 300
                repeat-rate 25
            }

            touchpad {
                tap
                accel-speed 0.5
                middle-emulation
            }
        }

        output "eDP-1" {
            scale 1.0
        }

        cursor {
          xcursor-theme "${config.modules.desktop.cursor.name}"
          xcursor-size ${toString config.modules.desktop.cursor.size}
        }

        layout {
            gaps 6
            background-color "transparent"
            center-focused-column "never"
            preset-column-widths {
                proportion 0.33333
                proportion 0.5
                proportion 0.66667
            }

            default-column-width { proportion 0.5; }

            focus-ring {
                off
            }

            border {
                off
            }

            shadow {
                // on
                softness 30
                spread 5
                offset x=0 y=0
                color "#0007"
            }

            struts {
                left 7
                right 7
                top 7
                bottom 7
            }
        }

        hotkey-overlay {
            skip-at-startup
        }

        prefer-no-csd
        screenshot-path "~/pictures/%Y-%m-%d %H-%M-%S.png"

        animations {
            // off
          workspace-switch {
            off
          }
        }

        workspace "one"
        workspace "two"
        workspace "three"
        workspace "four"
        workspace "five"
        workspace "pass"

        window-rule {
            match app-id=r#"firefox$"# title="^Picture-in-Picture$"
            open-floating true
        }

        window-rule {
            match app-id=r#"^org\.keepassxc\.KeePassXC$"#

            open-on-workspace "pass"
            open-floating true
            block-out-from "screen-capture"
        }

        window-rule {
            geometry-corner-radius 8
            clip-to-geometry true
        }

        layer-rule {
          match namespace="^wallpaper$"
          place-within-backdrop true
        }

        binds {
            Mod+Slash { show-hotkey-overlay; }

            Mod+B repeat=false { spawn "firefox"; }
            Mod+E repeat=false { spawn "toggle_dashboard"; }
            Mod+N repeat=false { spawn "toggle_notifications"; }
            Mod+P repeat=false { focus-workspace "pass"; }

            Mod+S repeat=false { spawn "sh" "-c" "filebrowse ~"; }
            Mod+A repeat=false { spawn "noteshow"; }

            Mod+Return hotkey-overlay-title="Open Terminal" { spawn "foot"; }
            Mod+D hotkey-overlay-title="Open Launcher" { spawn "fuzzel"; }
            Super+Alt+L hotkey-overlay-title="Lock the Screen" { spawn "swaylock"; }

            XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"; }
            XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"; }
            XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
            XF86AudioMicMute     allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

            XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "set" "+5%"; }
            XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "set" "5%-"; }

            Mod+O repeat=false { toggle-overview; }
            Mod+Q repeat=false { close-window; }

            Mod+H     { focus-column-left; }
            Mod+J     { focus-window-down; }
            Mod+K     { focus-window-up; }
            Mod+L     { focus-column-right; }

            Mod+Shift+H     { move-column-left; }
            Mod+Shift+J     { move-window-down; }
            Mod+Shift+K     { move-window-up; }
            Mod+Shift+L     { move-column-right; }

            Mod+Ctrl+H      { focus-column-first; }
            Mod+Ctrl+L      { focus-column-last; }
            Mod+Ctrl+J      { focus-workspace-down; }
            Mod+Ctrl+K      { focus-workspace-up; }

            Mod+U           { move-workspace-down; }
            Mod+I           { move-workspace-up; }
            Mod+Shift+U     { move-column-to-workspace-down; }
            Mod+Shift+I     { move-column-to-workspace-up; }

            Mod+Left  { focus-monitor-left; }
            Mod+Down  { focus-monitor-down; }
            Mod+Up    { focus-monitor-up; }
            Mod+Right { focus-monitor-right; }

            Mod+Shift+Left  { move-column-to-monitor-left; }
            Mod+Shift+Down  { move-column-to-monitor-down; }
            Mod+Shift+Up    { move-column-to-monitor-up; }
            Mod+Shift+Right { move-column-to-monitor-right; }


            Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
            Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
            Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
            Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

            Mod+WheelScrollRight      { focus-column-right; }
            Mod+WheelScrollLeft       { focus-column-left; }
            Mod+Ctrl+WheelScrollRight { move-column-right; }
            Mod+Ctrl+WheelScrollLeft  { move-column-left; }

            Mod+Shift+WheelScrollDown      { focus-column-right; }
            Mod+Shift+WheelScrollUp        { focus-column-left; }
            Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
            Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

            Mod+1 { focus-workspace 1; }
            Mod+2 { focus-workspace 2; }
            Mod+3 { focus-workspace 3; }
            Mod+4 { focus-workspace 4; }
            Mod+5 { focus-workspace 5; }
            Mod+6 { focus-workspace 6; }
            Mod+7 { focus-workspace 7; }
            Mod+8 { focus-workspace 8; }
            Mod+9 { focus-workspace 9; }
            Mod+Shift+1 { move-column-to-workspace 1; }
            Mod+Shift+2 { move-column-to-workspace 2; }
            Mod+Shift+3 { move-column-to-workspace 3; }
            Mod+Shift+4 { move-column-to-workspace 4; }
            Mod+Shift+5 { move-column-to-workspace 5; }
            Mod+Shift+6 { move-column-to-workspace 6; }
            Mod+Shift+7 { move-column-to-workspace 7; }
            Mod+Shift+8 { move-column-to-workspace 8; }
            Mod+Shift+9 { move-column-to-workspace 9; }

            Mod+Tab { focus-workspace-previous; }

            Mod+BracketLeft  { consume-or-expel-window-left; }
            Mod+BracketRight { consume-or-expel-window-right; }
            Mod+Comma  { consume-window-into-column; }
            Mod+Period { expel-window-from-column; }

            Mod+R { switch-preset-column-width; }
            Mod+Shift+R { switch-preset-window-height; }
            Mod+Ctrl+R { reset-window-height; }
            Mod+F { maximize-column; }
            Mod+Shift+F { fullscreen-window; }

            Mod+Ctrl+F { expand-column-to-available-width; }
            Mod+C { center-column; }
            Mod+Ctrl+C { center-visible-columns; }

            Mod+Minus { set-column-width "-10%"; }
            Mod+Equal { set-column-width "+10%"; }
            Mod+Shift+Minus { set-window-height "-10%"; }
            Mod+Shift+Equal { set-window-height "+10%"; }

            // Move the focused window between the floating and the tiling layout.
            Mod+V       { toggle-window-floating; }
            Mod+Shift+V { switch-focus-between-floating-and-tiling; }
            Mod+W { toggle-column-tabbed-display; }

            Print { screenshot; }
            Ctrl+Print { screenshot-screen; }
            Alt+Print { screenshot-window; }

            Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
        }

        environment {
            DISPLAY ":0"
        }
      '';
  };
}
