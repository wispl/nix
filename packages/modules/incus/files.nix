{config, lib, ...}:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.modules.server.files;
  utils = import ./utils.nix { inherit lib; };
in {
  options.modules.server.files = {
    enable = mkEnableOption "file servers (syncthing and filebrowser)";
  };
  config = mkIf (cfg.enable) (mkMerge [
    (utils.createVolumes [ "music" "media" "downloads" "syncthing-data" "filebrowser-config" "filebrowser-data"] )

    {
      modules.server = {
        expose = {
          "files" = "filebrowser.incus:80";
          "sync" = "syncthing.incus:8384";
        };
      };

      resource."incus_instance" = {
        "filebrowser" = {
          name = "filebrowser";
          image = "docker:filebrowser/filebrowser:s6"; # s6 required for chown
          device = utils.mapVolumes {
            "filebrowser-config" = "/config";
            "filebrowser-database" = "/database";
            "downloads" = "/downloads";
            "music" = "/music";
            "media" = "/media";
          };
          config = {
            "environment.FB_NOAUTH" = "noauth";
          };
        };

        "syncthing" = {
          name  = "syncthing";
          image = "docker:syncthing/syncthing";
          device = utils.mapVolumes { "syncthing-data" = "/var/syncthing"; };
        };
      };
    }
  ]);
}
