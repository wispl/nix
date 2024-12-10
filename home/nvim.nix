{
  config,
  ...
}: let
in {
  programs.neovim = {
    defaultEditor = true;
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
  # TODO: :(
  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/wisp/dots/.config/nvim/";
    recursive = true;
  };
}
