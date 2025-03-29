{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.services;
in {
  options.modules.services = {
    mpd.enable = mkEnableOption "mpd";
    gpg.enable = mkEnableOption "gpg-agent";
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

    # This thing never works for me
    (mkIf cfg.gpg.enable {
      programs.gpg.enable = true;
      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
      };
    })

    # Store the browser profile in tmpfs, for flexing and maybe performace
    (mkIf cfg.psd.enable {
      services.psd = {
        enable = true;
        browsers = ["firefox"];
      };
    })
  ];
}
