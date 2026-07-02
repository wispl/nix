{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf mkMerge;
  inherit (lib.types) str;
  cfg = config.modules.server.wireguard;
  utils = import ./utils.nix {inherit lib;};
in {
  options.modules.server.wireguard = {
    variant = mkOption {
      type = str;
      description = "Wireguard preset, either wg-easy or netbird";
      default = "";
    };
    ddns.enable = mkEnableOption "ddns updater";
  };
  config = mkMerge [
    # A bird surfing the net? Spiderbird?
    (mkIf (cfg.variant == "netbird") {
      resource."incus_instance"."netbird" = {
        name = "netbird";
        image = "docker:netbirdio/netbird ";
        device = utils.mapVolumes {"netbird-data" = "/var/lib/netbird";};
        config = {"environment.NB_SETUP_KEY" = "placeholder";};
      };
    })

    # This is not easy
    (mkIf (cfg.variant == "wg-easy") {
      modules.server.expose = {
        "wireguard" = "wg-easy.incus:80";
      };
      # TODO: there is more that has to be done
      resource."incus_instance"."wg-easy" = {
        name = "wg-easy";
        image = "ghcr:wg-easy/wg-easy";
        config = {"environment.PORT" = "80";};
      };
    })

    (mkIf cfg.ddns.enable {
      modules.server.expose = {
        "ddns" = "ddns.incus:8000";
      };
      resource."incus_instance"."ddns" = {
        name = "ddns";
        image = "docker:qmcgaw/ddns-updater";
        file = [
          {
            target_path = "/updater/data/config.json";
            source_path = "/run/secrets/buns";
            uid = 1000;
            gid = 1000;
            create_directories = true;
          }
        ];
      };
    })
  ];
}
