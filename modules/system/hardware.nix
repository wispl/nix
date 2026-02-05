# Hardware config stuff, this stuff is hard...
{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkIf mkMerge elem;
  inherit (lib.types) listOf str;
  cfg = config.modules.hardware;
in {
  options.modules.hardware = mkOption {
    type = listOf str;
    description = "hardware configurations to enable: redist bluetooth audio ppd";
  };

  config = mkMerge [
    (mkIf (elem "redist" cfg) {
      hardware.enableRedistributableFirmware = true;
    })

    (mkIf (elem "bluetooth" cfg) {
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = false;
    })

    (mkIf (elem "audio" cfg) {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
    })

    (mkIf (elem "ppd" cfg) {
      services.power-profiles-daemon.enable = true;
    })

    (mkIf (elem "tlp" cfg) {
      services.tlp = {
        enable = true;
        pd.enable = true;
        settings = {
          START_CHARGE_THRESH_BAT0 = 75;
          STOP_CHARGE_THRESH_BAT0 = 80;
          NMI_WATCHDOG = 0;
          # Breaks wifi a lot for me
          WIFI_PWR_ON_BAT = "off";
        };
      };
    })
  ];
}
