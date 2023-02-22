{
  description = "DIY cookbook app";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = pkgs.mkShell {
          buildInputs =
            [ (pkgs.python3.withPackages (ps: with ps; [ django ])) ];
        };

        formatter = pkgs.nixfmt;
      });
}
