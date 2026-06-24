{config, lib, ...}:
let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption;
  inherit (lib.types) str attrsOf;
  cfg = config.modules.server;
  utils = import ./utils.nix { inherit lib; };
in {
  options.modules.server = {
    enable = mkEnableOption "incus server";
    expose = mkOption {
      type = attrsOf str;
      default = {};
      description = "Services to expose via caddy, maps subdomain to internal hostname";
    };
    name = mkOption {
      type = str;
      description = "Name of the server";
    };
  };
  config = mkIf (cfg.enable) (mkMerge [
    (utils.createVolumes [ "caddy-data" ] )

    {
      terraform."required_providers".incus.source = "lxd/incus";
      
      resource."incus_instance" = {
        "caddy" = {
          name = "caddy";
          image = "docker:caddy/caddy";
          device = utils.mapVolumes { "caddy-data" = "/data"; };
          file = [{
            target_path = "/etc/caddy/Caddyfile";
            content = # yaml
              ''
                auth.${cfg.name}.internal {
                  reverse_proxy authelia:9091
                }

                ${builtins.concatStringsSep "\n" (lib.mapAttrsToList (name: value: ''
                   ${name}.${cfg.name}.internal {
                      forward_auth authelia:9091 {
                        uri /api/authz/forward-auth
                        copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
                      }
                      reverse_proxy ${value}
                   }
                 '') cfg.expose)}
              '';
          }];
        };

        "unbound" = {
          name = "unbound";
          image = "docker:klutchell/unbound";
          file = [{
            target_path = "/etc/unbound/custom.conf.d/records.conf";
            device = [{
              name = "eth0";
              type = "proxy";
              properties = { "ipv4.address" = "10.0.100.0"; };
            }];
            content = # conf
              ''
                server:
                  local-zone: "${cfg.name}.internal." redirect
                  local-data: "${cfg.name}.internal. A 10.0.100.50"
                  local-data-ptr: "10.0.100.50 ${cfg.name}.internal."
              '';
          }];
        };

        "authelia" = {
          name = "authelia";
          image = "docker:authelia/authelia";
        };
      };
    }
  ]);
}
