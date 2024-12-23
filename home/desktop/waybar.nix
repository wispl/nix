{
  lib,
  theme,
  ...
}: {
  programs.waybar = {
    enable = true;
    settings.mainBar = lib.importJSON ./waybar_conf/pills/config.jsonc;
    style = ''
      @define-color fg #${theme.fg};

      @define-color bg0 #${theme.bgDDD};
      @define-color bg1 #${theme.bgDD};
      @define-color bg2 #${theme.bgD};
      @define-color bg  #${theme.bg};
      @define-color bg4 #${theme.bgL};
      @define-color bg5 #${theme.bgLL};
      @define-color bg6 #${theme.bgLLL};

      @define-color red     #${theme.red};
      @define-color green   #${theme.green};
      @define-color yellow  #${theme.yellow};
      @define-color blue    #${theme.blue};
      @define-color magenta #${theme.magenta};
      @define-color cyan    #${theme.cyan};

      @define-color bright-red     #${theme.brightRed};
      @define-color bright-green   #${theme.brightGreen};
      @define-color bright-yellow  #${theme.brightYellow};
      @define-color bright-blue    #${theme.brightBlue};
      @define-color bright-magenta #${theme.brightMagenta};
      @define-color bright-cyan    #${theme.brightCyan};
      ${builtins.readFile ./waybar_conf/pills/style.css}
    '';
  };
}
