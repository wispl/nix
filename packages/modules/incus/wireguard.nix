{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkIf mkMerge;
  inherit (lib.types) str;
  cfg = config.modules.server.wireguard;
  utils = import ./utils.nix {inherit lib;};
in {
  options.modules.server.wireguard = mkOption {
    type = str;
    description = "Wireguard container to use for the server, either netbird or wg-easy";
    default = "";
  };
  config = mkMerge [
    # A bird surfing the net? Spiderbird?
    (mkIf (cfg == "netbird") {
      resource."incus_instance"."netbird" = {
        name = "netbird";
        image = "docker:netbirdio/netbird ";
        device = utils.mapVolumes { "netbird-data" = "/var/lib/netbird"; };
        config = { "environment.NB_SETUP_KEY" = "placeholder"; };
      };
    })
  
    # This is not easy
    (mkIf (cfg == "wg-easy") {
      config.server.expose = {
        "wireguard" = "wg-easy.incus:80";
      };
      resource."incus_instance"."wg-easy" = {
        name = "wg-easy";
        image = "ghcr.io/wg-easy/wg-easy";
        config = { "environment.PORT" = "80"; };
      };
    })
  ];
}
