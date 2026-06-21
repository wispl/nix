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
      home.packages = with pkgs; [
        tree-sitter
        (symlinkJoin {
          name = "neovim";
          paths = [neovim];
          buildInputs = [makeWrapper];
          postBuild = ''
            wrapProgram $out/bin/nvim --set XDG_CONFIG_HOME "${config.xdgdir.flake}/config"
          '';
        })
      ];
    })

    (mkIf cfg.emacs.enable {
      home.packages = with pkgs; [
        (let
          emacs = (emacsPackagesFor emacs-pgtk).emacsWithPackages (epkgs: [epkgs.jinx]);
        in
          symlinkJoin {
            name = "emacs";
            paths = [emacs];
            buildInputs = [makeWrapper];
            postBuild = ''
              wrapProgram $out/bin/emacs --add-flag "--init-directory=${config.xdgdir.flake}/config/emacs"
            '';
          })
        ripgrep
        fd
        enchant
        vips
        poppler-utils
        ffmpegthumbnailer
        emacs-lsp-booster
        (aspellWithDicts (dicts: with dicts; [en]))
      ];
      # Expose dictionaries for enchant to find
      home.environment.sessionVariables.ASPELL_CONF = ''
        per-conf ${config.xdgdir.config}/aspell/aspell.conf; personal ${config.xdgdir.config}/aspell/en.pws; repl ${config.xdgdir.config}/aspell/en.prepl'';
      home.xdg.config.files."aspell/aspell.conf".text = ''
        dict-dir ${pkgs.aspellWithDicts (dicts: with dicts; [en])}/lib/aspell
      '';
    })
  ];
}
