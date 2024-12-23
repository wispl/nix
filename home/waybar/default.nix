{lib, ...}: let
in {
  programs.waybar = {
    enable = true;
    settings.mainBar = lib.importJSON ./pills/config.jsonc;
    style = builtins.readFile ./pills/style.css;
  };
}
