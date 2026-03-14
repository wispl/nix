# Wireguard, for VPNs. Sometimes I feel meshy and might use netbird. Or maybe I
# don't feel meshy and might use the regular old guard itself.
{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkMerge mkOption;
  inherit (lib.types) str;
  cfg = config.modules.wireguard;
in {
  options.modules.wireguard = mkOption {
    type = str;
    description = "Wireguard preset, either wireguard or netbird";
    default = "";
  };

  config = mkMerge [
    (mkIf (cfg == "netbird") {
      services.netbird.clients.default = {
        port = 51820;
        name = "netbird";
        interface = "wt0";
        hardened = true;
      };
    })

    (mkIf (cfg == "wireguard") {
      # TODO
    })
  ];
}
