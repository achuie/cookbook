{
  description = "DIY cookbook app";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            (pkgs.python3.withPackages
              (ps: with ps; [ django python-decouple ]))
          ];
          shellHook = ''
            if [ ! -f "./cookbookapp/.env" ]; then
              echo '  `.env` not found so generating secret key.'
              echo "SECRET_KEY="$(python -c 'from django.core.management import utils; print(utils.get_random_secret_key())') >./cookbookapp/.env
            else
              echo '  Found existing `.env`.'
            fi
          '';
        };

        formatter = pkgs.nixfmt;
      });
}
