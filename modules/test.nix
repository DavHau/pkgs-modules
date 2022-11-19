let
  pkgs = import <nixpkgs> {};
  l = pkgs.lib // builtins;
  usermodule = {config, ...}:{
    name = "nixpkgs";
    pkgs = {

      hello = {
        base = pkgs.hello;
        pname = "hello-patched";
        version = pkgs.hello.version;
        buildInputs.git = pkgs.git;
      };

      tinc = {
        base = pkgs.tinc;
        pname = "tinc";
        version = pkgs.tinc.version;
        buildInputs.openssl = {
          base = pkgs.openssl_3;
          pname = "openssl";
          version = pkgs.openssl_3.version;
          buildPhase = "false";
        };
      };

      /*bash = {
        pname = "bash";
        version = "2.3.4";
      };
      myhello = {
        pname = "myhello";
        version = "1.2.3";
        #buildInputs.bash = config.pkgs.bash;
        #buildInputs.cowsay = pkgs.cowsay;
        buildInputs = { inherit (config.pkgs) bash hello; };
      };*/
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
