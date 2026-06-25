{lib, ...}: let
  inherit (lib) genAttrs mapAttrsToList;
in {
  createVolumes = volumes: {
    resource."incus_storage_volume" = genAttrs volumes (name: {
      name = "${name}";
      pool = "default";
    });
  };

  mapVolumes = volumes:
    lib.mapAttrsToList (name: value: {
      name = "${name}";
      type = "disk";
      properties = {
        path = "${value}";
        source = "incus_storage_volume.volume.${name}.name";
        pool = "default";
      };
    })
    volumes;
}
