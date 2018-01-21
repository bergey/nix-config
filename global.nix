let
  fetchNixpkgs = import ./fetchNixpkgs.nix;

  nixpkgs = fetchNixpkgs {
     rev = "f59a0f7f1a6d968e0e05bd7d3188f32f17eb226f";
     sha256 = "08qalwaxhmiqa0j6g1fz0av4v1dvnrzids00v68lg8s7052qzir9";
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
    editorconfig-core-c
    gimp
    git
    git-lfs
    gitAndTools.hub
    gnupg
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
    stow
    subversion
    unison
    vagrant
    w3m
    wget
    ] ++ (if stdenv.isDarwin then [] else [
        calibre
        crawl
        darktable
        dmenu
        docker
        feh
        firefox
        freeciv_gtk
        gitAndTools.git-annex
        google-cloud-sdk
        inotifyTools
        libreoffice
        linuxPackages.virtualbox
        vlc
        zathura
    ]);
  }
