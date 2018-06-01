let
  fetchNixpkgs = import ./fetchNixpkgs.nix;

  nixpkgs = fetchNixpkgs {
     rev = "be5e8faafc69195ef47e9cf6b92806cf427656e1";
     sha256 = "0rvz7ac8bl2x9yrxrkzmgl3mwy4sjm0ngk44zfcfg81czgam7d6r";
  };

  pkgs = import nixpkgs { config = {}; };

in with pkgs; buildEnv {
  name = "bergey-env";
  paths= [
    aspell
    aspellDicts.en
    atool
    autojump
    bazaar
    curl
    cvs
    editorconfig-core-c
    git
    git-lfs
    gitAndTools.hub
    gnupg
    gphoto2
    graphviz
    haskellPackages.pandoc
    haskellPackages.sizes
    htop
    id3v2
    inkscape
    isync # mbsync
    jq
    ledger3
    lrzip
    mercurial
    mr
    msmtp
    nix-prefetch-git
    nix-repl
    nmap
    notmuch
    nox
    pass
    perlPackages.ImageExifTool
    ripgrep
    rsync
    stack
    stow
    subversion
    unison
    vagrant
    w3m
    wget
    ] ++ (if stdenv.isDarwin then [
        ghc
        cabal-install
        nix
    ] else [
        borgbackup
        calibre
        crawl
        darcs
        darktable
        dmenu
        docker
        feh
        firefox
        freeciv_gtk
        gimp
        gitAndTools.git-annex
        google-cloud-sdk
        inotifyTools
        libreoffice
        linuxPackages.virtualbox
        loc
        vlc
        zathura
    ]);
  }
