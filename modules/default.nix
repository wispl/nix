{
  apps = import ./apps.nix;
  services = import ./services.nix;
  shell = import ./shell.nix;
  dev = import ./dev.nix;
  editors = import ./editors.nix;
}
