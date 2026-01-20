{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkMerge mkIf mkEnableOption optionalString getExe;
  cfg = config.modules.packages.shell;
in {
  options.modules.packages.shell = {
    bash.enable = mkEnableOption "bash configuration";
    common.enable = mkEnableOption "common cli packages";
    direnv.enable = mkEnableOption "direnv";
    scripts.enable = mkEnableOption "enable user scripts";
    storage.enable = mkEnableOption "storage programs";
    media.enable = mkEnableOption "media programs";
    system.enable = mkEnableOption "system monitoring programs";
  };

  config = mkMerge [
    (mkIf cfg.bash.enable {
      home.files.".bashrc".text =
        ''
          # source completion
          if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
              . "${pkgs.bash-completion}/etc/profile.d/bash_completion.sh"
          fi

          # source eat (emacs)
          [ -n "$EAT_SHELL_INTEGRATION_DIR" ] && source "$EAT_SHELL_INTEGRATION_DIR/bash"

          # very shrimple prompt
          PS1='\[\e[34m\]\W\[\e[m\] '

          # Commands that should be applied only for interactive shells.
          [[ $- == *i* ]] || return

          # history settings
          HISTCONTROL=ignoredups
          HISTFILESIZE=100000
          HISTSIZE=10000

          # nicities
          shopt -s histappend
          shopt -s checkwinsize
          shopt -s extglob
          shopt -s globstar
          shopt -s checkjobs
          shopt -s no_empty_cmd_completion

          # aliases
          alias ..='cd ..'
          alias grep='grep --color=auto'
          alias la='ls -a'
          alias ll='ls -l'
          alias ls='ls --color=auto'
          alias ncdu='ncdu --color dark'
          alias vi='nvim'
          alias vim='nvim'

          # Quickly make something transparent
          function magick-transparent() {
              magick "$1" -fuzz 11% -transparent white "$1"
          }

          # Copy most recent screenshot here (with new name)
          function copy-screenshot() {
              files=( $XDG_PICTURES_DIR/*.png ); cp "''${files[-1]}" "$1"
          }

          # z and zoxide ripoff, depth 3 is good enough for me
          function z() {
              cd "$(fd . --base-directory $HOME --type d --color never --max-depth 3 | fzf --select-1 --query "$*")"
              ls
          }
        ''
        + optionalString cfg.direnv.enable ''eval "$(${getExe pkgs.direnv} hook bash)"'';

      home.files.".profile".text = ''
        # load env variables
        . "${config.home.environment.loadEnv}"

        # source .bashrc
        [[ -f ~/.bashrc ]] && . ~/.bashrc

        [[ $(tty) == /dev/tty1 ]] && exec niri-session -l
      '';

      home.environment.sessionVariables = {
        INPUTRC = "${config.xdgdir.config}/readline/inputrc";
        HISTFILE = "${config.xdgdir.state}/bash_history";
      };

      home.xdg.config.files."readline/inputrc".text = ''
        $include /etc/inputrc
        set colored-completion-prefix on
        set colored-stats on
        set completion-ignore-case on
        set completion-prefix-display-length 5
        set echo-control-characters off
        set menu-complete-display-prefix on
        set show-all-if-ambiguous on
        set show-all-if-unmodified on
        set skip-completed-text on
        "\t": menu-complete
        "\e[Z": menu-complete-backward
      '';
    })

    (mkIf cfg.common.enable {
      home.packages = with pkgs; [
        bc
        btop
        fd
        fzf
        ripgrep
        tree
        jq

        # :)
        fastfetch
        pfetch
      ];
    })

    (mkIf cfg.direnv.enable {
      home.packages = with pkgs; [direnv nix-direnv];
      home.xdg.config.files = {
        "direnv/direnv.toml" = {
          generator = (pkgs.formats.toml {}).generate "direnv.toml";
          value = {
            global = {
              hide_env_diff = true;
            };
          };
        };
        # place .direnv cache on tmpfs and centralize it
        # easier to clean up, less clutter and slight more performance
        # on tmpfs means the cache has to be recreated each reboot
        # but that is generally fine and not too annoying (I think)
        # see: https://github.com/direnv/direnv/wiki/Customizing-cache-location
        "direnv/direnvrc".text = ''
          source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc

          : ''${XDG_RUNTIME_DIR:=/run/user/$UID}
          declare -A direnv_layout_dirs
          direnv_layout_dir() {
              local hash path
              echo "''${direnv_layout_dirs[$PWD]:=$(
              hash="''$(sha1sum - <<< "$PWD" | head -c40)"
                  path="''${PWD//[^a-zA-Z0-9]/-}"
                  echo "''${XDG_RUNTIME_DIR}/direnv/layouts/''${hash}''${path}"
              )}"
          }
        '';
      };
    })

    (mkIf cfg.scripts.enable {
      home.packages = [pkgs.wtype];
      home.files.".local/bin".source = ../../bin;
    })

    (mkIf cfg.storage.enable {
      home.packages = with pkgs; [
        ncdu
        nix-tree
        unzip
      ];
    })

    (mkIf cfg.media.enable {
      home.packages = with pkgs; [
        pandoc
        ghostscript
        imagemagick
        ffmpeg
        yt-dlp
        imv
        mpv
      ];
    })

    (mkIf cfg.system.enable {
      home.packages = with pkgs; [
        radeontop
        powertop
        pciutils
        nvme-cli
        smartmontools
      ];
    })
  ];
}
