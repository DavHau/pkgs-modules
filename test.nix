let
  nixpkgs = import <nixpkgs> {};
  l = nixpkgs.lib // builtins;
  usermodule = {config, ...}:{
    pkgs = {

      # foo which depends on git
      foo = {
        base = nixpkgs.hello;
        pname = "foo";
        buildInputs.git = nixpkgs.git;
      };

      # bar which depends on foo
      bar = {
        base = nixpkgs.hello;
        pname = "bar";
        buildInputs.foo = config.pkgs.foo;
      };

      # TODO: like bar but recursively replace git
      bar-with-different-git = {
        base = config.pkgs.bar;
      };

      # git customized
      git-patched = {
        base = nixpkgs.git;
        pname = "git-patched";
      };

      tinc = {
        base = nixpkgs.tinc;
        buildInputs.openssl = {
          base = nixpkgs.openssl_3;
          pname = "openssl";
        };
      };
    };
  };
  result = l.evalModules {
    modules = [
      ./modules/default.nix
      usermodule
    ];
  };
in {
  inherit result;
  inherit (result.config) pkgs;
}
