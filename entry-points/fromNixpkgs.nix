nixpkgsSrc: args:
let
  b = builtins;

  # we don't have lib here yet
  filterAttrs = pred: set:
    b.listToAttrs (
      b.concatMap (
        name: let
          v = set.${name};
        in
          if pred name v
          then [{inherit name; version = v;}]
          else []
      ) (b.attrNames set)
    );

  # import nixpkgs with some of args
  importNixpkgs = import nixpkgsSrc;
  nixpkgsArgNames = b.attrNames (b.functionArgs importNixpkgs);
  argsForNixpkgs = filterAttrs (arg: val: ! b.elem arg nixpkgsArgNames) args;
  nixpkgs = importNixpkgs argsForNixpkgs;

  # interpret the remaining args as nixos module/config
  usermodule = b.removeAttrs args nixpkgsArgNames;
  lib = nixpkgs.lib;
  result = lib.evalModules {
    modules = [
      ../modules/default.nix
      usermodule
    ];
  };
in
  result.config
