# TODO: https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde/
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = {
    self,
    nixpkgs,
    impermanence,
    home-manager,
    nixos-hardware,
  } @ inputs: let
    inherit (self) outputs;
  in {
    homeModules = import ./modules;
    nixosConfigurations = {
      snow = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/configuration.nix
          impermanence.nixosModules.impermanence
          nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
        ];
      };
    };
  };
}
