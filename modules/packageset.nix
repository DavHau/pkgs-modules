{config, lib,  ...}: let
  l = lib // builtins;
  t = l.types;
  pkgGenericType = t.either
    (t.submoduleWith {
      modules = [
        ./package/interface-package-with-base.nix
        ./package/implementation.nix
      ];
    })
    (t.submoduleWith {
      modules = [
        ./package/interface-package.nix
        ./package/implementation.nix
      ];
    });

in {
  options = {
    pkgs = l.mkOption {
      type = t.attrsOf pkgGenericType;
    };
  };
}
