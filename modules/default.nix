{config, lib, ...}: let
  l = lib // builtins;
  t = l.types;
in {
  imports = [
    ./pkgs
    ./types.genericPackage
    ./types.package
    ./types.packageWithBase
  ];
}
