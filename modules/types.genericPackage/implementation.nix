{config, lib, ...}: let
  l = lib // builtins;
  t = l.types;
in {
  config.types.genericPackage =
    t.either
    t.package
    (t.either
      config.types.packageWithBase
      config.types.package
    );
}
