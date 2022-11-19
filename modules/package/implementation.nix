{config, lib, ...}: let
  l = lib // builtins;
  t = l.types;
  pkgs = import <nixpkgs> {};
  /*getOverrideFunctionArgs = function: let
    funcArgs = l.functionArgs function;
  in
    if funcArgs != {}
    then b.attrNames funcArgs
    else
      (
        function (old: {passthru.funcArgs = l.attrNames old;})
      )
      .funcArgs;*/
  overrideLegacyPackage = drv: pkg: drv.overrideAttrs (attrs:
    (l.removeAttrs pkg ["_module" "base" "derivation"]) //
    (l.optionalAttrs (pkg ? buildInputs) { buildInputs = let
        filteredInputs = l.filter (input: ! pkg.buildInputs ? ${input.pname}) attrs.buildInputs or [];
        newInputs = map toDerivation (l.attrValues pkg.buildInputs);
      in (filteredInputs) ++ newInputs; }));

  toDerivation = pkg:
    if l.isDerivation pkg
    then pkg
    else
      if pkg.base != null && l.isDerivation pkg.base
      then
        # generate calls to override[Attrs]
        overrideLegacyPackage pkg.base pkg
      else let
        args =
          if pkg.base != null
          then l.mkMerge [pkg.base pkg]
          else pkg;
      in
        pkgs.stdenv.mkDerivation {
          inherit (args) pname version;
          buildInputs = map toDerivation (l.attrValues args.buildInputs);
          dontUnpack = true;
          dontInstall = true;
          buildPhase = ''
            mkdir $out
            echo "name: ${args.name}" > $out/log
            for inp in $buildInputs; do
              echo $inp >> $out/log
            done
          '';
        };

in {

  config = {
    derivation = toDerivation config;
  };
}
