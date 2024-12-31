{
  config,
  pkgs,
  specialArgs,
  ...
}: {
  imports = with specialArgs.theme; [
    ./base

    ./desktop/river.nix

    ./dev/cc.nix
    ./dev/sh.nix
    ./dev/rust.nix

    ./firefox
    ./packages
    ./nvim.nix
  ];

  home = {
    username = "wisp";
    homeDirectory = "/home/wisp";
    sessionPath = ["$HOME/.local/bin"];
    sessionVariables = {
      TERMINAL = "foot";
      # PATH to the directory of the root flake.nix. This is used for
      # mkOutOfStoreSymlinks for configs like neovim.
      FLAKE = "${config.home.homeDirectory}/flakes";
    };
  };

  home.packages = with pkgs; [
    alejandra

    xdg-utils
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

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    git.enable = true;

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
