{pkgs ? import <nixpkgs> {}, ...}: rec {
  riverstream = pkgs.callPackage ./riverstream {};
}
