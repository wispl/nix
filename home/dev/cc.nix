{pkgs, ...}: {
  home.packages = with pkgs; [
    # cmake
    clang-tools
    gcc
    gdb
    valgrind
  ];
}
