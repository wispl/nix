{
  lib,
  inputs,
  outputs,
  ...
}: {
  modules.server = {
    enable = true;
    name = "tianlu";
    media.enable = true;
    files.enable = true;
    glance.enable = true;
    wireguard = {
      ddns.enable = true;
      variant = "wg-easy";
    };
  };
}
