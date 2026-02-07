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
    embedded.enable = mkEnableOption "embedded";
    kube.enable = mkEnableOption "kube";
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
      # I pull java version in using flakes, but these variables are needed for XDG
      home.environment.sessionVariables."_JAVA_OPTIONS" = "-Djava.util.prefs.userRoot=${config.xdgdir.config}/java";
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
            multirow
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
            # inkscape tex insert
            standalone
            koma-script
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

    # sadness
    (mkIf cfg.embedded.enable {
      # stm32cubemx spits like a thousand gunk into the home directoy
      # so force into the fake home
      home.packages = with pkgs; [
        # general stuff
        openocd
        # stm32 stuff
        (writeShellScriptBin "stm32cubemx" ''
          export HOME="$XDG_FAKE_HOME"
          export _JAVA_AWT_WM_NONREPARENTING=1
          export _JAVA_OPTIONS="''${_JAVA_OPTIONS} -Duser.home=''${XDG_FAKE_HOME}"
          exec ${pkgs.stm32cubemx}/bin/stm32cubemx "$@"
        '')
        stlink
        # esp32 stuff
        esptool
      ];
    })

    # for k8 of course, since I have to use openshift occasionally, I
    # prefer to pull kube or oc depending on the project with flakes
    (mkIf cfg.kube.enable {
      # xdg
      home.environment.sessionVariables."KUBECONFIG" = "${config.xdgdir.config}/kube";
      home.environment.sessionVariables."KUBECACHEDIR" = "${config.xdgdir.cache}/kube";
    })
  ];
}
