{
  inputs.nixpkgs.url = "nixpkgs";

  outputs = inputs: let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.replacements = {
        python3 = "python39";
      };
    };
  in {
    packges.${system}.default = pkgs.python3;
  };
}
