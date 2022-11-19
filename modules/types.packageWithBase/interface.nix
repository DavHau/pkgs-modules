{config, lib, ...}: let
  l = lib // builtins;
  t = l.types;
in {
  options.types.packageWithBase = l.mkOption {
    type = t.optionType;
  };
}
