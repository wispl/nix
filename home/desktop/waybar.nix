{lib, ...}: {
  programs.waybar = {
    enable = true;
    settings.mainBar = lib.importJSON ./waybar_conf/pills/config.jsonc;
    style = builtins.readFile ./waybar_conf/pills/style.css;
  };
}
