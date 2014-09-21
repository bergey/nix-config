{ config, pkgs, ... }:

{

  nixpkgs.config.packageOverrides = pkgs: rec {
    git-send-email = pkgs.gitAndTools.gitBase.override {
      sendEmailSupport = true;
  };};

  environment.systemPackages = with pkgs; [
    # main apps
    emacs 
    firefox
    chromium
    notmuch
    gitAndTools.gitAnnex

    # X11 apps
    xpdf
    gv
    ghostscript

    # terminal apps 
    units
    ledger3
    pass
    pwgen

    # VCS
    subversion
    git
    bazaar
    darcs
    mercurial
    gitAndTools.hub
    mr

    # emacs packages
    emacs24Packages.notmuch
    emacs24Packages.bbdb
    emacs24Packages.org
    emacs24Packages.emacsw3m

    # network
    netcat
    nmap
    htop
    inetutils
    bind
    inetutils
    wget

    # system / daemons
    transmission
    bitlbee
    offlineimap
    msmtp
    foomatic_filters

    # X11 tools
    dmenu
    xlibs.xev
    xlibs.xkbcomp
    xlibs.xmodmap
    xlibs.xmessage
    xscreensaver
    xclip

    # terminal
    screen
    w3m 
    vim
    most
    mosh

    # gnupg
    gnupg
    pinentry

    # file viewers
    mpg321
    vorbisTools
    gv

    # misc
    pavucontrol
    psmisc
    aspell
    aspellDicts.en
    file
    atool
    unzip
    lzma
    silver-searcher
    stow
    inotifyTools
    
    # coding
    python27
    python27Packages.ipython
    vagrant
    haskellPackages.cabal2nix
    sloccount
    haskellPackages.hasktags

    # file systems
    davfs2

    
  ];
}
