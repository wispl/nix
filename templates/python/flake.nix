{
  description = "Nix flake template for Python";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        # change python version here
        pyPkgs = pkgs.python313Packages;
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            (pyPkgs.withPackages (python-pkgs: [
              # python packages go here
            ]))
          ];
        };
      }
    );
}
