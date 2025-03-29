{
  apps = import ./apps.nix;
  services = import ./services.nix;
  shell = import ./shell.nix;
}
