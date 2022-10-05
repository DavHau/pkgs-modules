## The Ideal interface for configuring packages

This repo serves the purpose of exploring a better UI for configuring pkgs in nixpkgs. While it may contain some implementation for testing, this is not primarily about the implementation. I am mainly interested in determining the best UI for the user. I believe once we agree on the UI, we will find a way to implement it efficiently.

Currently, in order to configure package derivations, users have to call functions like `override`, `overrideAttrs`, etc. Let's call this the `override model`.

The override model has the following problems:
- Bad Discoverability (which options are available for a package)
- No type safety (what type is expected by an option)
- Confusion by multiple override functions (override, overrideAttrs, overrideScope, etc..)
- Calling functions is overly complex and more verbose
- Inconsistent configuration styles between NixOS (the module system) and Nixpkgs (function arguments, and an ad hoc config attribute set). (Two different sections on search.nixos.org. When is a package enabled by an option and when by adding a package? Why is there even a difference?)

Nixpkgs also contains another mechanism for configuring derivations, which is the nixos `module system`.

I think, one major misconception within the community is, that both the override model and the module system serve different purposes and therefore need to be kept distinct.

I don't believe that this is true. It doesn't matter if a user builds a single package, a collection of packages, a dev-shell, or a whole linux distro. The output is always one or more derivations. Both the `override model` an the `module system` are ways to configure derivations. At the core they serve the same purpose. The main difference is, that one of them has the above mentioned problems, and the other one does not.

We should not have two different models of configuring derivations in nixpkgs. We should find out which one is better, and then deprecate the other one. (Or find a new model which is better than both).

Because of the above mentioned problems with the `override model`, I believe that something similar to the `nixos module system` is a much better choice, and therefore the following UI examples are designed with the nixos-modules system in mind.

I want to emphasize, that it doesn't need to be using exactly the `nixos module system` as it exists right now. It might be the case that we need a different module system implementation to address performance issues etc.

Again, this document is not about the implementation. It's just about finding the best UI.

Let's explore a few use cases, take a look as how the UI looks like right now, and how it would look like when using a module system:

## 1. Customizing a single package. Change build time parameters, replace source of dependency.

`override model`:
```nix
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
```

`module system`:
```nix
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
```

## 2. Language specific environment (example: python)

`override model`:
```nix
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

```

`module system`:
```nix
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

```

1. Configure a nixos system with custom packages

### More Examples
more examples to come...
