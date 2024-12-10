{...}: let
  foreground = "c5c9c5";
  background = "181616";
  light-background = "282727";

  # black, red, green, yellow, blue, magenta, cyan, white
  red = "c4746e";
  green = "8a9a7b";
  yellow = "c4b28a";
  blue = "8ba4b0";
  magenta = "a292a3";
  cyan = "8ea4a2";
in {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "monospace, Symbols Nerd Font:size=12";
        prompt = "' '";
        # until I find a good icon theme
        icons-enabled = false;
        match-counter = true;
        line-height = 20;
        inner-pad = 40;
        horizontal-pad = 80;
        vertical-pad = 40;
      };
      border = {
        radius = 0;
        width = 6;
      };
      colors = {
        prompt = "${yellow}ff";
        placeholder = "${foreground}90";
        background = "${background}ff";
        text = "${foreground}ff";
        match = "${red}ff";
        selection = "${magenta}ff";
        selection-text = "${background}ff";
        counter = "${magenta}ff";
        border = "${light-background}ff";
      };
    };
  };
}
