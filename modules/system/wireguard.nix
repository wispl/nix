# Wireguard, for home lab VPN. Sometimes I feel meshy and might use netbird. Or
# maybe I don't feel meshy and might use the regular old guard itself.
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
  options.modules.wireguard = {
    variant = mkOption {
      type = str;
      description = "Wireguard preset, either wireguard or netbird";
      default = "";
    };
    endpoint = mkOption {
      type = str;
      description = "Endpoint for server peer (regular wireguard)";
      default = "";
    };
    publicKey = mkOption {
      type = str;
      description = "Public key for server peer (regular wireguard)";
      default = "";
    };
  };

  config = mkMerge [
    (mkIf (cfg.variant == "netbird") {
      services.netbird.clients.default = {
        port = 51820;
        name = "netbird";
        interface = "wt0";
        hardened = true;
      };
    })

    (mkIf (cfg.variant == "wireguard") {
      networking.wg-quick.interfaces.wg0 = {
        address = [ "192.168.2.1/24" ];
        dns = [ "10.0.0.51" ];
        privateKeyFile = "/nix/persist/wireguard";
        generatePrivateKeyFile = true;
        peers = [{
          allowedIPs = [ "10.0.0.1/16" ];
          publicKey = cfg.publicKey;
          endpoint = cfg.endpoint;
        }];
      };
    })
  ];
}
