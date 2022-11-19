let
  pkgs = import <nixpkgs> {
    config.replacements = {
      python3 = "python39";
    };
  };

in
pkgs.python3
