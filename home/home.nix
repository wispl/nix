{
  pkgs,
  specialArgs,
  ...
}: {
  imports = with specialArgs.theme; [
    ./waybar
    ./firefox

    ./lock.nix
    ./foot.nix
    ./fuzzel.nix
    ./mako.nix

    ./nvim.nix
    ./lf.nix

    # ./sway.nix
    ./river.nix
    ./scripts.nix

    ./texlive.nix
    ./sioyek.nix
  ];
  home = {
    username = "wisp";
    homeDirectory = "/home/wisp";
  };

  home.sessionVariables = {
    XCURSOR_THEME = "BreezeX-RosePine-Linux";
    XCURSOR_SIZE = "32";
    TERMINAL = "foot";
    DIRENV_LOG_FORMAT = "\033[2mdirenv: %s\033[0m";
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
    fd
    file
    ghostscript
    imagemagick
    imv
    jq
    libnotify
    mpv
    ncdu
    nvme-cli
    pandoc
    pfetch
    fastfetch
    ripgrep
    smartmontools
    tree
    unzip
    yt-dlp
    nix-tree

    # hardware related
    amdgpu_top
    powertop
    pciutils
    mesa-demos
    vulkan-tools
    libva-utils
    vdpauinfo

    # window manager related
    brightnessctl
    grim
    slurp
    swaybg
    wf-recorder
    wl-clipboard
    wlopm
    xdg-utils

    # coding
    chicken
    alejandra
    cmake
    gdb
    valgrind

    # appearance
    dconf
    rose-pine-cursor
    # graphite-kde-theme
    # graphite-gtk-theme

    qemu
  ];

  home.pointerCursor = {
    gtk.enable = true;
    size = 32;
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
  };

  gtk = {
    enable = true;
  };

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
      profileExtra = "[[ $(tty) == /dev/tty1 ]] && river";
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
    swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock}/bin/swaylock -f";
        }
      ];
      timeouts = [
        {
          timeout = 300;
          command = "${pkgs.swaylock}/bin/swaylock -f";
        }
        {
          timeout = 330;
          command = "${pkgs.wlopm}/bin/wlopm  --off '*'";
          resumeCommand = "${pkgs.wlopm}/bin/wlopm  --on '*'";
        }
      ];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
