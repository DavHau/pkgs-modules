{config, lib, ...}: let
  l = lib // builtins;
  t = l.types;
  pkgs = import <nixpkgs> {};
  mkStringOption = args: l.mkOption (args // {type = t.str;});
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
