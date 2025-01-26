# mpd and ncpmpcpp. Did I spelt that correctly?
{
  services.mpd = {
    enable = true;
    network.startWhenNeeded = true;
    # TODO: for some reason the default is broken
    musicDirectory = "~/music/";
  };

  # I did not
  programs.ncmpcpp = {
    enable = true;
    bindings = [
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "J";
        command = ["select_item" "scroll_down"];
      }
      {
        key = "K";
        command = ["select_item" "scroll_up"];
      }
      {
        key = "h";
        command = "previous_column";
      }
      {
        key = "l";
        command = "next_column";
      }
      {
        key = "L";
        command = "show_lyrics";
      }
      {
        key = "up";
        command = "volume_up";
      }
      {
        key = "down";
        command = "volume_down";
      }
    ];
    settings = {
      lyrics_directory = "~/music/lyrics";
      progressbar_look = "━━╸";
    };
  };
}
