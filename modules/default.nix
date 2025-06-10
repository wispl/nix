{
  apps = import ./apps.nix;
  services = import ./services.nix;
  shell = import ./shell.nix;
  editors = import ./editors.nix;
  colors = import ./colors.nix;
  tui = import ./tui.nix;
  desktop = import ./desktop;
  packages = import ./packages;
}
