{...}: let
  foreground = "#c5c9c5";
  background = "#181616";
  light-background = "#282727";

  red = "#c4746e";
  green = "#8a9a7b";
  yellow = "#c4b28a";
  blue = "#8ba4b0";
  magenta = "#a292a3";
  cyan = "#8ea4a2";
in {
  programs.sioyek = {
    enable = true;
    bindings = {
      # use embedded file picker by default, it is much faster
      "open_document_embedded" = "o";
      "screen_down" = "<C-f>";
      "screen_up" = "<C-b>";
    };
    config = {
      "status_bar_font_size" = "18";
      "font_size" = "24";

      "text_highlight_color" = yellow;
      "search_highlight_color" = yellow;
      "link_highlight_color" = blue;
      "synctex_highlight_color" = green;

      "ui_selected_background_color" = light-background;
      "status_bar_color" = light-background;
      "status_bar_text_color" = magenta;

      "default_dark_mode" = "1";
      "dark_mode_background_color" = background;
    };
  };
}
