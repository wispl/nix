# A tiny base for all home-manager configurations:
#	bash
#	terminal
#	menu/launcher
#	custom scripts
# Yes, the terminal and menu/launcher are absolutely required...
{
  pkgs,
  specialArgs,
  ...
}: {
  imports = with specialArgs.theme; [
    ./bash.nix
    ./foot.nix
    ./direnv.nix
    ./scripts.nix
    ./fuzzel.nix
  ];
}
