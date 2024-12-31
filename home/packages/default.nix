# Packages... everything else gets shoved here, importing the directory
# downloads all the packages, while importing the individual one, installs,
# well the individual one.
{
  pkgs,
  specialArgs,
  ...
}: {
  imports = with specialArgs.theme; [
    ./apps.nix
    ./firefox.nix
    ./gpg.nix
    ./lf.nix
    ./shell.nix
    ./sioyek.nix
    ./system.nix
    ./texlive.nix
  ];
}
