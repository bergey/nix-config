let
  fetchNixpkgs = import ../fetchNixpkgs.nix;

nixpkgs = fetchNixpkgs (builtins.fromJSON (builtins.readFile ../nixpkgs-snapshot.json));

  pkgs = import nixpkgs { config = {}; };

    mkEnv = env: if pkgs.lib.inNixShell
        then pkgs.mkShell {name = env.name; buildInputs = env.paths;}
        else pkgs.buildEnv env;
  
  python = pkgs.python36;

in with python.pkgs; mkEnv {
        name = "bootstrap-python36";
        paths = [
            flake8
            ipython
            python
            pip
            virtualenv
        ];
    }
