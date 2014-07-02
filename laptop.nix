# Edit this configuration file to define what should be installed on
# the system.  Help is available in the configuration.nix(5) man page
# or the NixOS manual available on virtual console 8 (Alt+F8).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.initrd.luks.devices = [
    {
      name = "luksroot";
      device = "/dev/sda4";
      preLVM = true;
    }
  ];

  nixpkgs.config.allowUnfree = true;
  nix.gc.automatic = true;
  nix.gc.dates = "8:00";

  boot.initrd.kernelModules =
    [ # Specify all kernel modules that are necessary for mounting the root
      # filesystem.
      # "xfs" "ata_piix"
      "fbcon"
    ];
    
  boot.loader.grub = {
    # Use the GRUB 2 boot loader.
    enable = true;
    version = 2;

    # Define on which hard drive you want to install Grub.
    device = "usb-Generic-_Multi-Card_20071114173400000-0:0";
    
  networking.hostName = "wonderlust"; # Define your hostname.
  networking.wireless.enable = true;  # Enables Wireless.

  # Add filesystem entries for each partition that you want to see
  # mounted at boot time.  This should include at least the root
  # filesystem.

  fileSystems."/home" =     # where you want to mount the device
     { device = "/dev/wonderlust/home";  # the device
       fsType = "ext4";      # the type of the partition
       options = "data=journal";
     };

  # List swap partitions activated at boot time.
  swapDevices =
    [ { device = "/dev/wonderlust/swap"; }
    ];

  users.extraUsers.bergey = {
    createHome = true;
    home = "/home/bergey";
    description = "Daniel Bergey";
    extraGroups = [ "wheel" "audio" "video" ];
    useDefaultShell = true;
  };

   # Select internationalisation properties.
   i18n = {
     consoleFont = "lat9w-16";
     consoleKeyMap = "dvorak";
     defaultLocale = "en_US.UTF-8";
   };

  time.timeZone = "UTC";

  security.sudo.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.ssh.startAgent = false;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  services.cron.mailto = "bergey@localhost";
  services.cron.systemCronJobs = [ 
    "1 1 * * * bergey export PATH=${pkgs.git}/bin:$PATH /home/bergey/code/utility/auto-git.sh"
    "1 6 * * * bergey ${pkgs.python3}/bin/python3 /home/bergey/code/original/clean/clean.py"
    ];
  services.cron.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="1781", ATTR{idProduct}=="0c9f", GROUP="dialout", MODE="0666"
  '';

  networking.firewall.extraCommands = 
    "iptables -I nixos-fw 2 -p tcp -m tcp --dport 993 -j nixos-fw-accept
    iptables -I nixos-fw 2 -p udp -m udp --dport 60000:61000 -j nixos-fw-accept"; # IMAP & mosh

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # videoDrivers = [ "radeon" ]; #  "ati" "vesa" "intel" "modesetting" ];
    layout = "dvorak,us";
    xkbOptions = "grp:shifts_toggle";
    xrandrHeads = [ "LVDS" ];

    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    windowManager.default = "xmonad";
    desktopManager.default = "none";
    startGnuPGAgent = true;
    
    displayManager.slim.enable = true;
    displayManager.sessionCommands = ''
      xmodmap ~/.Xmodmap
      xscreensaver -no-splash &
      emacs &
    '';
   };


  hardware.pulseaudio.enable = true;

  # fonts.enableFontConfig = true; # default
  fonts.fonts = with pkgs; [
    anonymousPro
    cm_unicode
    dejavu_fonts
    freefont_ttf
    gentium
    inconsolata
    libertine
    mph_2b_damase
    ucsFonts
    unifont
    wqy_microhei
    wqy_zenhei
    eb-garamond
  ];

  services.transmission.enable = true;

  nixpkgs.config.packageOverrides = pkgs: rec {
    git-send-email = pkgs.gitAndTools.gitBase.override {
      sendEmailSupport = true;
  };};

environment.systemPackages = with pkgs; [
    # main apps
    emacs 
    firefox
    notmuch
    gitAndTools.gitAnnex

    # X11 apps
    calibre
    libreoffice 
    #kde4.okular
    xpdf
    vlc
    #kicad
    eagle

    # terminal apps 
    units
    ledger3
    pass

    # VCS
    subversion
    git
    bazaar
    darcs
    mercurial
    gitAndTools.hub
    mr

    # emacs packages
    #emacs24Packages.notmuch
    emacs24Packages.bbdb
    # emacs24Packages.org # latex docs fail to build....
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

    # X11 tools
    dmenu
    xlibs.xev
    xlibs.xkbcomp
    xlibs.xmodmap
    xlibs.xmessage

    # terminal
    screen
    w3m 
    vim
    most
    mosh

    # gnupg
    gnupg
    pinentry

    # misc
    mpg321
    pavucontrol
    psmisc
    aspell
    aspellDicts.en
    file
    atool
    unzip
    lzma
    silver-searcher
    
    # libraries
    zlib

    # coding
    python27
    python3
    python27Packages.ipython
    gcc
    vagrant

    # graphics apps
    inkscape
    # gimp_2_8 # server down?
    

    # file systems
    davfs2
];
}
