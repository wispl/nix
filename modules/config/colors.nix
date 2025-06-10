{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.colors;
in {
  options.colors = mkOption {
    type = types.attrs;
  };
}
