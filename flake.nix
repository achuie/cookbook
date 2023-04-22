{
  description = "DIY cookbook app";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              (pkgs.python3.withPackages
                (ps: with ps; [ django python-decouple ]))
            ];
            shellHook = ''
              if [ ! -f "./cookbookapp/.env" ]; then
                echo "  '.env' not found so generating secret key."
                echo "SECRET_KEY="$(python -c 'from django.core.management import utils; print(utils.get_random_secret_key())') >./cookbookapp/.env
              else
                echo "  Found existing '.env'."
              fi
              cd cookbookapp
              echo "  Now in app dir: '$(pwd)'"
            '';
          };
        });

      formatter = forAllSystems (system: nixpkgsFor.${system}.nixpkgs-fmt);
    };
}
