# Hardware config stuff, this stuff is hard...
# Not to be confused with software, which is also hard
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
    description = "hardware configurations to enable: redist bluetooth audio ppd iwd";
  };

  config = mkMerge [
    # Enables evil, possibly proprietary updates 
    (mkIf (elem "redist" cfg) {
      hardware.enableRedistributableFirmware = true;
    })

    # Distant cousin of yellow tooth
    (mkIf (elem "bluetooth" cfg) {
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = false;
    })

    # For when you have to hear the melody
    (mkIf (elem "audio" cfg) {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
    })

    # Power saving solution #10000000000
    (mkIf (elem "ppd" cfg) {
      services.power-profiles-daemon.enable = true;
    })

    # Power saving solution #10000000001
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

    # Networking stack to make the net work for you
    (mkIf (elem "iwd" cfg) {
      # Default DNS resolver for iwd, alternative is pure resolveconf
      services.resolved.enable = true;
      networking = {
        # Enables wireless support via iwd.
        wireless.iwd = {
          enable = true;
          settings = {
            General = {
              # iwd can handle dhcp without an external client
              EnableNetworkConfiguration = true;
              # use network, and generate unstable mac address on a case by
              # case basis (I generally use unstable for public wifi)
              AddressRandomization = "network";
              AddressRandomizationRange = "full";
            };
          };
        };
        dhcpcd.enable = false; # Use iwd's builtin dhcp client
      };
    })
  ];
}
