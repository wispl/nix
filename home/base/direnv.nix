# Direnv for getting a bunch of text blasted at me when cd-ing.
{
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
}
