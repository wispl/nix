{pkgs, ...}: {
  home.packages = with pkgs; [shellcheck-minimal];
}
