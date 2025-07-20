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
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
