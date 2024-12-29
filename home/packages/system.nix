# Packages for managing or querying system information such as hardware
{pkgs, ...}: {
  home.packages = with pkgs; [
    amdgpu_top
    libva-utils
    mesa-demos
    nvme-cli
    pciutils
    smartmontools
    vdpauinfo
    vulkan-tools
  ];
}
