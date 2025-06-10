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
  };

  config = mkIf cfg.enable {
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
  };
}
