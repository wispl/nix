{
  description = "Nix flake template for Kubernetes";
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
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            openshift
            kubernetes-helm
            argocd
            kubeseal
          ];
          shellHook = ''
            export KUBECONFIG=$XDG_CONFIG_HOME/kube
            export KUBECACHEDIR=$XDG_CACHE_HOME/kube
          '';
        };
      }
    );
}
