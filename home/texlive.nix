{pkgs, ...}:
with pkgs; let
in {
  programs.texlive = {
    enable = true;
    extraPackages = tpkgs: {
      inherit
        (pkgs.texlive)
        scheme-basic
        amsmath
        geometry
        graphics
        hyperref
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
        mhchem
        xstring
        xkeyval
        fontaxes
        sectsty
        # fonts
        erewhon
        newtx
        cabin
        ;
    };
  };
}
