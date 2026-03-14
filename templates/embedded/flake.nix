{
  description = "Nix flake template for Embedded Programming";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  # inputs.nixpkgs-esp-dev.url = "github:mirrexagon/nixpkgs-esp-dev";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          system = "${system}";
          config.allowUnfree = true;
          #   overlays = [ (import "${nixpkgs-esp-dev}/overlay.nix") ];
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            gcc-arm-embedded
            cmake
            ninja
            openocd
            # stm32 stuff
            # stm32cubemx spits like a thousand gunk into the home directoy
            # so force into the fake home
            (writeShellScriptBin "stm32cubemx" ''
              export HOME="$XDG_FAKE_HOME"
              export _JAVA_AWT_WM_NONREPARENTING=1
              export _JAVA_OPTIONS="''${_JAVA_OPTIONS} -Duser.home=''${XDG_FAKE_HOME}"
              exec ${pkgs.stm32cubemx}/bin/stm32cubemx "$@"
            '')
            stlink
            stlink-gui

            # Alternatively https://github.com/mirrexagon/nixpkgs-esp-dev
            # esp-idf-full
          ];
          shellHook = ''
            export OPENOCD_PATH=${pkgs.openocd}
          '';
        };
      }
    );
}
