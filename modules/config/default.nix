# Config of the config, bascially the important top level configuration
# options. These should be options which are either commonly set on most of my
# machines, like git, shell, and user, or configurations which have sweeping
# changes, like services and color/theme.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules;
in {
  imports = [./colors.nix ./services.nix ./editors.nix];
  options.modules = {
    user = lib.mkOption {
      type = lib.types.str;
      default = "wisp";
    };
    shell.enable = lib.mkEnableOption "configure bash and readline";
    git.enable = lib.mkEnableOption "configure git";
  };

  # TODO: these should be cleaned up and made more generic
  config = lib.mkMerge [
    (lib.mkIf (cfg.user == "wisp") {
      home = {
        username = "wisp";
        homeDirectory = "/home/wisp";
        sessionPath = ["$HOME/.local/bin"];
        sessionVariables = {
          TERMINAL = "foot";
          # Wallpaper symlink, so switching wallpapers do not take a rebuild
          WALLPAPER = "${config.xdg.stateHome}/wallpaper";
          # PATH to the directory of the root flake.nix. This is used for
          # mkOutOfStoreSymlinks for configs like neovim and scripts.
          FLAKE = "${config.home.homeDirectory}/flakes";
        };
      };

      systemd.user.startServices = "sd-switch";
      programs.home-manager.enable = true;
    })

    (lib.mkIf (cfg.user == "wisp" && cfg.git.enable) {
      programs.git = {
        enable = true;
        userName = "wispl";
        userEmail = "wispl.8qbkk@slmail.me";
        aliases = {
          lg = "log --graph --oneline --color";
        };
        extraConfig = {
          init.defaultBranch = "main";
          diff.algorithm = "histogram";
          merge.conflictStyle = "zdiff3";
        };
        ignores = [".direnv"];
      };
    })

    (lib.mkIf cfg.shell.enable {
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
    })
  ];
}
