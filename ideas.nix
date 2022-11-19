let
  pkgs = import <nixpkgs> {
    conf = {config, inputs, }: {

      nixpkgs = {
        name = "nixpkgs";

        pkgs.bash = {
          dependenciesFrom = config.pkgs.name;
          name = "bash";
          version = "1.2.3";
          enable = true;
          builPhase = "";
        };

        pkgs.hello = {
          buildInputs.bash = {};
          buildInputs.git = config.nixpkgs.git;
          buildPhase = ''
            ${config.outputs.bash}/bin/bash -c true
            bash -c "echo hello" > $out
          '';
        };
      };

      packages2205 = inputs.nixpkgs-2205.nixosModules.pkgs;
      # packages2205.name = "packages2205";

      userpkgs = {

        # bash = {
        #   base = config.nixpkgs.bash;
        #   patches.fix-cve0 = ./cve0.patch;
        # };

        pkgs.hello2 = {
          buildInputs = {
            bash = {
              name = "bash2";
            };
          };
        };

        pkgs.hello3 = {
          base = config.packages.pkgs.hello2;
          # buildInputs.bash.enable = false;
          buildInputs.bash = packages2205.bash;
        };

        bash2205 = mkForce (config.packages2205.bash // {
          # dependenciesFrom = "packages2205";
        });
      };
    };
  };

in
pkgs.git
