let
  nixpkgs = import <nixpkgs> {};
  l = nixpkgs.lib // builtins;
  usermodule = {config, ...}:{
    pkgs = {

      foo = {
        base = nixpkgs.hello;
        pname = "foo";
        buildInputs.git = nixpkgs.git;
      };

      bar = {
        base = nixpkgs.hello;
        pname = "bar";
        buildInputs.foo = config.pkgs.foo;
      };

      bar-with-different-git = {
        base = config.pkgs.bar;
      };

      git-patched = {
        base = nixpkgs.git;
        pname = "git-patched";
      };

      tinc = {
        base = nixpkgs.tinc;
        version = nixpkgs.tinc.version;
        buildInputs.openssl = {
          base = nixpkgs.openssl_3;
          pname = "openssl";
        };
      };
    };
  };
  result = l.evalModules {
    modules = [
      ./default.nix
      usermodule
    ];
  };
in {
  inherit result;
}
