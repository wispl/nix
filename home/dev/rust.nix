{pkgs, ...}: {
  home.packages = with pkgs; [cargo rustfmt clippy];
}
