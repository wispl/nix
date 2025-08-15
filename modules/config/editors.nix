{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkMerge mkIf;
  inherit (lib.types) str;
  cfg = config.modules.editors;
in {
  options.modules.editors = {
    default = mkOption {
      type = str;
      description = "default editor to use";
    };
    nvim.enable = mkEnableOption "nvim";
    emacs.enable = mkEnableOption "emacs";
  };

  config = mkMerge [
    (lib.mkIf (cfg.default != "") {
      home.environment.sessionVariables.EDITOR = cfg.default;
    })

    (mkIf cfg.nvim.enable {
      # TODO: symlink?
      home.packages = with pkgs; [neovim fzf];
      home.files.".config/nvim".source = ../../config/nvim;
    })

    (mkIf cfg.emacs.enable {
      home.packages = with pkgs; [emacs-pgtk emacsPackages.jinx ripgrep fd];
    })
  ];
}
