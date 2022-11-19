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
  options = {
    pname = mkStringOption {};
    version = mkStringOption {};
    buildInputs = l.mkOption {
      type = t.attrsOf drvOrPkg;
      default = {};
    };
    buildPhase = mkStringOption {
      default = "";
    };
    derivation = l.mkOption {
      type = t.package;
    };
  };
}
