# The most emacs-like vim editor! Symlinked for live-editing and also because I have no clue
# what to do on other platforms...
{config, ...}: {
  programs.neovim = {
    defaultEditor = true;
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.FLAKE}/nvim/";
    recursive = true;
  };
}
