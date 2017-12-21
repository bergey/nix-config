let
  fetchNixpkgs = import ./fetchNixpkgs.nix;

  nixpkgs = fetchNixpkgs {
     rev = "1bc288591ea4fe3159b7630dcd2b57733d80a2ff";
     sha256 = "1jq5xj4p63ady73flhml6ccnk4a61q5svncfmcgmvjn8afbbnzym";
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
    darcs
    gimp
    git
    git-lfs
    gitAndTools.hub
    gphoto2
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
    sloccount
    stack
    subversion
    unison
    vagrant
    w3m
    wget
    # gnupg
    ] ++ (if stdenv.isDarwin then [] else [
        calibre
        crawl
        darktable
        dmenu
        feh
        gitAndTools.git-annex
        inotifyTools
        libreoffice
        linuxPackages.virtualbox
        vlc
        zathura
    ]);
  }
