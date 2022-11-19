{config, lib, ...}: let
  l = lib // builtins;
  t = l.types;
in {
  options.types.package = l.mkOption {
    type = t.optionType;
  };
}
