let
  fetchNixpkgs = import ../fetchNixpkgs.nix;

nixpkgs = fetchNixpkgs (builtins.fromJSON (builtins.readFile ../nixpkgs-snapshot.json));

  mkEnv = env: if pkgs.lib.inNixShell
        then pkgs.mkShell (env // {buildInputs = env.paths;})
        else pkgs.buildEnv env;

  pkgs = import nixpkgs { config = {}; };

in with pkgs; mkEnv {
        name = "bootstrap-vcs";
        paths = [
            bazaar
            cvs
            darcs
            mercurial
            subversion
        ];
    }
