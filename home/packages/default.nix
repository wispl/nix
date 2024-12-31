# Packages... everything else gets shoved here, importing the directory
# downloads all the packages, while importing the individual one, installs,
# well the individual one.
{
  pkgs,
  specialArgs,
  ...
}: {
  imports = with specialArgs.theme; [
    ./firefox.nix
    ./lf.nix
    ./sioyek.nix
    ./apps.nix
    ./shell.nix
    ./system.nix
    ./texlive.nix
  ];
}
