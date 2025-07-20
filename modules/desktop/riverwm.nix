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

  variables = [
    "DISPLAY"
    "WAYLAND_DISPLAY"
    "XDG_CURRENT_DESKTOP"
    "NIXOS_OZONE_WL"
    "XCURSOR_THEME"
    "XCURSOR_SIZE"
  ];
  export = builtins.concatStringsSep " " variables;
  # TODO: convert these to pkg
  cfg = config.modules.desktop.riverwm;
in {
  options.modules.desktop.riverwm = {
    enable = mkEnableOption "riverwm";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [river rivercarro];
    home.files.".config/river/init".source =
      pkgs.writeShellScript "init"
      ''
                      allowed_tags=$(( ((1 << 32) - 1) ^ ${scratch_tag} ^ ${keepassxc_tag} ^ ${dropterm_tag}))
                      riverctl spawn-tagmask ''${allowed_tags}

                      riverctl background-color 0x${config.colors.bg}
                      riverctl border-color-focused 0x${config.colors.bg}
                      riverctl border-color-unfocused 0x${config.colors.bg}
                      riverctl border-color-urgent 0x${config.colors.red}
                      riverctl border-width 4
        riverctl xcursor-theme ${config.modules.desktop.cursor.name} ${toString config.modules.desktop.cursor.size}

                      riverctl declare-mode normal
                      riverctl declare-mode locked
                      riverctl default-layout rivercarro

                      riverctl spawn 'rivercarro -inner-gaps 8 -outer-gaps 16'
                      riverctl spawn 'eww open-many bar frame'
                      riverctl spawn 'swaybg --mode fill -i $WALLPAPER'
                      riverctl spawn 'foot -a dropterm'
                      riverctl spawn keepassxc

                      for i in $(seq 1 9); do
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

                      riverctl input *TouchPad disable-while-typing disabled
                      riverctl input *TouchPad middle-emulation enabled
                      riverctl input *TouchPad pointer-accel 0.500000
                      riverctl input *TouchPad tap enabled
                      riverctl keyboard-layout -options 'ctrl:swapcaps' us

                      riverctl map-pointer normal Super BTN_LEFT move-view
                      riverctl map-pointer normal Super BTN_RIGHT resize-view
                      riverctl set-repeat 25 300

                      riverctl rule-add -app-id '*' ssd

                      # motions
                      riverctl map normal Super+Shift H swap left
                      riverctl map normal Super+Shift J swap down
                      riverctl map normal Super+Shift K swap up
                      riverctl map normal Super+Shift L swap right

                      riverctl map normal Super H focus-view left
                      riverctl map normal Super J focus-view down
                      riverctl map normal Super K focus-view up
                      riverctl map normal Super L focus-view right

                      riverctl map normal Super Tab focus-previous-tags

                      # apps
                      riverctl map normal Super Q close

                      riverctl map normal Super Return spawn foot
                      riverctl map normal Super B spawn firefox
                      riverctl map normal Super D spawn 'fuzzel --counter'
                      riverctl map normal Super S spawn 'filebrowse ~'
                      riverctl map normal Super I spawn ~/.local/bin/noteshow

                      riverctl map normal Super P spawn 'riverctl toggle-focused-tags ${keepassxc_tag} && riverctl focus-view up'
                      riverctl map normal Super semicolon spawn 'riverctl toggle-focused-tags ${dropterm_tag} && riverctl focus-view up'
                      riverctl map normal Super E spawn ~/.local/bin/toggle_dashboard
                      riverctl map normal Super N spawn ~/.local/bin/toggle_notifications
                      riverctl map normal Super U spawn powerprofilesmenu

                      # screenshots
                      riverctl map normal Super Print spawn 'grimshot area --copy'
                      riverctl map normal Shift Print spawn 'grimshot area'

                      # layout
                      riverctl map normal Super Down send-layout-cmd rivercarro 'main-location bottom'
                      riverctl map normal Super Left send-layout-cmd rivercarro 'main-location left'
                      riverctl map normal Super M send-layout-cmd rivercarro 'main-location-cycle left,monocle'
                      riverctl map normal Super Right send-layout-cmd rivercarro 'main-location right'
                      riverctl map normal Super F toggle-float
                      riverctl map normal Super Space zoom
                      riverctl map normal Super+Shift F toggle-fullscreen

                      # layout settings
                      riverctl map normal Super Up send-layout-cmd rivercarro 'main-location top'
                      riverctl map normal Super bracketleft send-layout-cmd rivercarro 'main-ratio -0.05'
                      riverctl map normal Super bracketright send-layout-cmd rivercarro 'main-ratio +0.05'
                      riverctl map normal Super equal send-layout-cmd rivercarro 'main-count +1'
                      riverctl map normal Super minus send-layout-cmd rivercarro 'main-count -1'

                      # special keys
                      riverctl map locked None XF86AudioLowerVolume spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-'
                      riverctl map locked None XF86AudioMute spawn 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'
                      riverctl map locked None XF86AudioRaiseVolume spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+'
                      riverctl map locked None XF86MonBrightnessDown spawn 'brightnessctl set 5%-'
                      riverctl map locked None XF86MonBrightnessUp spawn 'brightnessctl set +5%'

                      riverctl map normal None XF86AudioLowerVolume spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-'
                      riverctl map normal None XF86AudioMute spawn 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'
                      riverctl map normal None XF86AudioRaiseVolume spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+'
                      riverctl map normal None XF86MonBrightnessDown spawn 'brightnessctl set 5%-'
                      riverctl map normal None XF86MonBrightnessUp spawn 'brightnessctl set +5%'
            exec systemctl export --user import-environment ${export}
      '';
  };
}
