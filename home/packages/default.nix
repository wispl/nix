# All packages to be installed on the system
#	apps
#	tools
#	cli tools
#	programs
{
  pkgs,
  specialArgs,
  ...
}: let
in {
  imports = with specialArgs.theme; [
    ./lf.nix
    ./foot.nix
    ./fuzzel.nix
    ./sioyek.nix
  ];
}
