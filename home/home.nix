{
  config,
  pkgs,
  outputs,
  specialArgs,
  ...
}: {
  imports = builtins.attrValues outputs.homeModules;

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

  colors = {
    fg = "c5c9c5";

    bgDDD = "0d0c0c";
    bgDD = "12120f";
    bgD = "1d1c19";
    bg = "181616";
    bgL = "282727";
    bgLL = "393836";
    bgLLL = "625e5a";

    selectedBg = "2d4f67";
    selectedFg = "c8c093";

    # colors
    black = "0d0c0c";
    red = "c4746e";
    green = "8a9a7b";
    yellow = "c4b28a";
    blue = "8ba4b0";
    magenta = "a292a3";
    cyan = "8ea4a2";
    white = "c8c093";

    brightBlack = "a6a69c";
    brightRed = "e46876";
    brightGreen = "87a987";
    brightYellow = "e6c384";
    brightBlue = "7fb4ca";
    brightMagenta = "938aa9";
    brightCyan = "7aa89f";
    brightWhite = "c5c9c5";

    # foot uses these, I am not quite sure what they are
    extraColor1 = "b6927b";
    extraColor2 = "b98d7b";
  };

  modules = {
    desktop = {
      enable = true;
      riverwm.enable = true;
      term = {
        foot.enable = true;
      };
      ui = {
        fuzzel.enable = true;
        waybar.enable = true;
      };
    };

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
      sioyek.enable = true;
    };

    dev = {
      cc.enable = true;
      sh.enable = true;
      rust.enable = true;
      tex.enable = true;
    };

    tui = {
      ncmpcpp.enable = true;
      lf.enable = true;
    };

    shell = {
      enable = true;
      direnv.enable = true;
      scripts.enable = true;
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
