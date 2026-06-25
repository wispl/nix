{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkIf mkMerge elem;
  inherit (lib.types) listOf str;
  cfg = config.modules.hardware;
in {
  options.modules.deploy = mkOption {
    type = listOf str;
    default = [];
    description = "secrets to deploy via a systemd service, can be: incus, authelia";
  };
  config = mkMerge [
    (mkIf elem "incus" cfg.deploy {
      systemd.services.gen-secrets-incus = {
        description = "Generate incus certificates for metrics";
        wantedBy = [ "multi-user.target" ];
        before = [ "network.target" ];
        path = [ pkgs.openssl ];
        script = ''
          TARGET_DIR="/nix/persist/deploy/incus"
          mkdir -p "$TARGET_DIR"
          if [ ! -f "$TARGET_DIR/metrics.key" ]; then
            openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:secp384r1 \
              -sha384 -keyout $TARGET_DIR/metrics.key -nodes -out $TARGET_DIR/metrics.crt \
              -days 3650 -subj "/CN=metrics.local"
          fi

          chown ${config.username}:incus-admin "$TARGET_DIR/metrics.key"
          chown ${config.username}:incus-admin "$TARGET_DIR/metrics.crt"
          
          chmod 640 "$TARGET_DIR/metrics.key"
          chmod 644 "$TARGET_DIR/metrics.crt"
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };
    })

    (mkIf elem "authelia" cfg.deploy {
      systemd.services.gen-secrets-authelia = {
        description = "Generate authelia secrets";
        wantedBy = [ "multi-user.target" ];
        before = [ "network.target" ];
        path = [ pkgs.openssl ];
        script = ''
          TARGET_DIR="/nix/persist/deploy/authelia"
          mkdir -p "$TARGET_DIR"
          for file in $TARGET_DIR/{jwt-secret,storage-encryption-key,session-secret}; do
            if [ ! -f "$file" ]; then
              openssl rand -hex 64 > "$file"
              chown ${config.username}:incus-admin "$file"
              chmod 640 "$file"
            fi
          done
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };
    })
  ];
}
