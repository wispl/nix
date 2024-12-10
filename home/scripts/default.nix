{
  self,
  lib,
  config,
  ...
}: let
	in {
	home.file = {
		".local/bin" = {
			source = config.lib.file.mkOutOfStoreSymlink ./bin;
			recursive = true;
		};
	};
}
