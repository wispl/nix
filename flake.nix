# TODO: https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde/
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    impermanence,
    nixos-hardware,
    hjem,
    disko,
  } @ inputs: let
    inherit (self) outputs;
    systems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    modules = import ./modules;
  in {
    packages = forAllSystems (system: import ./packages nixpkgs.legacyPackages.${system});
    nixosConfigurations = {
      snow = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/snow] ++ [modules];
      };
      tianlu = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/tianlu] ++ [modules];
      };
    };
  };
}
