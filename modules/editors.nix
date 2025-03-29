{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.editors;
in {
  options.modules.editors = {
    nvim.enable = mkEnableOption "nvim";
  };

  config = mkMerge [
    (mkIf cfg.nvim.enable {
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
    })
  ];
}
