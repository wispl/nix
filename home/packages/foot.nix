{theme, ...}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        # font = "Deja Vu Sans Mono:size=16";
        # font = "Iosevka Term SS04 Extended:size=20,Symbols Nerd Font:size=18";
        font = "Julia Mono:size=18, Symbols Nerd Font Mono:size=18";
        pad = "40x40center";
      };
      colors = {
        alpha = "0.97";
        foreground = "${theme.fg}";
        background = "${theme.bg}";

        selection-foreground = "${theme.selectedFg}";
        selection-background = "${theme.selectedBg}";

        regular0 = "${theme.black}";
        regular1 = "${theme.red}";
        regular2 = "${theme.green}";
        regular3 = "${theme.yellow}";
        regular4 = "${theme.blue}";
        regular5 = "${theme.magenta}";
        regular6 = "${theme.cyan}";
        regular7 = "${theme.white}";

        bright0 = "${theme.brightBlack}";
        bright1 = "${theme.brightRed}";
        bright2 = "${theme.brightGreen}";
        bright3 = "${theme.brightYellow}";
        bright4 = "${theme.brightBlue}";
        bright5 = "${theme.brightMagenta}";
        bright6 = "${theme.brightCyan}";
        bright7 = "${theme.brightWhite}";

        "16" = "${theme.extraColor1}";
        "17" = "${theme.extraColor2}";
      };
      tweak = {
        box-drawing-base-thickness = 0.08;
      };
    };
  };
}
