{config, lib, ...}: let
  l = lib // builtins;
  t = l.types;
in {
  options.types.genericPackage = l.mkOption {
    type = t.optionType;
  };
}
