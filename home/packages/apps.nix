# The usual :)
{pkgs, ...}: {
  home.packages = with pkgs; [
    blender
    inkscape
    keepassxc
    syncthing
    openconnect
    renderdoc
  ];
}
