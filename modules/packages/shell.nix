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

          # prompt
          PS1='\[\e[34m\]\W\[\e[m\] '

          # Commands that should be applied only for interactive shells.
          [[ $- == *i* ]] || return

          # history settings
          HISTCONTROL=ignoredups
          HISTFILESIZE=100000
          HISTSIZE=10000

          shopt -s histappend
          shopt -s checkwinsize
          shopt -s extglob
          shopt -s globstar
          shopt -s checkjobs
          shopt -s no_empty_cmd_completion

          alias ..='cd ..'
          alias grep='grep --color=auto'
          alias la='ls -a'
          alias ll='ls -l'
          alias ls='ls --color=auto'
          alias ncdu='ncdu --color dark'
          alias vi='nvim'
          alias vim='nvim'
        ''
        + optionalString cfg.direnv.enable ''eval "$(${getExe pkgs.direnv} hook bash)"'';

      home.files.".profile".text = ''
        # load env variables
        . "${config.home.environment.loadEnv}"

        [[ $(tty) == /dev/tty1 ]] && river

        # source .bashrc
        [[ -f ~/.bashrc ]] && . ~/.bashrc
      '';

      home.environment.sessionVariables.INPUTRC = "${config.xdgdir.config}/readline/inputrc";
      home.files.".config/readline/inputrc".text = ''
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
      home.files.".config/direnv/direnv.toml" = {
        generator = (pkgs.formats.toml {}).generate "direnv.toml";
        value = {
          global = {
            hide_env_diff = true;
          };
        };
      };
    })

    (mkIf cfg.scripts.enable {
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
