{
  config,
  pkgs,
  outputs,
  ...
}: {
  imports = builtins.attrValues outputs.homeModules;

  home.packages = with pkgs; [
    outputs.packages.${system}.riverstream
    alejandra
    blender
    inkscape
    keepassxc
    syncthing
    openconnect
    renderdoc
    qemu
    openrocket
    podman-compose
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
      ssh-agent.enable = true;
    };

    desktop = {
      enable = true;
      riverwm.enable = true;
      term = {
        default = "foot";
        foot.enable = true;
      };
      ui = {
        fuzzel.enable = true;
        eww.enable = true;
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
