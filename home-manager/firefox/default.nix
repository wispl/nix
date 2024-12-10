{...}: let
in {
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        userChrome = builtins.readFile ./userChrome.css;
      };
      spare = {
        id = 1;
        name = "spare";
      };
    };
  };
}
