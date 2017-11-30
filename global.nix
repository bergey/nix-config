let
  fetchNixpkgs = import ./fetchNixpkgs.nix;

  nixpkgs = fetchNixpkgs {
     rev = "4cbbecc85dbc5a040f2e4111093d30337718996a";
     sha256 = "0a6kz23f7zba31n46bqrrjcnb79pzyig4rlszz83ns76azx6zjc3";
  };

  pkgs = import nixpkgs { config = {}; };

in with pkgs; buildEnv {
  name = "bergey-env";
  paths= [
    gitAndTools.hub
    ripgrep
    notmuch
    stack
    vagrant
    jq
    mr
    nix-repl
    nix-prefetch-git
    nox
    rsync
    sloccount
    w3m
    unison
    atool
    aspell
    bazaar
    mercurial
    darcs
    subversion
    git-lfs
    cvs
    curl
    msmtp
    nmap
    haskellPackages.sizes
    ] ++ (if stdenv.isDarwin then [] else [
        gitAndTools.git-annex
        crawl
        feh
        libreoffice
        # pass
        # gnupg
        dmenu
        zathura
    ]);
  }
