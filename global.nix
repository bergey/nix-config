let
  fetchNixpkgs = import ./fetchNixpkgs.nix;

  nixpkgs = fetchNixpkgs {
     rev = "b8f7027360855faee9d72956092be2e030a12a5f";
     sha256 = "15v02kjs38vjzq6nmf9p7rw3dfxbf5sbr7hgp835yr0r5j68ndym";
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
