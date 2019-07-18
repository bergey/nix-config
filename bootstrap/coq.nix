let
    nixpkgs =
        let snapshot = builtins.fromJSON (builtins.readFile ../nixpkgs-snapshot.json);
        inherit (snapshot) owner repo rev;
        in builtins.fetchTarball {
            inherit (snapshot) sha256;
            url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
            };
    pkgs = import nixpkgs { config = {}; };

    mkEnv = env: if pkgs.lib.inNixShell
          then pkgs.mkShell (env // {buildInputs = env.paths;})
          else pkgs.buildEnv env;

in with pkgs; mkEnv {
    name = "bootstrap-coq";
    paths = [
        coq_8_6
#    coqPackages_8_6.dpdgraph
#    coqPackages_8_6.coq-ext-lib
    ];
    }
