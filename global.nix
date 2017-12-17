let
  fetchNixpkgs = import ./fetchNixpkgs.nix;

  nixpkgs = fetchNixpkgs {
     rev = "afe9649210cace6d3ee9046684d4ea27dc4fd15d";
     sha256 = "1x8a3gx8c95fcjzr3d1x187xncmn8rzcqbh5gh331liw8zs53zmr";
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
