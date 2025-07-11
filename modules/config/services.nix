{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.services;
in {
  options.modules.services = {
    mpd.enable = mkEnableOption "mpd";
    ssh-agent.enable = mkEnableOption "ssh-agent";
    psd.enable = mkEnableOption "psd";
  };

  config = mkMerge [
    # For music, of course
    (mkIf cfg.mpd.enable {
      services.mpd = {
        enable = true;
        network.startWhenNeeded = true;
        # TODO: for some reason the default is broken
        musicDirectory = "~/music/";
      };
    })

    (mkIf cfg.ssh-agent.enable {
      programs.ssh = {
        enable = true;
        addKeysToAgent = "ask";
      };
      services.ssh-agent.enable = true;
    })

    # Store the browser profile in tmpfs, for flexing and maybe performace
    (mkIf cfg.psd.enable {
      services.psd = {
        enable = true;
        browsers = ["firefox"];
        backupLimit = 3;
      };
    })
  ];
}
