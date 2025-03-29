{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  scratch_tag = "$((1 << 19))";
  # until keepassxc gets wayland autotype
  keepassxc_tag = "$((1 << 20))";
  dropterm_tag = "$((1 << 21))";

  # TODO: convert these to pkg
  commonBinds = {
    "None XF86AudioRaiseVolume" = "spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+'";
    "None XF86AudioLowerVolume" = "spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-'";
    "None XF86AudioMute" = "spawn 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'";

    "None XF86AudioMedia" = "spawn 'playerctl play-pause'";
    "None XF86AudioPlay" = "spawn 'playerctl play-pause'";
    "None XF86AudioPrev" = "spawn 'playerctl previous'";
    "None XF86AudioNext" = "spawn 'playerctl next'";

    "None XF86MonBrightnessUp" = "spawn 'brightnessctl set +5%'";
    "None XF86MonBrightnessDown" = "spawn 'brightnessctl set 5%-'";
  };
  cfg = config.modules.desktop.riverwm;
in {
  options.modules.desktop.riverwm = {
    enable = mkEnableOption "riverwm";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [rivercarro];

    wayland.windowManager.river = {
      enable = true;
      settings = {
        border-width = 4;

        background-color = "0x${config.colors.bg}";
        border-color-focused = "0x${config.colors.bgL}";
        border-color-unfocused = "0x${config.colors.bgD}";
        border-color-urgent = "0x${config.colors.red}";

        default-layout = "rivercarro";
        spawn = [
          "'rivercarro -no-smart-gaps -inner-gaps 8 -outer-gaps 8'"
          "waybar"
          "'swaybg --mode fill -i $WALLPAPER'"
          "'foot -a dropterm'"
          "keepassxc"
        ];

        rule-add = {
          "-app-id" = {
            "'*'" = "ssd";
          };
        };

        set-repeat = "25 300";
        keyboard-layout = "-options 'ctrl:swapcaps' us";
        input = {
          "*TouchPad" = {
            disable-while-typing = false;
            tap = true;
            middle-emulation = true;
            pointer-accel = 0.5;
          };
        };

        xcursor-theme = "${config.gtk.cursorTheme.name} ${toString config.gtk.cursorTheme.size}";
        declare-mode = ["normal" "locked"];
        map = {
          normal =
            {
              "Super Return" = "spawn foot";
              "Super D" = "spawn 'fuzzel --counter'";
              "Super I" = "spawn ~/.local/bin/noteshow";
              "Super B" = "spawn firefox";
              "Super S" = "spawn 'filebrowse ~'";
              "Super P" = "spawn 'riverctl toggle-focused-tags ${keepassxc_tag} && riverctl focus-view up'";
              # u for upower I guess...
              "Super U" = "spawn powerprofilesmenu";
              "Super semicolon" = "spawn 'riverctl toggle-focused-tags ${dropterm_tag} && riverctl focus-view up'";

              "None  Print" = "spawn 'grimshot screen'";
              "Shift Print" = "spawn 'grimshot area'";
              "Super Print" = "spawn 'grimshot area --copy'";

              "Super Q" = "close";

              "Super H" = "focus-view left";
              "Super J" = "focus-view down";
              "Super K" = "focus-view up";
              "Super L" = "focus-view right";

              "Super Tab" = "focus-previous-tags";

              "Super+Shift H" = "swap left";
              "Super+Shift J" = "swap down";
              "Super+Shift K" = "swap up";
              "Super+Shift L" = "swap right";

              "Super Space" = "zoom";

              "Super Up" = "send-layout-cmd rivercarro 'main-location top'";
              "Super Right" = "send-layout-cmd rivercarro 'main-location right'";
              "Super Down" = "send-layout-cmd rivercarro 'main-location bottom'";
              "Super Left" = "send-layout-cmd rivercarro 'main-location left'";

              "Super M" = "send-layout-cmd rivercarro 'main-location-cycle left,monocle'";

              "Super bracketright" = "send-layout-cmd rivercarro 'main-ratio +0.05'";
              "Super bracketleft" = "send-layout-cmd rivercarro 'main-ratio -0.05'";

              "Super equal" = "send-layout-cmd rivercarro 'main-count +1'";
              "Super minus" = "send-layout-cmd rivercarro 'main-count -1'";

              "Super F" = "toggle-float";
              "Super+Shift F" = "toggle-fullscreen";
            }
            // commonBinds;
          locked = commonBinds;
        };
        map-pointer = {
          normal = {
            "Super BTN_LEFT" = "move-view";
            "Super BTN_RIGHT" = "resize-view";
          };
        };
        extraConfig = ''
          allowed_tags=$(( ((1 << 32) - 1) ^ ${scratch_tag} ^ ${keepassxc_tag} ^ ${dropterm_tag}))
          riverctl spawn-tagmask ''${allowed_tags}
          for i in $(seq 1 9)
          do
            tags=$((1 << ($i - 1)))
            riverctl map normal Super $i set-focused-tags $tags
            riverctl map normal Super+Shift $i set-view-tags $tags
            riverctl map normal Super+Control $i toggle-focused-tags $tags
            riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
          done

          riverctl rule-add -app-id dropterm float
          riverctl rule-add -app-id dropterm tags "${dropterm_tag}"

          riverctl rule-add -app-id org.keepassxc.KeePassXC float
          riverctl rule-add -app-id org.keepassxc.KeePassXC tags "${keepassxc_tag}"
        '';
      };
    };
  };
}
