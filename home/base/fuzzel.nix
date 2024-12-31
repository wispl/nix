# Launcher, menu, fuzzy matcher, and probably also a rudimentary ui.
{theme, ...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "monospace, Symbols Nerd Font:size=12";
        prompt = "' '";
        # until I find a good icon theme
        icons-enabled = false;
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
        prompt = "${theme.yellow}ff";
        placeholder = "${theme.fg}90";
        background = "${theme.bg}ff";
        text = "${theme.fg}ff";
        match = "${theme.red}ff";
        selection = "${theme.magenta}ff";
        selection-text = "${theme.bg}ff";
        counter = "${theme.magenta}ff";
        border = "${theme.bgL}ff";
      };
    };
  };
}
