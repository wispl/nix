# Teeny tiny abstraction over hjem to allow managing home
# configurations for the specified user in `default.nix`.  This also
# sets up some common session variables and xdg stuff.
{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkAliasOptionModule mkOption;
  inherit (lib.types) str;
in {
  # TODO: should wrap hjem rather than fully exposing it
  imports = [
    inputs.hjem.nixosModules.hjem
    (mkAliasOptionModule ["home"] ["hjem" "users" config.user.name])
  ];

  options.xdgdir = {
    dir = mkOption {
      type = str;
      default = "/home/${config.user.name}";
      description = "user's home directory";
    };
    bin = mkOption {
      type = str;
      default = "${config.xdgdir.dir}/.local/bin";
      description = "user's binary directory";
    };
    cache = mkOption {
      type = str;
      default = "${config.xdgdir.dir}/.cache";
      description = "user's cache directory";
    };
    config = mkOption {
      type = str;
      default = "${config.xdgdir.dir}/.config";
      description = "user's config directory";
    };
    data = mkOption {
      type = str;
      default = "${config.xdgdir.dir}/.local/share";
      description = "user's data directory";
    };
    state = mkOption {
      type = str;
      default = "${config.xdgdir.dir}/.local/state";
      description = "user's state directory";
    };
  };

  config = {
    hjem.linker = pkgs.smfh;
    hjem.clobberByDefault = true;
    hjem.users.${config.user.name} = {
      enable = true;
      directory = "${config.xdgdir.dir}";
      user = "${config.user.name}";
      xdg = {
        cache.directory = "${config.xdgdir.cache}";
        config.directory = "${config.xdgdir.config}";
        data.directory = "${config.xdgdir.data}";
        state.directory = "${config.xdgdir.state}";
      };
      environment.sessionVariables = {
        # Some applications still read from these, set just in case
        XDG_BIN_HOME = "${config.xdgdir.bin}";
        XDG_CACHE_HOME = "${config.xdgdir.cache}";
        XDG_CONFIG_HOME = "${config.xdgdir.config}";
        XDG_DATA_HOME = "${config.xdgdir.data}";
        XDG_STATE_HOME = "${config.xdgdir.state}";

        # Wallpaper symlink, so switching wallpapers do not take a rebuild
        WALLPAPER = "${config.xdgdir.state}/wallpaper";
        # Path to flake root
        FLAKE = "~/flakes";
        # Add binary home to path
        PATH = "\${PATH}:${config.xdgdir.bin}";
      };
    };
  };
}
