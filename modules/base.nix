{config, lib,  ...}: let
  l = lib // builtins;
  t = l.types;
  packageToDerivation = attrs:
    {system="x86_64-linux"; name="test"; builder="/bin/sh"; args=["-c" "echo $name > $out"];}
in {
  options = {
    name = l.mkOption {
      type = t.str;
    };
    pkgs = l.mkOption {
      type = t.attrsOf (t.submoduleWith {
        modules = [./package.nix];
      });
    };
  };
}
