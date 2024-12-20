{
  pkgs,
  specialArgs,
  ...
}: {
  imports = with specialArgs.theme; [
    ./desktop
    ./firefox
    ./waybar

    ./foot.nix
    ./fuzzel.nix

    ./nvim.nix
    ./lf.nix

    ./scripts.nix

    ./texlive.nix
    ./sioyek.nix
  ];

  home = {
    username = "wisp";
    homeDirectory = "/home/wisp";
  };

  home.sessionVariables = {
    TERMINAL = "foot";
  };

  home.sessionPath = ["$HOME/.local/bin"];

  # TODO: move and sepatate these
  home.packages = with pkgs; [
    # applications
    blender
    inkscape
    keepassxc
    syncthing
    musikcube

    # commandline tools
    bc
    btop
    chafa
    fastfetch
    fd
    file
    fzf
    ghostscript
    imagemagick
    imv
    jq
    mpv
    ncdu
    nix-tree
    nvme-cli
    pandoc
    pfetch
    ripgrep
    tree
    unzip
    yt-dlp

    # hardware related
    amdgpu_top
    libva-utils
    mesa-demos
    pciutils
    powertop
    smartmontools
    vdpauinfo
    vulkan-tools

    xdg-utils

    # coding
    gcc
    gdb
    valgrind
    alejandra
    chicken

    qemu
  ];

  xdg = {
    userDirs = {
      enable = true;
      desktop = "\$HOME/";
      documents = "\$HOME/documents";
      download = "\$HOME/tmp";
      music = "\$HOME/music";
      pictures = "\$HOME/pictures";
    };
    mimeApps = {
      enable = true;
    };
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    bash = {
      enable = true;
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
    readline = {
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

  services = {
    ssh-agent.enable = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
