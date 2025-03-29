{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.desktop;
in {
  options.modules.desktop = {
    enable = mkEnableOption "wayland desktop";
    river.enable = mkEnableOption "riverwm";
    sway.enable = mkEnableOption "swaywm";
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
