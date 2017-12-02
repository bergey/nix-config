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
    aspell
    atool
    autojump
    bazaar
    calibre
    curl
    cvs
    darcs
    darktable
    gimp
    git-lfs
    gitAndTools.hub
    gphoto2
    haskellPackages.pandoc
    haskellPackages.pandocCiteproc
    haskellPackages.sizes
    htop
    id3v2
    inkscape
    inotifyTools
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
    vlc
    w3m
    wget
    ] ++ (if stdenv.isDarwin then [] else [
        # gnupg
        # pass
        crawl
        dmenu
        feh
        gitAndTools.git-annex
        libreoffice
        linuxPackages.virtualbox
        zathura
    ]);
  }
