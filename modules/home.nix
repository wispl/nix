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
  imports = [
    inputs.hjem.nixosModules.hjem
    (mkAliasOptionModule ["home"] ["hjem" "users" config.user.name])
  ];

  options.xdgdir = {
    bin = mkOption {
      type = str;
      default = "$HOME/.local/bin";
      description = "user's binary directory";
    };
    cache = mkOption {
      type = str;
      default = "$HOME/.cache";
      description = "user's cache directory";
    };
    config = mkOption {
      type = str;
      default = "$HOME/.config";
      description = "user's config directory";
    };
    data = mkOption {
      type = str;
      default = "$HOME/.local/share";
      description = "user's data directory";
    };
    state = mkOption {
      type = str;
      default = "$HOME/.local/state";
      description = "user's state directory";
    };
  };

  config = {
    hjem.linker = pkgs.smfh;
    hjem.clobberByDefault = true;
    hjem.users.${config.user.name} = {
      enable = true;
      directory = "/home/${config.user.name}";
      user = "${config.user.name}";
      environment.sessionVariables = {
	XDG_BIN_HOME    = "${config.xdgdir.bin}";
	XDG_CACHE_HOME  = "${config.xdgdir.cache}";
	XDG_CONFIG_HOME = "${config.xdgdir.config}";
	XDG_DATA_HOME   = "${config.xdgdir.data}";
	XDG_STATE_HOME  = "${config.xdgdir.state}";

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
