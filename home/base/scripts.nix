# All my scripts, symlinked so I can edit on the fly. Impure? Kind of, at least
# it is scripted impurity.
{config, ...}: {
  home.file = {
    ".local/bin" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.FLAKE}/bin";
      recursive = true;
    };
  };
}
