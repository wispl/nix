{
  config,
  pkgs,
  specialArgs,
  ...
}: {
  imports = with specialArgs.theme; [
    ./base

    ./desktop/river.nix
    ./editors/nvim.nix

    ./packages

    ./dev/cc.nix
    ./dev/sh.nix
    ./dev/rust.nix
  ];

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

  home.packages = with pkgs; [alejandra];

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
