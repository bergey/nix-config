let
  fetchNixpkgs = import ./fetchNixpkgs.nix;

nixpkgs = fetchNixpkgs {
     rev = "a8c71037e041725d40fbf2f3047347b6833b1703";
     sha256 = "1z4cchcw7qgjhy0x6mnz7iqvpswc2nfjpdynxc54zpm66khfrjqw";
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
    bench
    cabal2nix
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
    nodePackages.node2nix
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
