let

  pkgs = import <nixpkgs> {overlays = [overlay];};

  overlay = self: super: {
    git = (super.git.overrideAttrs (old: {
      GIT_TEST_OPTS = "--verbose --debug";
    })).override {
      pythonSupport = false;
    };
    openssl = super.openssl.override rec {
      enableSSL3 = true;
    };
  };

in
pkgs.git
