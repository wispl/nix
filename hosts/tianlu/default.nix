{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking.hostName = "tianlu";
  services.openssh.enable = true;
  sops.secrets.cheese = {};
  modules = {
    username = "wisp";
    git.enable = true;
    profile = "server";
    deploy = ["authelia"];
    hardware = ["redist" "iwd"];
    persist = {
      enable = true;
      directories = [
        "/var/lib/iwd" # save network configurations
        "/var/lib/incus/" # prevent incus from blowing up
      ];
      userDirectories = [
        "flakes"
        "services"
        ".config"
        ".ssh"
      ];
    };
    editors = {
      default = "nvim";
      nvim.enable = true;
    };
    packages = {
      extras = with pkgs; [openssl opentofu];
      shell.bash.enable = true;
    };
  };
  system.stateVersion = "25.11";
}
