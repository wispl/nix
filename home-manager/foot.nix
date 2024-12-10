{...}: let
  foreground = "c5c9c5";
  background = "181616";

  selection-foreground = "c8c093";
  selection-background = "2d4f67";

  # black, red, green, yellow, blue, magenta, cyan, white
  c0 = "0d0c0c";
  c1 = "c4746e";
  c2 = "8a9a7b";
  c3 = "c4b28a";
  c4 = "8ba4b0";
  c5 = "a292a3";
  c6 = "8ea4a2";
  c7 = "c8c093";

  # bright varians
  b0 = "a6a69c";
  b1 = "e46876";
  b2 = "87a987";
  b3 = "e6c384";
  b4 = "7fb4ca";
  b5 = "938aa9";
  b6 = "7aa89f";
  b7 = "c5c9c5";

  # extra colors
  ex16 = "b6927b";
  ex17 = "b98d7b";
in {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        # font = "Deja Vu Sans Mono:size=16";
        # font = "Iosevka Term SS04 Extended:size=20,Symbols Nerd Font:size=18";
        font = "Julia Mono:size=18, Symbols Nerd Font:size=18";
        pad = "40x40center";
      };
      colors = {
        alpha = "0.97";
        foreground = foreground;
        background = background;
        regular0 = c0;
        regular1 = c1;
        regular2 = c2;
        regular3 = c3;
        regular4 = c4;
        regular5 = c5;
        regular6 = c6;
        regular7 = c7;

        bright0 = b0; # bright black
        bright1 = b1; # bright red
        bright2 = b2; # bright green
        bright3 = b3; # bright yellow
        bright4 = b4;
        bright5 = b5; # bright magenta
        bright6 = b6; # bright cyan
        bright7 = b7; # bright white
      };
    };
  };
}
