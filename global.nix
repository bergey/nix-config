let
  fetchNixpkgs = import ./fetchNixpkgs.nix;

nixpkgs = fetchNixpkgs (builtins.fromJSON (builtins.readFile ./nixpkgs-snapshot.json));
        
  pkgs = import nixpkgs { config = {}; };

in with pkgs;
let
    python-dev-tools = python: with python.pkgs; buildEnv {
        name = "python-dev-tools";
        paths = [
            flake8
            ipython
            python
            pip
            virtualenv
        ];
    };

in buildEnv {
  name = "bergey-env";
  paths= [
    aspell
    aspellDicts.en
    atool
    autojump
    bench
    coq_8_6
#    coqPackages_8_6.dpdgraph
#    coqPackages_8_6.coq-ext-lib
#    ctags
    curl
    editorconfig-core-c
    git
    git-lfs
    gitAndTools.hub
    gnupg
    gphoto2
    graphviz
    (haskell.lib.dontCheck haskellPackages.hasktags)
    haskellPackages.pandoc
#    haskellPackages.sizes
    htop
    id3v2
    inkscape
    isync # mbsync
    jq
    ledger3
    lftp
    lrzip
    mr
    msmtp
    nix-prefetch-git
    nmap
    nodePackages.node2nix
    notmuch
    nox
    pass
    perlPackages.ImageExifTool
    pwgen
    ripgrep
    rsync
    # stack
    stow
    unison
    vagrant
    w3m
    wget
    yaml2json
    ] ++ (if stdenv.isDarwin then [
        nix
    ] else [
        borgbackup
        calibre
        crawl
        darktable
        dmenu
        docker
        feh
        file
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
