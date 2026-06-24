{config, lib, ...}:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.modules.server.admin;
  utils = import ./utils.nix { inherit lib; };
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
          device = utils.mapVolumes { "loki-data" = "/loki"; };
        };

        "prom" = {
          name = "prom";
          image = "docker:prom/prometheus";
          device = utils.mapVolumes { "prom-data" = "/prometheus"; };
        };

        "grafana" = {
          name = "grafana";
          image = "docker:grafana/grafana";
          device = utils.mapVolumes { "grafana-data" = "/var/lib/grafana"; };
          config = {
            "environment.GF_SERVER_ROOT_URL" = "https://stats.${config.modules.server.name}.internal/";
          };
        };
      };
    }
  ]);
}
