{theme, ...}: {
  services.mako = {
    enable = true;
    font = "DejaVu Sans Mono 12";
    borderSize = 2;
    borderRadius = 2;
    icons = true;
    padding = "10";
    defaultTimeout = 3000;
    width = 400;

    textColor = "#${theme.fg}";
    backgroundColor = "#${theme.bg}";
    borderColor = "#${theme.blue}";
    progressColor = "over #${theme.yellow}";

    extraConfig = "[urgency=high]\nborder-color=#${theme.red}\ndefault-timeout=0";
  };
}
