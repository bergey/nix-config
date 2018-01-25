# Basic environments to start hacking on a project in a given language.
# - before setting up a proper sandbox
# - tools needed to bootstrap the sandbox
# - a starting point for the sandbox definition

let
  fetchNixpkgs = import ./fetchNixpkgs.nix;

  nixpkgs = fetchNixpkgs {
     rev = "5402412b97247bcc0d2b693e159d55d114d1327b";
     sha256 = "14qircl1dy2h0plqci5zr63h9di7vznlxnkwkyxpzzbn8xjz9aj9";
  };

  pkgs = import nixpkgs { config = {}; };

in  pkgs; stdenv.mkDerivation {
  name = "haskell-env";
  buildInputs= [
  cabal2nix
    ];
  }
