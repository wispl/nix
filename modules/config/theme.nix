{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkMerge mkIf;
  cfg = config.modules;
in {
  options.modules.theme = mkOption {
    type = lib.types.str;
  };

  # TODO: use mkDefault?
  config = mkMerge [
    (mkIf (cfg.theme == "kanagawa") {
      # kanagawa
      colors = {
        fg = "c5c9c5";

        bgDDD = "0d0c0c";
        bgDD = "12120f";
        bgD = "1d1c19";
        bg = "181616";
        bgL = "282727";
        bgLL = "393836";
        bgLLL = "625e5a";

        selectedBg = "2d4f67";
        selectedFg = "c8c093";

        # colors
        black = "0d0c0c";
        red = "c4746e";
        green = "8a9a7b";
        yellow = "c4b28a";
        blue = "8ba4b0";
        magenta = "a292a3";
        cyan = "8ea4a2";
        white = "c8c093";

        brightBlack = "a6a69c";
        brightRed = "e46876";
        brightGreen = "87a987";
        brightYellow = "e6c384";
        brightBlue = "7fb4ca";
        brightMagenta = "938aa9";
        brightCyan = "7aa89f";
        brightWhite = "c5c9c5";

        # foot uses these, I am not quite sure what they are
        extraColor1 = "b6927b";
        extraColor2 = "b98d7b";
      };
    })
  ];
}
