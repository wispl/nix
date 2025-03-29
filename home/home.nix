{
  config,
  pkgs,
  outputs,
  specialArgs,
  ...
}: {
  imports = with specialArgs.theme;
    [
      ./base
      ./desktop/river.nix
      ./packages
    ]
    ++ (builtins.attrValues outputs.homeModules);

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

  modules = {
    editors = {
      nvim.enable = true;
    };

    apps = {
      blender.enable = true;
      inkscape.enable = true;
      keepassxc.enable = true;
      syncthing.enable = true;
      openconnect.enable = true;
      renderdoc.enable = true;
      firefox.enable = true;
      qemu.enable = true;
    };

    dev = {
      cc.enable = true;
      sh.enable = true;
      rust.enable = true;
      tex.enable = true;
    };

    shell = {
      enable = true;
      formats.enable = true;
      storage.enable = true;
      media.enable = true;
      system.enable = true;
    };

    services = {
      mpd.enable = true;
      psd.enable = true;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
