{
  pkgs,
  config,
  inputs,
  ...
}: let
in {
  imports = [ inputs.sops-nix.nixosModules.sops ];

  # Generate ssh keys even if openssh is not running, we need the keys for
  # secrets. If openssh is running then the keys are generated regardless.
  services.openssh.generateHostKeys = true;

  # Sops-nix deployment stuff. Secrets will be declared elsewhere. 
  sops.defaultSopsFile = "${config.xdgdir.flakes}/.secrets/common.yaml";
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;
}
