let
  sets = (import ../.).mkSets {
    sets.nixpkgs.fromNixpkgs = import <nixpkgs> {};
    sets.mypackages.packages = {
      git.pythonSupport = false;
      git.env.GIT_TEST_OPTS = "--verbose --debug";
      openssl.enableSSL3 = true;
    };
  };

in
sets.mypackages.git
