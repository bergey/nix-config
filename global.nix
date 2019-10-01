let
  # after https://vaibhavsagar.com/blog/2018/05/27/quick-easy-nixpkgs-pinning/
  # and https://github.com/obsidiansystems/obelisk/blob/91483bab786b41eb451e7443f38341124e61244a/dep/reflex-platform/default.nix
    nixpkgs =
        let snapshot = builtins.fromJSON (builtins.readFile ./nixpkgs-snapshot.json);
        inherit (snapshot) owner repo rev;
        in builtins.fetchTarball {
            inherit (snapshot) sha256;
            url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
            };
    pkgs = import nixpkgs {
        config = {
            allowUnfree = true;
        };
        overlays = [ (self: super: {
            haskellPackages = super.haskellPackages.override {
                overrides = (newH: oldH: rec {
                # I haven't figured out what version of Servant these need
                # keeping as an example of overlay
                # cachix = self.haskell.lib.unmarkBroken oldH.cachix;
                # cachix-api = self.haskell.lib.unmarkBroken oldH.cachix-api;
                });
            };
        })];
    };


    sizes =
        ({ mkDerivation, base, bytestring, cmdargs, deepseq, dlist, lens
        , parallel-io, regex-posix, system-fileio, system-filepath, text
        , unix
        }:
        mkDerivation {
            pname = "sizes";
            version = "2.3.2-git";
            src = pkgs.fetchgit {
                url = "https://github.com/jwiegley/sizes.git";
                sha256 = "0ma8kxw1sh3bg2rqgq7i6pbjg5frjvyyjshma8q98r8sqa579yn2";
                rev = "1658de1c70d505f2e5d9d736975a8bfae77799f1";
            };
            isLibrary = false;
            isExecutable = true;
            executableHaskellDepends = [
                base bytestring cmdargs deepseq dlist lens parallel-io regex-posix
                system-fileio system-filepath text unix
            ];
            description = "Recursively show space (size and i-nodes) used in subdirectories";
            license = pkgs.stdenv.lib.licenses.bsd3;
            hydraPlatforms = pkgs.stdenv.lib.platforms.none;
            broken = false;
            });

in with pkgs;

buildEnv {
  name = "bergey-env";
  paths= [
    alacritty
    arduino
    aspell
    aspellDicts.en
    atool
    bench
#    ctags
    curl
    direnv
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
    (haskellPackages.callPackage sizes {})
    haskellPackages.wai-app-static # warp
    htop
    id3v2
    imagemagick
    inkscape
    isync # mbsync
    jq
    keybase
    ledger3
    lftp
    lrzip
    maim # screenshots
    mr
    msmtp
    nix-prefetch-git
    nmap
    nodePackages.jsonlint
    notmuch
    pass
    perlPackages.ImageExifTool
    psmisc # pstree &c
    pwgen
    ripgrep
    rsync
    # stack
    stow
    textql
    tmux
    unison
    # vagrant
    w3m
    wget
    xlsfonts
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
        dmenu
        docker
        dropbox-cli
        feh
        file
        # freeciv_gtk
        gitAndTools.git-annex
        gnumake
        google-cloud-sdk
        (haskellPackages.callPackage ../../utility/Sieve {})
        inotifyTools
        kubectl
        linuxPackages.virtualbox
        loc
        mutt                    # I only use it to send mail from scripts
        pavucontrol
        slack
        transmission
        xorg.xev
        (xscreensaver.overrideAttrs (oldAttrs: {
            patches = [ ./xscreensaver.xpm.patch ./teal.xpm.patch ];
        }))
        zathura
        zoom-us
    ]);
  }
