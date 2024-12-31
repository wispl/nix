# Packages for the shell
#	terminal utilities,
#	cli tools,
# and all the other good stuff. Without this the shell is but a mere shell of
# itself. Sorry.
{pkgs, ...}: {
  home.packages = with pkgs; [
    # calculator
    bc

    # system load
    btop

    # files
    fd
    fzf
    ripgrep
    tree
    # json
    jq
    # optimizing space
    ncdu
    nix-tree

    # documents and images
    pandoc
    ghostscript
    imagemagick

    # of course
    fastfetch
    pfetch

    # media
    yt-dlp
    imv
    mpv

    # zip it
    unzip
  ];
}
