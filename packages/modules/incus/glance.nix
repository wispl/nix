{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption splitString toUpper toLower mapAttrsToList;
  inherit (lib.strings) concatLines;
  inherit (lib.attrsets) filterAttrs;
  inherit (lib.types) str attrsOf;
  cfg = config.modules.server.media;
  utils = import ./utils.nix {inherit lib;};
  containerName = str: builtins.head (splitString "." str);
  titlecase = str: (toUpper (builtins.substring 0 1 str)) + (toLower (builtins.substring 1 (-1) str));
  # Automagically generates sites containers we want to monitor, minus the
  # glance container of course, since that will be redundant.
  monitor = mapAttrsToList (name: value: let
    container = containerName value;
    title = titlecase container;
  in {
    title = "${title}";
    url = "https://${name}.${config.modules.server.name}.internal";
    check-url = "http://${value}";
    icon = "/assets/${container}.png";
  }) (filterAttrs (n: v: n != "home") config.modules.server.expose);
  # Bunch of random yaml stuff...
  yamlfile = {
    server.assets-path = "/app/config/assets";
    pages = [
      {
        name = "Home";
        columns = [
          {
            size = "small";
            widgets = [
              {
                type = "calendar";
                first-day-of-week = "monday";
              }
              {
                type = "bookmarks";
                groups = [
                  {
                    links = [
                      {
                        title = "Mail";
                        url = "https://account.proton.me/mail";
                      }
                      {
                        title = "SimpleLogin";
                        url = "https://app.simplelogin.io/dashboard/";
                      }
                      {
                        title = "Netbird";
                        url = "https://app.netbird.io/";
                      }
                    ];
                  }
                  {
                    title = "Fun";
                    color = "10 70 50";
                    links = [
                      {
                        title = "Kittensgame";
                        url = "https://kittensgame.com/web/";
                      }
                      {
                        title = "Lichess";
                        url = "https://lichess.org/";
                      }
                      {
                        title = "Chesstempo";
                        url = "https://www.chesstempo.com/";
                      }
                      {
                        title = "Jstris";
                        url = "https://jstris.jezevec10.com/";
                      }
                    ];
                  }
                ];
              }
            ];
          }

          {
            size = "full";
            widgets = [
              {
                type = "monitor";
                cache = "1m";
                title = "Services";
                sites = monitor;
              }
              {
                type = "group";
                widgets = [
                  {
                    type = "reddit";
                    subreddit = "technology";
                    show-thumbnails = true;
                    collapse-after = 4;
                  }
                  {
                    type = "reddit";
                    subreddit = "selfhosted";
                    collapse-after = 4;
                    show-thumbnails = true;
                  }
                  {
                    type = "hacker-news";
                    collapse-after = 4;
                  }
                ];
              }
            ];
          }

          {
            size = "small";
            widgets = [
              {
                type = "weather";
                location = "New York, United States";
                units = "metric";
                hour-format = "12h";
              }
              {
                type = "releases";
                cache = "1d";
                repositories = [
                  "glanceapp/glance"
                  "go-gitea/gitea"
                  "immich-app/immich"
                  "syncthing/syncthing"
                  "jellyfin/jellyfin"
                ];
              }
            ];
          }
        ];
      }
    ];
  };
in {
  options.modules.server.glance = {
    enable = mkEnableOption "glance homepage/dashboard";
  };
  config = mkIf (cfg.enable) {
    modules.server.expose = {
      "home" = "glance.incus:8080";
    };

    resource."incus_storage_volume"."glance-config" = {
      name = "glance-config";
      pool = "default";
      file = [
        {
          target_path = "glance.yml";
          content = builtins.readFile ((pkgs.formats.yaml {}).generate "glance.yaml" yamlfile);
          create_directories = true;
        }
        {
          target_path = "assets";
          source_path = "./packages/assets/icons";
          create_directories = true;
          recursive = true;
        }
      ];
    };

    resource."incus_instance"."glance" = {
      name = "glance";
      image = "docker:glanceapp/glance";
      device = utils.mapVolumes {"glance-config" = "/app/config";};
    };
  };
}
