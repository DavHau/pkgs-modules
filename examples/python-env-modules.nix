let
  pkgs = import <nixpkgs> {
    config.packages.python3.packages = {
      pandas.enable = true;
      pandas.version = "0.19.1";
      pandas.src.sha256 = "08blshqj9zj1wyjhhw3kl2vas75vhhicvv72flvf1z3jvapgw295";
    };
  };

in
pkgs.python3
