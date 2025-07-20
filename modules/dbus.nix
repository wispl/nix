{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) listOf package;
in {
  imports = [ inputs.hjem.nixosModules.hjem ];

  options.dbus = {
    packages = mkOption {
      type = listOf package;
      default = [ ];
      description = "list of packages to enable dbus configuration files for";
    };
  };

  config = {
    home.files.".local/state/dbus-1/services".source = {
      pkgs.symlinkJoin {
	name = "user-dbus-services";
	paths = config.dbus.packages;
	stripPrefix = "/share/dbus-1/services";
      };
    };
  };
}
