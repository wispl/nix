# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=8G" "mode=755"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/cb6c57c9-d7ce-4343-8637-40ddc0a6243e";
    fsType = "btrfs";
    options = ["subvol=@nix" "noatime" "compress=lzo"];
  };

  boot.initrd.luks.devices."crypt".device = "/dev/disk/by-uuid/0f45daf3-f391-424a-8b71-5af96ff9ad48";

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/cb6c57c9-d7ce-4343-8637-40ddc0a6243e";
    fsType = "btrfs";
    options = ["subvol=@home" "noatime" "compress=lzo"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/55D1-0B65";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022" "umask=0077"];
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault false;
  # networking.interfaces.enp2s0f0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault false;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
