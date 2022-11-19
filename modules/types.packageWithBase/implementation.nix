{config, lib, ...}: let
  l = lib // builtins;
  t = l.types;
in {
  config.types.packageWithBase =
    t.submoduleWith {
      modules = [
        {
          freeformType = t.attrs;
          options = {
            base = l.mkOption {
              type = config.types.genericPackage;
            };
            derivation = l.mkOption {
              type = t.package;
            };
          };
        }
        ../package-to-derivation.nix
      ];
    };
}
