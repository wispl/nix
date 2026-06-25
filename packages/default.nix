{
  pkgs,
  terranix,
  system,
}: let
  modules = import ./modules;
in rec {
  riverstream = pkgs.callPackage ./riverstream {};

  server = terranix.lib.terranixConfiguration {
    inherit system;
    modules = [./server] ++ [modules];
  };
}
