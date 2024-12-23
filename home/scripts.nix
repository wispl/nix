{config, ...}: {
  home.file = {
    ".local/bin" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.FLAKE}/bin";
      recursive = true;
    };
  };
}
