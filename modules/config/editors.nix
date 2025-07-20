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
  };

  config = mkMerge [
    (lib.mkIf (cfg.default != "") {
      home.environment.sessionVariables.EDITOR = cfg.default;
    })

    (mkIf cfg.nvim.enable {
      # TODO: symlink?
      home.packages = [pkgs.neovim];
      home.files.".config/nvim".source = ../../config/nvim;
    })
  ];
}
