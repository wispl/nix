{
  lib,
  ...
} : {
  # What I consider good defaults for all my systems
  # Hopefully this gets smaller as time goes on

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.configurationLimit = lib.mkDefault 10;

    bcache.enable = false;
    tmp.useTmpfs = true;
  };

  # Swap but on ram, great for btrfs so I don't have to
  # make a swapfile.
  zramSwap.enable = true;

  # Use nftables for firewall, cooler than iptables, iptables is like
  # calling a grapefruit a fruit.
  networking.nftables.enable = true;

  # Use dbus broker as the dbus implementation, this comes with the caveat
  # of a lot of ignored "..." file errors, which are apparently harmless.
  services.dbus.implementation = "broker";
}
