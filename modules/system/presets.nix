# Some common configurations WE, yes WE, like or need. Most of these are pretty
# self explanatory, for example wayland and podman.
#
#	wayland: wayland!
#	iwd: when using only wlan0, it is a lightweight alternative
#	podman: pods leaving the dock
#	fonts: my default collection of fonts
{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkMerge mkEnableOption;
  cfg = config.modules.presets;
in {
  options.modules.presets = {
    wayland.enable = mkEnableOption "wayland";
    iwd.enable = mkEnableOption "iwd";
    podman.enable = mkEnableOption "podman";
    fonts.enable = mkEnableOption "fonts";
  };

  config = mkMerge [
    # Way man, take me by the hand, lead me to the wayland that you understand
    # Sorry
    (mkIf cfg.wayland.enable {
      hardware.graphics.enable = true;
      # Some stuff for swaylock
      security = {
        polkit.enable = true;
        pam.services.swaylock = {};
        pam.loginLimits = [
          {
            domain = "@users";
            item = "rtprio";
            type = "-";
            value = 1;
          }
        ];
      };
      # I only use screencasting so wlr is good enough
      xdg.portal = {
        enable = true;
        wlr.enable = true;
        # We can set this for now since we only one portal
        config.common.default = "*";
      };
    })

    (mkIf cfg.iwd.enable {
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
              # network address randomization seems to cause problems sometimes.
              AddressRandomization = "once";
              AddressRandomizationRange = "nic";
            };
          };
        };
        dhcpcd.enable = false; # Use iwd's builtin dhcp client
      };
    })

    # Like containers in a container pod
    (mkIf cfg.podman.enable {
      virtualisation.containers.enable = true;
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    })

    (mkIf cfg.fonts.enable {
      fonts.packages = with pkgs; [
        wqy_zenhei # good enough cjk coverage
        dejavu_fonts # good overall coverage
        nerd-fonts.fantasque-sans-mono # programming font of choice
        nerd-fonts.symbols-only # not sure why I have this?
        julia-mono # extensive math coverage
      ];
    })
  ];
}
