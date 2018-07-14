let
  fetchNixpkgs = import ../fetchNixpkgs.nix;

nixpkgs = fetchNixpkgs (builtins.fromJSON (builtins.readFile ../nixpkgs-snapshot.json));

  pkgs = import nixpkgs { config = {}; };

in with pkgs; pkgs.stdenv.mkDerivation {
        name = "bootstrap-vcs";
        buildInputs = [
            bazaar
            cvs
            darcs
            mercurial
            subversion
        ];
    }
