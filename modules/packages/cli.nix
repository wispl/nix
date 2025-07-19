{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkMerge mkIf mkEnableOption;
  cfg = config.modules.packages.cli;
in {
  options.modules.packages.cli = {
    common.enable = mkEnableOption "common cli packages";
    direnv.enable = mkEnableOption "direnv";
    scripts.enable = mkEnableOption "enable user scripts";
    storage.enable = mkEnableOption "storage programs";
    media.enable = mkEnableOption "media programs";
    system.enable = mkEnableOption "system monitoring programs";
  };

  config = mkMerge [
    (mkIf cfg.common.enable {
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

    (mkIf cfg.direnv.enable {
      home.packages = with pkgs; [direnv nix-direnv];
      home.files.".config/direnv/direnv.toml" = {
        generator = (pkgs.formats.toml {}).generate "direnv.toml";
        value = {
          global = {
            hide_env_diff = true;
          };
        };
      };
    })

    (mkIf cfg.scripts.enable {
      home.files.".local/bin".source = ../../bin;
    })

    (mkIf cfg.storage.enable {
      home.packages = with pkgs; [
        ncdu
        nix-tree
        unzip
      ];
    })

    (mkIf cfg.media.enable {
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

    (mkIf cfg.system.enable {
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
