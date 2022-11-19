{config, lib,  ...}: let
  l = lib // builtins;
  t = l.types;
  pkgGenericType = t.either
    (t.submoduleWith {
      modules = [./pkgWithBase.nix ./package.nix];
    })
    (t.submoduleWith {
      modules = [./pkgType.nix ./package.nix];
    });

in {
  options = {
    name = l.mkOption {
      type = t.str;
    };
    pkgs = l.mkOption {
      type = t.attrsOf pkgGenericType;
    };
  };
}
