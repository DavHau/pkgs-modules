{config, lib, ...}: let
  l = lib // builtins;
  t = l.types;
  drvOrPkg = t.either
    t.package
    (t.submoduleWith {
      modules = [./package.nix];
    });
in {
  freeformType = t.attrs;
  options = {
    base = l.mkOption {
      type = drvOrPkg;
    };
    derivation = l.mkOption {
      type = t.package;
    };
  };
}
