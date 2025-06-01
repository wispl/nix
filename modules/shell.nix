{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.shell;
in {
  options.modules.shell = {
    enable = mkEnableOption "bash configuration and general shell programs";
    direnv.enable = mkEnableOption "direnv";
    scripts.enable = mkEnableOption "custom scripts in .local/bin/";
    formats.enable = mkEnableOption "formatting programs";
    storage.enable = mkEnableOption "storage programs";
    media.enable = mkEnableOption "media programs";
    system.enable = mkEnableOption "system monitoring programs";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [
        bc
        btop
        fd
        fzf
        ripgrep
        tree

        # :)
        fastfetch
        pfetch
      ];

      programs.bash = {
        enable = true;
        # TODO: find a way to not do this...
        profileExtra = ''
          export DIRENV_LOG_FORMAT=$'\033[2mdirenv: %s\033[0m'
          [[ $(tty) == /dev/tty1 ]] && river
        '';
        historyControl = ["ignoredups"];
        bashrcExtra = "PS1='\\[\\e[34m\\]\\W\\[\\e[m\\] '";
        shellAliases = {
          ls = "ls --color=auto";
          la = "ls -a";
          ll = "ls -l";
          ".." = "cd ..";
          grep = "grep --color=auto";
          ncdu = "ncdu --color dark";
          dots = "git --git-dir=$HOME/.dots/ --work-tree=$HOME";
        };
        shellOptions = ["histappend" "checkwinsize" "extglob" "globstar" "checkjobs" "no_empty_cmd_completion"];
      };

      programs.readline = {
        enable = true;
        variables = {
          "completion-ignore-case" = true;
          "skip-completed-text" = true;

          # Partially complete command and show all possible completions
          "show-all-if-ambiguous" = true;
          "show-all-if-unmodified" = true;

          # Color files by types
          # Note that this may cause completion text blink in some terminals (e.g. xterm).
          "colored-stats" = true;

          # Color the common prefix
          "colored-completion-prefix" = true;
          # Color the common prefix in menu-complete
          "menu-complete-display-prefix" = true;
          # Limit common prefix length to 5, replace longer ones with ellipses
          "completion-prefix-display-length" = 5;

          # Keeps the terminal tidy
          "echo-control-characters" = false;
        };
        bindings = {
          # Pressing tab cycles through completion items
          "\t" = "menu-complete";
          "\\e[Z" = "menu-complete-backward";
        };
      };
    }

    (mkIf cfg.direnv.enable {
      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };
    })

    (mkIf cfg.scripts.enable {
      home.file = {
        ".local/bin" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.FLAKE}/bin";
          recursive = true;
        };
      };
    })

    (mkIf cfg.formats.enable {
      home.packages = with pkgs; [
        jq
        unzip
      ];
    })

    (mkIf cfg.storage.enable {
      home.packages = with pkgs; [
        ncdu
        nix-tree
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
        amdgpu_top
        libva-utils
        nvme-cli
        pciutils
        smartmontools
        vdpauinfo
        vulkan-tools
        powertop
      ];
    })
  ]);
}
