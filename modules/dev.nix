{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.dev;
in {
  options.modules.dev = {
    sh.enable = mkEnableOption "sh";
    rust.enable = mkEnableOption "rust";
    cc.enable = mkEnableOption "c and cpp";
    # are texnomancers developers?
    tex.enable = mkEnableOption "texlive";
  };

  config = mkMerge [
    # TODO: better method?
    (mkIf cfg.sh.enable {home.packages = [pkgs.shellcheck-minimal];})
    (mkIf cfg.cc.enable {
      home.packages = with pkgs; [
        clang-tools
        gcc
        gdb
        valgrind
      ];
    })
    (mkIf cfg.rust.enable {
      home.packages = with pkgs; [
        rustfmt
        clippy
        cargo
      ];
    })
    (mkIf cfg.tex.enable {
      programs.texlive = {
        enable = true;
        extraPackages = tpkgs: {
          inherit
            (pkgs.texlive)
            scheme-basic
            amsmath
            enumitem
            geometry
            graphics
            hyperref
            listings
            lm
            parskip
            url
            float
            fancyhdr
            import
            mdframed
            pgf
            pgfplots
            sidenotes
            caption
            changepage
            marginfix
            marginnote
            thmtools
            latexmk
            etoolbox
            zref
            needspace
            siunitx
            xstring
            xkeyval
            fontaxes
            sectsty
            upquote
            # chem
            mhchem
            chemfig
            simplekv
            # formatter
            latexindent
            # fonts
            erewhon
            newtx
            cabin
            inconsolata
            ;
        };
      };
    })
  ];
}
