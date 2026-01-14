{
  disko.devices = {
    disk.main = {
      device = "<placeholder>";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            name = "ESP";
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077" "noexec" "nosuid" "nodev"];
            };
          };
          nix = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/nix";
              mountOptions = ["defaults"];
            };
          };
        };
      };
    };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=2G"
        "defaults"
        "mode=755"
        "noexec"
      ];
    };
  };

  fileSystems."/nix".neededForBoot = true;
}
