let
  pkgs = import <nixpkgs> {
    config.packages = {
      git.pythonSupport = false;
      git.env.GIT_TEST_OPTS = "--verbose --debug";
      openssl.enableSSL3 = true;
    };
  };

in
pkgs.git
