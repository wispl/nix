# Applications, yes, applications and not terminal interfaces, wow.
#	blender (3D modelling)
#	inkscape (drawing)
#	keepassxc (password manager)
#	syncthing (syncing)
#	musikcube (syncing)
{pkgs, ...}: {
  home.packages = with pkgs; [
    blender
    inkscape
    keepassxc
    syncthing
    musikcube
  ];
}
