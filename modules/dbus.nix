# Plundered module from home manager which allows adding dbus services
# defined by packages to user local services.
{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) listOf package;
in {
  options.dbus = {
    packages = mkOption {
      type = listOf package;
      default = [];
      description = "list of packages to enable dbus configuration files for";
    };
  };

  config = {
    # from home-manager
    # TODO: make the dir into an option
    home.files.".local/share/dbus-1/services".source = pkgs.symlinkJoin {
      name = "user-dbus-services";
      paths = config.dbus.packages;
      stripPrefix = "/share/dbus-1/services";
    };
  };
}
