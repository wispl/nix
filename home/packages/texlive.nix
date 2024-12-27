# Tex and Latex packages, nix is so awesome for letting me declare this instead
# of manually updating the TexLive installation each year.
{pkgs, ...}: {
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
        # formatter
        latexindent
        # fonts
        erewhon
        newtx
        cabin
        ;
    };
  };
}
