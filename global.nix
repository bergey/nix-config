let
  fetchNixpkgs = import ./fetchNixpkgs.nix;

  nixpkgs = fetchNixpkgs {
     rev = "cc1d7a358f57cade8e143f306fe4b480cc6646bb";
     sha256 = "0inx1b9fgy01xk1xqm9kjzc8vhh2s4ccj7mc696yaghcqp5blas6";
  };

  pkgs = import nixpkgs { config = {}; };

in with pkgs; buildEnv {
  name = "bergey-env";
  paths= [
    ledger3
    gitAndTools.hub
    ripgrep
    notmuch
    stack
    vagrant
    jq
    mr
    htop
    wget
    nix-repl
    nix-prefetch-git
    nox
    rsync
    sloccount
    w3m
    isync # mbsync
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
    lrzip
    inotifyTools
    autojump
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
