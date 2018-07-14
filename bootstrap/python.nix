let
  fetchNixpkgs = import ../fetchNixpkgs.nix;

nixpkgs = fetchNixpkgs (builtins.fromJSON (builtins.readFile ../nixpkgs-snapshot.json));

  pkgs = import nixpkgs { config = {}; };

  python = pkgs.python35;

in with python.pkgs; pkgs.stdenv.mkDerivation {
        name = "bootstrap-python";
        buildInputs = [
            flake8
            ipython
            python
            pip
            virtualenv
        ];
    }
