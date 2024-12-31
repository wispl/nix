# Virtual machines for Solidworks and only Solidworks. qemu is pretty cool though
{pkgs, ...}: {
  home.packages = with pkgs; [qemu];
}
