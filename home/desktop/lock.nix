{theme, ...}: let
  blank = "00000000";
  foreground = "${theme.fg}ff";
  background = "${theme.bg}ff";

  red = "${theme.red}ff";
  green = "${theme.green}ff";
  yellow = "${theme.yellow}ff";
  blue = "${theme.blue}ff";
  magenta = "${theme.magenta}90";
in {
  programs.swaylock = {
    enable = true;
    settings = {
      indicator-radius = 75;
      color = background;
      bs-hl-color = red;
      caps-lock-bs-hl-color = red;
      caps-lock-key-hl-color = yellow;

      key-hl-color = yellow;
      layout-text-color = foreground;

      ring-color = magenta;
      ring-clear-color = red;
      ring-wrong-color = red;
      ring-caps-lock-color = yellow;
      ring-ver-color = blue;

      text-color = foreground;
      text-clear-color = red;
      text-wrong-color = red;
      text-caps-lock-color = yellow;
      text-ver-color = blue;

      layout-bg-color = blank;
      layout-border-color = blank;
      separator-color = blank;

      inside-color = blank;
      inside-clear-color = blank;
      inside-caps-lock-color = blank;
      inside-ver-color = blank;
      inside-wrong-color = blank;

      line-color = blank;
      line-clear-color = blank;
      line-caps-lock-color = blank;
      line-ver-color = blank;
      line-wrong-color = blank;
    };
  };
}
