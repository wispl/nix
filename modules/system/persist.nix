# Persistance, otherwise my stuff goes poof permanently each time.
{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkMerge mkOption mkEnableOption;
  inherit (lib.types) listOf str;
  cfg = config.modules.persist;
in {
  imports = [inputs.impermanence.nixosModules.impermanence];

  options.modules.persist = {
    enable = mkEnableOption "persistance";
    directories = mkOption {
      type = listOf str;
      description = "Extra directories to persist";
    };
  };

  config = mkIf (cfg.enable) {
    environment.persistence."/nix/persist" = {
      hideMounts = true;
      directories =
        [
          "/var/log"
          "/var/lib/systemd/coredump"
          "/var/lib/nixos"
        ]
        ++ cfg.directories;
      files = [
        "/etc/machine-id"
      ];
    };
  };
}
