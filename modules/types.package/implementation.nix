{config, lib, ...}: let
  l = lib // builtins;
  t = l.types;
  mkStringOption = args: l.mkOption (args // {type = t.str;});
in {
  config.types.package =
    t.submoduleWith {
      modules = [
        {
          pname = mkStringOption {};
          version = mkStringOption {};
          buildInputs = l.mkOption {
            type = t.attrsOf config.types.genericPackage;
            default = {};
          };
          buildPhase = mkStringOption {
            default = "";
          };
          derivation = l.mkOption {
            type = t.package;
          };
        }
        ../package-to-derivation.nix
      ];
    };
}
