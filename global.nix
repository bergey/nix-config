let
  fetchNixpkgs = import ./fetchNixpkgs.nix;

  nixpkgs = fetchNixpkgs {
     rev = "3eccd0b11d176489d69c778f2fcb544438f3ab56";
     sha256 = "1z5zp60dlr61748nlcjlka94v02misn0z3d6gb44k7c8gbi7kkmi";
  };

  pkgs = import nixpkgs { config = {}; };

in with pkgs; buildEnv {
  name = "bergey-env";
  paths= [
    aspell
    atool
    autojump
    bazaar
    curl
    cvs
    darcs
    gimp
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
    ] ++ (if stdenv.isDarwin then [] else [
        # gnupg
        # pass
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
