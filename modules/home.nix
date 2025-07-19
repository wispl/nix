{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.hjem.nixosModules.hjem
    (lib.mkAliasOptionModule ["home"] ["hjem" "users" config.user.name])
  ];

  hjem.linker = pkgs.smfh;
  hjem.users.${config.user.name} = {
    enable = true;
    directory = "/home/${config.user.name}";
    user = "${config.user.name}";
  };
}
