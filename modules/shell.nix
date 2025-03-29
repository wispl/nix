{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.shell;
in {
  options.modules.shell = {
    enable = mkEnableOption "general shell programs";
    formats.enable = mkEnableOption "formatting programs";
    storage.enable = mkEnableOption "storage programs";
    media.enable = mkEnableOption "media programs";
    system.enable = mkEnableOption "system monitoring programs";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [
        bc
        btop
        fd
        fzf
        ripgrep
        tree

        # :)
        fastfetch
        pfetch
      ];
    }

    (mkIf cfg.formats.enable {
      home.packages = with pkgs; [
        jq
        unzip
      ];
    })

    (mkIf cfg.storage.enable {
      home.packages = with pkgs; [
        ncdu
        nix-tree
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
        amdgpu_top
        libva-utils
        nvme-cli
        pciutils
        smartmontools
        vdpauinfo
        vulkan-tools
      ];
    })
  ]);
}
