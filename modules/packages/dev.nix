# Optimistically the polygot module, pessimistically the nogot (nougat) module.
# Hate half the languages here and love more than half... if that makes sense.
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.packages.dev;
in {
  options.modules.packages.dev = {
    sh.enable = lib.mkEnableOption "sh";
    rust.enable = lib.mkEnableOption "rust";
    cc.enable = lib.mkEnableOption "c and cpp";
    # are texnomancers developers?
    tex.enable = lib.mkEnableOption "texlive";
  };

  config = lib.mkMerge [
    # stockholm c and cpp
    (lib.mkIf cfg.cc.enable {
      home.packages = with pkgs; [
        clang-tools
        gcc
        gdb
        valgrind
      ];
    })

    # evil borrow checker rust
    (lib.mkIf cfg.rust.enable {
      home.packages = with pkgs; [
        rustfmt
        clippy
        cargo
      ];
    })

    # mandatory tex
    (lib.mkIf cfg.tex.enable {
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
            wrapfig
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

    # shellfish shell
    (lib.mkIf cfg.sh.enable {
      home.packages = [
        pkgs.shellcheck-minimal
      ];
    })
  ];
}
