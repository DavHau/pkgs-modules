{config, lib,  ...}: let
  l = lib // builtins;
  t = l.types;

in {
  options = {
    pkgs = l.mkOption {
      type = t.attrsOf config.types.genericPackage;
    };
  };
}
