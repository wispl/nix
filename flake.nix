# TODO: https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde/
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Root filesystem on tmpfs (what if you machine has anmesia?)
    impermanence.url = "github:nix-community/impermanence";
    # Common hardware fixes
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Declarative disk partitioning
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    # Lightweight "home-manager"
    hjem.url = "github:feel-co/hjem";
    hjem.inputs.nixpkgs.follows = "nixpkgs";
    # Terraforming nix, or eating tofu, whichever you like better
    terranix.url = "github:terranix/terranix";
    terranix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    impermanence,
    nixos-hardware,
    hjem,
    disko,
    terranix,
  } @ inputs: let
    inherit (self) outputs;
    systems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    modules = import ./modules;
  in {
    packages = forAllSystems (system: import ./packages {
      inherit system terranix;
      pkgs = nixpkgs.legacyPackages.${system};
    });

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
