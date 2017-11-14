let
  fetchNixpkgs = import ./fetchNixpkgs.nix;

  nixpkgs = fetchNixpkgs {
     rev = "9ea242c617bf6fca9b425b5199a26294a406cbc0";
     sha256 = "0qmg3an95az451h706s6n3vlygm2b89wbvas7q82shr6ilyv07md";
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
    pass
    ] ++ (if stdenv.isDarwin then [] else [
        gitAndTools.git-annex
        crawl
        feh
        libreoffice
        gnupg
        dmenu
        zathura
    ]);
  }
