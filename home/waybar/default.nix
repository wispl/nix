{lib, ...}: let
in {
  programs.waybar = {
    enable = true;
    settings.mainBar = lib.importJSON ./config;
    style = builtins.readFile ./style.css;
  };
}
