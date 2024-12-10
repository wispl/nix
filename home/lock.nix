{...}: let
  blank = "00000000";
  foreground = "c5c9c5";
  background = "181616";

  # red, green, yellow, blue, magenta, cyan, white
  red = "c4746eff";
  green = "8a9a7bff";
  yellow = "c4b28aff";
  blue = "8ba4b0ff";
  magenta = "a292a390";
  cyan = "8ea4a2ff";
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
