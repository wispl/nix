{theme, ...}: {
  programs.sioyek = {
    enable = true;
    bindings = {
      # use embedded file picker by default, it is much faster
      "open_document_embedded" = "o";
      "screen_down" = "<C-f>";
      "screen_up" = "<C-b>";
      "close_window" = "q";
    };
    config = {
      "should_launch_new_window" = "1";
      "startup_commands" = "toggle_dark_mode 1";
      "collapsed_toc" = "1";

      "status_bar_font_size" = "18";
      "font_size" = "24";

      "text_highlight_color" = "#${theme.yellow}";
      "search_highlight_color" = "#${theme.yellow}";
      "link_highlight_color" = "#${theme.blue}";
      "synctex_highlight_color" = "#${theme.green}";

      "status_bar_color" = "#${theme.bgL}";
      "status_bar_text_color" = "#${theme.fg}";

      "dark_mode_background_color" = "#${theme.bg}";

      "ui_text_color" = "#${theme.fg}";
      "ui_background_color" = "#${theme.bg}";
      "ui_selected_text_color" = "#${theme.bg}";
      "ui_selected_background_color" = "#${theme.yellow}";
    };
  };
}
