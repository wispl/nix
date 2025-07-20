{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  dir = "/home/${config.user.name}";
in {
  imports = [
    inputs.hjem.nixosModules.hjem
    (lib.mkAliasOptionModule ["home"] ["hjem" "users" config.user.name])
  ];

  hjem.linker = pkgs.smfh;
  hjem.users.${config.user.name} = {
    enable = true;
    directory = "${dir}";
    user = "${config.user.name}";
    environment.sessionVariables = {
      XDG_BIN_HOME    = "${dir}/.local/bin";
      XDG_CACHE_HOME  = "${dir}/.cache";
      XDG_CONFIG_HOME = "${dir}/.config";
      XDG_DATA_HOME   = "${dir}/.local/share";
      XDG_STATE_HOME  = "${dir}/.local/state";

      # Wallpaper symlink, so switching wallpapers do not take a rebuild
      WALLPAPER = "$XDG_STATE_HOME/wallpaper";
      # Path to flake root
      FLAKE = "${dir}/flakes";
      PATH = "\${PATH}:\${XDG_BIN_HOME}";
    };
  };
}
