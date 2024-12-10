{config, ...}: let
in {
  home.file = {
    ".local/bin" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/flakes/bin";
      recursive = true;
    };
  };
}
