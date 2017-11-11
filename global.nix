let
  fetchNixpkgs = import ./fetchNixpkgs.nix;

  nixpkgs = fetchNixpkgs {
     rev = "76d649b59484607901f0c1b8f737d8376a904019";
     sha256 = "01c2f4mj4ahir0sxk9kxbymg2pki1pc9a3y6r9x6ridry75fzb8h";
  };

  pkgs = import nixpkgs { config = {}; };

in with pkgs; buildEnv {
  name = "bergey-env";
  paths= [
    gitAndTools.git-annex
    gitAndTools.hub
    ripgrep
    notmuch
    stack
    unison
    vagrant
    crawl
    ];
  }
