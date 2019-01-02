let
  fetchNixpkgs = import ./fetchNixpkgs.nix;

nixpkgs = fetchNixpkgs (builtins.fromJSON (builtins.readFile ./nixpkgs-snapshot.json));
        
    pkgs = import nixpkgs { config = {
        allowUnfree = true;
        };
    };

in with pkgs;

buildEnv {
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
    haskellPackages.hlint
    haskellPackages.graphmod
    # haskellPackages.HaRe
    haskell.packages.ghc822.sizes # broken since semigroup-monoid
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
    nodePackages.jsonlint
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
python.pkgs.yamllint
    ] ++ (if stdenv.isDarwin then [
        nix
    ] else [
        acpi
    borgbackup
cadaver
        calibre
        crawl
        darktable
        dmenu
    docker
dropbox-cli
        feh
        file
        freeciv_gtk
        gimp
        gitAndTools.git-annex
        gnumake
        google-cloud-sdk
    (haskellPackages.callPackage ../../utility/Sieve {})
        inotifyTools
        kubectl
        libreoffice
        linuxPackages.virtualbox
        loc
        vlc
        zathura
    ]);
  }
