{
  config,
  pkgs,
  outputs,
  ...
}: {
  imports = builtins.attrValues outputs.homeModules;

  home.packages = with pkgs; [
    alejandra
    blender
    inkscape
    keepassxc
    syncthing
    openconnect
    renderdoc
    qemu
    openrocket
  ];

  modules = {
    user = "wisp";
    theme = "kanagawa";
    git.enable = true;
    shell.enable = true;
    editors.nvim.enable = true;
    services = {
      mpd.enable = true;
      psd.enable = true;
    };

    desktop = {
      enable = true;
      riverwm.enable = true;
      term = {
        foot.enable = true;
      };
      ui = {
        fuzzel.enable = true;
        waybar.enable = true;
        eww.enable = true;
      };
    };

    packages = {
      apps = {
        firefox.enable = true;
        sioyek.enable = true;
      };
      cli = {
        common.enable = true;
        direnv.enable = true;
        scripts.enable = true;
        storage.enable = true;
        media.enable = true;
        system.enable = true;
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
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
