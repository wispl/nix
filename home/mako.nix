{...}: let
  foreground = "#c5c9c5";
  background = "#181616";

  # red, green, yellow, blue, magenta, cyan, white
  red = "#c4746e";
  green = "#8a9a7b";
  yellow = "#c4b28a";
  blue = "#8ba4b0";
  magenta = "#a292a3";
  cyan = "#8ea4a2";
in {
  services.mako = {
    enable = true;
    font = "DejaVu Sans Mono 12";
    borderSize = 2;
    borderRadius = 4;
    padding = "10";
    defaultTimeout = 3000;

    textColor = foreground;
    backgroundColor = background;
    borderColor = blue;
    progressColor = "over ${yellow}";

    # not sure why multiline does not work
    extraConfig = "[urgency=high]\nborder-color=${red}\ndefault-timeout=0";
  };
}
