
let
  pkgs = import <nixpkgs> {};

  packageOverrides = self: super: {
    pandas = super.pandas.overridePythonAttrs(old: rec {
      version = "0.19.1";
      src =  super.fetchPypi {
        pname = "pandas";
        inherit version;
        sha256 = "08blshqj9zj1wyjhhw3kl2vas75vhhicvv72flvf1z3jvapgw295";
      };
    });
  };

  python = pkgs.python3.override {inherit packageOverrides; self = python;};

  pythonWithPackages = python.withPackages(ps: [ps.blaze]);

in
pythonWithPackages
