# Optimistically the polygot module, pessimistically the nogot (nougat) module.
# Hate half the languages here and love more than half... if that makes sense.
{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkMerge mkIf;
  cfg = config.modules.packages.dev;
in {
  options.modules.packages.dev = {
    sh.enable = mkEnableOption "sh";
    rust.enable = mkEnableOption "rust";
    java.enable = mkEnableOption "java";
    cc.enable = mkEnableOption "c and cpp";
    tex.enable = mkEnableOption "texlive";
  };

  config = mkMerge [
    # Stockholm c and cpp
    (mkIf cfg.cc.enable {
      home.packages = with pkgs; [
        clang-tools
        gcc
        gdb
        valgrind
      ];
    })

    # Evil borrow checker rust
    (mkIf cfg.rust.enable {
      home.environment.sessionVariables."CARGO_HOME" = "${config.xdgdir.data}/cargo";
      home.packages = with pkgs; [
        rustfmt
        clippy
        cargo
      ];
    })

    # I HATE JAVA :(
    (mkIf cfg.java.enable {
      home.environment.sessionVariables."_JAVA_OPTIONS" = "-Djava.util.prefs.userRoot=${config.xdgdir.config}/java";
      # I pull java in using flakes
    })

    # Mandatory tex
    # Are texnomancers developers?
    (mkIf cfg.tex.enable {
      home.packages = [
        (pkgs.texlive.combine {
          inherit
            (pkgs.texlive)
            scheme-basic
            # page stuff
            changepage
            geometry
            marginfix
            marginnote
            hyperref
            fancyhdr
            titlesec
            # formatting, graphics, etc
            import
            graphics
            enumitem
            float
            listings
            parskip
            mdframed
            sidenotes
            caption
            wrapfig
            url
            booktabs
            # math
            amsmath
            pgf
            pgfplots
            thmtools
            etoolbox
            siunitx
            # chem
            mhchem
            chemfig
            # I forgor
            lm
            zref
            needspace
            xstring
            xkeyval
            fontaxes
            sectsty
            upquote
            simplekv
            # compiler and formatter
            latexindent
            latexmk
            # fonts
            erewhon
            newtx
            cabin
            inconsolata
            ;
        })
      ];
    })

    # shellfish shell
    (mkIf cfg.sh.enable {
      home.packages = [pkgs.shellcheck-minimal];
    })
  ];
}
