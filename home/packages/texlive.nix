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
}
