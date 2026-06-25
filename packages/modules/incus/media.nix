{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.modules.server.media;
  utils = import ./utils.nix {inherit lib;};
in {
  options.modules.server.media = {
    enable = mkEnableOption "media (jellyfin, metube, feishin)";
  };
  config = mkIf (cfg.enable) (mkMerge [
    (utils.createVolumes ["music" "media" "downloads" "jellyfin-cache" "jellyfin-config"])

    {
      modules.server.expose = {
        "jellyfin" = "jellyfin.incus:8096";
        "metube" = "metube.incus:8081";
        "feishin" = "feishin.incus:9180";
      };

      resource."incus_instance" = {
        "jellyfin" = {
          name = "jellyfin";
          image = "docker:jellyfin/jellyfin";
          device = utils.mapVolumes {
            "jellyfin-cache" = "/cache";
            "jellyfin-config" = "/config";
            "music" = "/src/music";
            "media" = "/src/media";
          };
        };

        "metube" = {
          name = "metube";
          image = "ghcr:alexta69/metube";
          device = utils.mapVolumes {"downloads" = "/downloads";};
        };

        "feishin" = {
          name = "feishin";
          image = "ghcr:jeffvli/feishin";
          config = {
            "environment.SERVER_NAME" = "jellyfin";
            "environment.SERVER_LOCK" = "true";
            "environment.SERVER_TYPE" = "jellyfin";
            "environment.SERVER_URL" = "https://jellyfin.${config.modules.server.name}.internal";
            "environment.LEGACY_AUTHENTICATION" = "false";
            "environment.ANALYTICS_DISABLED" = "true";
          };
        };
      };
    }
  ]);
}
