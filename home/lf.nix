{pkgs, ...}: {
  programs.lf = {
    enable = true;
    settings = {
      shell = "sh";
      shellopts = "-eu";
      ifs = "\\n";
      scrolloff = 10;

      # highlight instead of underline preview
      cursorpreviewfmt = "\\033[7;2m";

      incsearch = true;
      sixel = true;
    };
    keybindings = {
      D = "delete";
      # show the result of execution of previous commands
      "`" = "!true";

      # use enter for shell commands
      "<enter>" = "shell";

      # execute current file (must be executable)
      x = "$$f";
      X = "!$f";

      # mkdir command. See wiki if you want it to select created dir
      a = ":push %mkdir<space>";

      # dedicated keys for file opener actions
      o = "&xdg-open $f";
      O = "$xdg-open --ask $f";
    };
    previewer.source = pkgs.writeShellScript "pv.sh" ''
             #!/bin/sh
             case "$(file -Lb --mime-type -- "$1")" in
                 image/*)
             	chafa -f sixel -s "''${2}x''${3}" --animate off --polite on "$1"
             	exit 1
             	;;
                 application/pdf)
      magick "''${1}[0]" jpg:- | chafa -s "''${2}x''${3}" -f sixel --polite on --animate off
             	exit 1
             	;;
                 *)
             	cat "$1"
             	exit 1
             	;;
             esac
    '';
    previewer.keybinding = "-";
    commands = {
      # define a custom 'open' command
      # This command is called when current file is not a directory. You may want to
      # use either file extensions and/or mime types here. Below uses an editor for
      # text files and a file opener for the rest.
      open = ''        ''${{
        		    case $(file --mime-type -Lb $f) in
        		    text/*) lf -remote "send $id \$$EDITOR \$fx";;
        			  *) for f in $fx; do $OPENER $f > /dev/null 2> /dev/null & done;;
        			  esac
        		    }}'';

      # extract the current file with the right command
      # (xkcd link: https://xkcd.com/1168/)
      extract = ''        ''${{
        		   set -f
        		   case $f in
        			  *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) tar xjvf $f;;
        			  *.tar.gz|*.tgz) tar xzvf $f;;
        			  *.tar.xz|*.txz) tar xJvf $f;;
        			  *.zip) unzip $f;;
        			  *.rar) unrar x $f;;
        			  *.7z) 7z x $f;;
        			  esac
        			  }}'';

      # compress current file or selected files with tar and gunzip
      tar = ''        ''${{
        		   set -f
        		   mkdir $1
        		   cp -r $fx $1
        		   tar czf $1.tar.gz $1
        		   rm -rf $1
        		   }}'';

      # compress current file or selected files with zip
      zip = ''        ''${{
        		   set -f
        		   mkdir $1
        		   cp -r $fx $1
        		   zip -r $1.zip $1
        		   rm -rf $1
        		   }}'';
    };
  };
}
