{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption;
  inherit (lib.strings) concatLines;
  inherit (lib.types) str attrsOf;
  cfg = config.modules.server;
  utils = import ./utils.nix {inherit lib;};
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
    (utils.createVolumes ["caddy-data"])

    {
      terraform."required_providers".incus.source = "lxd/incus";

      resource."incus_instance" = {
        "caddy" = {
          name = "caddy";
          image = "docker:caddy/caddy";
          device =
            [
              {
                name = "eth0";
                type = "proxy";
                properties = {"ipv4.address" = "10.0.100.0";};
              }
            ]
            ++ utils.mapVolumes {"caddy-data" = "/data";};
          file = [
            {
              target_path = "/etc/caddy/Caddyfile";
              content =
                # yaml
                ''
                  auth.${cfg.name}.internal {
                    reverse_proxy authelia:9091
                  }

                  ${concatLines (lib.mapAttrsToList (name: value: ''
                      ${name}.${cfg.name}.internal {
                         forward_auth authelia:9091 {
                           uri /api/authz/forward-auth
                           copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
                         }
                         reverse_proxy ${value}
                      }
                    '')
                    cfg.expose)}
                '';
            }
          ];
        };

        # DNS, Points back to the proxy ip address
        "unbound" = {
          name = "unbound";
          image = "docker:klutchell/unbound";
          device = [
            {
              name = "eth0";
              type = "proxy";
              properties = {"ipv4.address" = "10.0.100.1";};
            }
          ];
          file = [
            {
              target_path = "/etc/unbound/custom.conf.d/records.conf";
              content =
                # conf
                ''
                  server:
                    local-zone: "${cfg.name}.internal." redirect
                    local-data: "${cfg.name}.internal. A 10.0.100.0"
                    local-data-ptr: "10.0.100.0 ${cfg.name}.internal."
                '';
            }
          ];
        };

        # I don't really use the OIDC that much, unless it is absolutely needed.
        # Since everything is LAN only, authelia just provides an extra layer of
        # defense but I don't need a crazy amount of defense where I sign in
        # once for the proxy and then another time for an app. So authelia is
        # just away for me to disable auth for most apps. Overall makes things
        # more secure since it is much easier to rotate passwords now.
        "authelia" = {
          name = "authelia";
          image = "docker:authelia/authelia";
          file = [
            {
              source_path = "/nix/persist/deploy/authelia/jwt-secret";
              target_path ="/run/secrets/JWT_SECRET";
            }
            {
              source_path = "/nix/persist/deploy/authelia/storage-encryption-key";
              target_path ="/run/secrets/STORAGE_ENCRYPTION_KEY";
            }
            {
              source_path = "/nix/persist/deploy/authelia/session-secret";
              target_path ="/run/secrets/SESSION_SECRET";
            }
            {
              target_path = "/config/configuration.yml";
              content =
                # yaml
                ''
                  theme: "dark"
                  # Required for oidc clients to work
                  server:
                    endpoints:
                      authz:
                        forward-auth:
                          implementation: "ForwardAuth"
                  totp:
                    issuer: "${config.modules.server.name}"
                  # Required for storage
                  storage:
                    local:
                      path: "/config/db.sqlite3"
                  # Required, stores list of users
                  authentication_backend:
                    file:
                      path: /config/users.yml
                  # Required, allows session to work
                  session:
                    cookies:
                      - domain: "${config.modules.server.name}.internal"
                        authelia_url: "https://auth.${config.modules.server.name}.internal"
                        default_redirection_url: "https://www.${config.modules.server.name}.internal"
                  # Required, but I don't care about it so just use file
                  notifier:
                    filesystem:
                      filename: "/config/notification.txt"
                  # Required, policies for different domains
                  access_control:
                    default_policy: deny
                    rules:
                      - domain: "*.${config.modules.server.name}.internal"
                        policy: one_factor
                '';
            }
            {
              target_path = "/config/configuration.yml";
              content =
                # yaml
                ''
                  users:
                    wisp:
                      disabled: false
                      displayname: "wisp"
                      email: wisp@${config.modules.server.name}.internal
                      groups:
                        - "admins"
                        - "dev"
                      password: "{{ secret /run/secrets/USER_PASSWORD }}"
                '';
            }
          ];
          config = {
            "environment.X_AUTHELIA_CONFIG_FILTERS" = "template";
            # Required secrets
            "environment.AUTHELIA_IDENTITY_VALIDATION_RESET_PASSWORD_JWT_SECRET_FILE" = "/run/secrets/JWT_SECRET";
            "environment.AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE" = "/run/secrets/STORAGE_ENCRYPTION_KEY";
            "environment.AUTHELIA_SESSION_SECRET_FILE" = "/run/secrets/SESSION_SECRET";
          };
        };
      };
    }
  ]);
}
