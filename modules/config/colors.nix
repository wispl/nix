{
  lib,
  ...
}: {
  options.colors = lib.mkOption {
    type = lib.types.attrs;
  };
}
