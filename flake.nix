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
    nixosConfigurations = {
      snow = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/configuration.nix
          impermanence.nixosModules.impermanence
          home-manager.nixosModules.home-manager
          nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {theme = import ./themes/kanagawa.nix;};
            home-manager.users.wisp = import ./home/home.nix;
          }
        ];
      };
    };
  };
}
