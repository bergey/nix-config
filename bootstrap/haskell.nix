let
    nixpkgs =
        let snapshot = builtins.fromJSON (builtins.readFile ../nixpkgs-snapshot.json);
        inherit (snapshot) owner repo rev;
        in builtins.fetchTarball {
            inherit (snapshot) sha256;
            url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
            };
    pkgs = import nixpkgs { config = {
    allowBroken = true;
}; };

    mkEnv = env: if pkgs.lib.inNixShell
        then pkgs.mkShell (env // {buildInputs = env.paths;})
        else pkgs.buildEnv env;

in with pkgs; mkEnv {
        name = "bootstrap-haskell";
        paths = [
            cabal2nix
            cabal-install
            # ghc
            haskellPackages.hpack
            haskellPackages.shake
            # haskellPackages.alex
            stack
            (haskell.packages.ghc865.ghcWithPackages
                (ps: [ ps.shake ]))
        ];
    }
