# I like tui, it makes configuring things very easy and tui-fic. All I need to
# do is configure my terminal and bam... though I have been told to leave my
# tui and go touch gui before...
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkMerge mkIf;
  cfg = config.modules.packages.tui;
in {
  options.modules.packages.tui = {
    lf.enable = mkEnableOption "lf";
    nnn.enable = mkEnableOption "nnn";
    ncmpcpp.enable = mkEnableOption "ncmpcpp";
  };

  config = mkMerge [
    # pretty minimal file browser with decent preview support
    (mkIf cfg.lf.enable {
      home.packages = with pkgs; [lf chafa file ctpv];
      home.xdg.config.files = {
        "lf/lfrc".text = ''
          set shell "sh"
          set shellopts "-eu"
          set ifs "\n"

          set scrolloff 10
          set cursorpreviewfmt "\033[7;2m"

          set incsearch
          set sixel

          map <enter> shell

          map o &xdg-open $f

          map D delete
          map a :push %mkdir<space>

          cmd rename %[ -e $1 ] && printf "file exists" || mv $f $1
          map r push :rename<space>

          set previewer ctpv
          set cleaner ctpvclear
          &ctpv -s $id
          &ctpvquit $id
          cmd extract ''\${{
            set -f
            case $f in
              *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) tar xjvf $f;;
              *.tar.gz|*.tgz) tar xzvf $f;;
              *.tar.xz|*.txz) tar xJvf $f;;
              *.zip) unzip $f;;
              *.rar) unrar x $f;;
              *.7z) 7z x $f;;
            esac
          }}
        '';
        "ctpv/config".text = ''
          set chafasixel
        '';
      };
    })

    (mkIf cfg.nnn.enable {
      home.packages = with pkgs; [nnn];
    })

    # impossible to type mpd music player
    (mkIf cfg.ncmpcpp.enable {
      home.packages = with pkgs; [ncmpcpp];
      home.xdg.config.files = {
        "ncmpcpp/config".text = ''
          lyrics_directory=~/music/lyrics
          mpd_music_dir=~/music/
          progressbar_look=━━╸
        '';

        "ncmpcpp/bindings".text = ''
          def_key "j"
            scroll_down
          def_key "k"
            scroll_up
          def_key "J"
            select_item
            scroll_down
          def_key "K"
            select_item
            scroll_up
          def_key "h"
            previous_column
          def_key "l"
            next_column
          def_key "L"
            show_lyrics
          def_key "up"
            volume_up
          def_key "down"
            volume_down
        '';
      };
    })
  ];
}
