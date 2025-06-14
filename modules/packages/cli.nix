{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.packages.cli;
in {
  options.modules.packages.cli = {
    common.enable = lib.mkEnableOption "common cli packages";
    direnv.enable = lib.mkEnableOption "direnv";
    scripts.enable = lib.mkEnableOption "enable user scripts";
    storage.enable = lib.mkEnableOption "storage programs";
    media.enable = lib.mkEnableOption "media programs";
    system.enable = lib.mkEnableOption "system monitoring programs";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.common.enable {
      home.packages = with pkgs; [
        bc
        btop
        fd
        fzf
        ripgrep
        tree
        jq

        # :)
        fastfetch
        pfetch
      ];
    })

    (lib.mkIf cfg.direnv.enable {
      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
        silent = true;
      };
    })

    (lib.mkIf cfg.scripts.enable {
      home.file = {
        ".local/bin" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.FLAKE}/bin";
          recursive = true;
        };
      };
    })

    (lib.mkIf cfg.storage.enable {
      home.packages = with pkgs; [
        ncdu
        nix-tree
        unzip
      ];
    })

    (lib.mkIf cfg.media.enable {
      home.packages = with pkgs; [
        pandoc
        ghostscript
        imagemagick
        ffmpeg
        yt-dlp
        imv
        mpv
      ];
    })

    (lib.mkIf cfg.system.enable {
      home.packages = with pkgs; [
        radeontop
        powertop
        pciutils
        nvme-cli
        smartmontools
      ];
    })
  ];
}
