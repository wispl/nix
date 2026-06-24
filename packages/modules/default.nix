{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib.fileset) toList fileFilter;
in {
  imports = toList (fileFilter (file: file.name != "default.nix" && file.name != "utils.nix" && file.hasExt "nix") ./.);
}
