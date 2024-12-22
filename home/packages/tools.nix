# Tools, tools, and tools
{pkgs, ...}: {
  home.packages = with pkgs; [
    libva-utils
    mesa-demos
    nvme-cli
    pciutils
    smartmontools
    vdpauinfo
    vulkan-tools
  ];
}
