let
  fetchNixpkgs = import ./fetchNixpkgs.nix;

  nixpkgs = fetchNixpkgs {
     rev = "6db7f92cc2af827e8b8b181bf5ed828a1d0f141d";
     sha256 = "1wpnln6spcvqvrfqw49z83ky5v8gw951f818q5123l0qpywpmfsq";
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
    borgbackup
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
        loc
        vlc
        zathura
    ]);
  }
