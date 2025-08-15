{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkMerge mkIf;
  cfg = config.modules.services;
in {
  options.modules.services = {
    mpd.enable = mkEnableOption "mpd";
    ssh-agent.enable = mkEnableOption "ssh-agent";
    psd.enable = mkEnableOption "psd";
  };

  config = mkMerge [
    # For music, of course
    # TODO: make into service?
    (mkIf cfg.mpd.enable {
      home.packages = [pkgs.mpd];
      home.xdg.config.files."mpd/mpd.conf".text = ''
        db_file            "~/.config/mpd/database"
        playlist_directory "~/.config/mpd/playlists"
      '';
    })

    (mkIf cfg.ssh-agent.enable {
      programs.ssh = {
        agentTimeout = "1h";
        startAgent = true;
      };
      home.files.".ssh/config".text = ''
        AddKeysToAgent yes
      '';
    })

    # Store the browser profile in tmpfs, for flexing and maybe performance
    (mkIf cfg.psd.enable {
      home.packages = [pkgs.profile-sync-daemon];
      services.psd.enable = true;
      home.xdg.config.files."psd/psd.conf".text = ''
        BROWSERS=(firefox)
        USE_BACKUP="yes"
        BACKUP_LIMIT=3
      '';
    })
  ];
}
