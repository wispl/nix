{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.modules.server.admin;
  utils = import ./utils.nix {inherit lib;};
in {
  options.modules.server.admin = {
    enable = mkEnableOption "admin dashboards (grafana)";
  };
  config = mkIf (cfg.enable) (mkMerge [
    {
      resource."incus_instance" = {
        "loki" = {
          name = "loki";
          image = "docker:grafana/loki";
          device = utils.mapVolumes {"loki-data" = "/loki";};
        };

        "prom" = {
          name = "prom";
          image = "docker:prom/prometheus";
          device = utils.mapVolumes {"prom-data" = "/prometheus";};
          file = [
            {
              target_path = "/etc/prometheus/prometheus.yml";
              content =
                # yaml
                ''
                  global:
                    scrape_interval: 15s
                  scrape_configs:
                    - job_name: incus
                      metrics_path: '/1.0/metrics'
                      scheme: 'https'
                      static_configs:
                        - targets: ['10.0.0.121:8444']
                      tls_config:
                        ca_file: 'tls/server.crt'
                        cert_file: 'tls/metrics.crt'
                        key_file: 'tls/metrics.key'
                        server_name: 'nixos'
                    - job_name: 'prometheus'
                      static_configs:
                        - targets: ['localhost:9090']
                '';
            }
          ];
        };

        "grafana" = {
          name = "grafana";
          image = "docker:grafana/grafana";
          device = utils.mapVolumes {"grafana-data" = "/var/lib/grafana";};
          config = {
            "environment.GF_SERVER_ROOT_URL" = "https://stats.${config.modules.server.name}.internal/";
            "environment.GF_AUTH_ANONYMOUS_ENABLED" = "true";
            "environment.GF_AUTH_ANONYMOUS_ORG_ROLE" = "Admin";
            "environment.GF_AUTH_DISABLE_LOGIN_FORM" = "true";
            "environment.GF_AUTH_ANONYMOUS_HIDE_VERSION" = "true";
          };
        };
      };
    }
  ]);
}
