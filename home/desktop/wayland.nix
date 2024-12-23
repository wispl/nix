# Nix files for wayland compositors should import this file, which sets up some
# common configurations for wayland compositors
#	cursors
#	gtk
#	qt
{pkgs, ...}: {
  home.packages = with pkgs; [
    dconf
    rose-pine-cursor
    # graphite-kde-theme
    # graphite-gtk-theme
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
}
