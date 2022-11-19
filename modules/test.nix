let
  pkgs = import <nixpkgs> {};
  l = pkgs.lib // builtins;
  usermodule = {config, ...}:{
    pkgs = {

      hello = {
        base = pkgs.hello;
        pname = "hello-patched";
        version = pkgs.hello.version;
        buildInputs.git = pkgs.git;
      };

      tinc = {
        base = pkgs.tinc;
        # pname = "tinc";
        version = pkgs.tinc.version;
        buildInputs.openssl = {
          base = pkgs.openssl_3;
          pname = "openssl";
          version = pkgs.openssl_3.version;
          # buildPhase = "false";
        };
      };
    };
  };
  result = l.evalModules {
    modules = [
      ./packageset.nix
      usermodule
    ];
  };
in {
  inherit result;
}
