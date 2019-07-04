let
    fetchNixpkgs = import ../fetchNixpkgs.nix;
    nixpkgs = fetchNixpkgs (builtins.fromJSON (builtins.readFile ../nixpkgs-snapshot.json));
    pkgs = import nixpkgs { config = {}; };

    mkEnv = env: if pkgs.lib.inNixShell
        then pkgs.mkShell (env // {buildInputs = env.paths;})
        else pkgs.buildEnv env;

in with pkgs; mkEnv {
        name = "bootstrap-haskell";
        paths = [
            # cabal2nix
            cabal-install
            # ghc
            haskellPackages.shake
            # haskellPackages.alex
            # stack
            (haskell.packages.ghc865.ghcWithPackages
                (ps: [ ps.shake ]))
        ];
    }
