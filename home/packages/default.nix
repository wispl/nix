# All packages to be installed on the system. This is kind of broad, but if it
# is a package, it is going to be packed here, which is why it is really packed
# here. Alright, no more usage of the word packed or packages now. Imported files
# are either individual packages with configuration or a collection of zero
# configuration packages. This is kind of like a catch all.
{
  pkgs,
  specialArgs,
  ...
}: {
  imports = with specialArgs.theme; [
    # packages with configuration
    ./lf.nix
    ./sioyek.nix

    # packages with no configuration
    ./apps.nix
    ./shell.nix
    ./system.nix
    ./texlive.nix
  ];
}
