# Edit this configuration file to define what should be installed on
# the system.  Help is available in the configuration.nix(5) man page
# or the NixOS manual available on virtual console 8 (Alt+F8).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    <nixos/modules/programs/virtualbox.nix>
    ];

  nixpkgs.config.allowUnfree = true;
  nix.gc.automatic = true;
  nix.gc.dates = "8:00";

  boot.initrd.kernelModules =
    [ # Specify all kernel modules that are necessary for mounting the root
      # filesystem.
      # "xfs" "ata_piix"
    ];
    
  boot.loader.grub = {
    # Use the GRUB 2 boot loader.
    enable = true;
    version = 2;

    # Define on which hard drive you want to install Grub.
    device = "/dev/sda";

    extraEntries = "menuentry 'Debian GNU/Linux' --class debian --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-f5b719be-4d19-4a54-92e2-1c7a454fbedd' {\n    load_video\n	insmod gzio\n	insmod part_msdos\n	insmod lvm\n	insmod ext2\n	set root='lvm/Chladni-root'\n	if [ x$feature_platform_search_hint = xy ]; then\n	  search --no-floppy --fs-uuid --set=root --hint='lvm/Chladni-root'  f5b719be-4d19-4a54-92e2-1c7a454fbedd\n	else\n	  search --no-floppy --fs-uuid --set=root f5b719be-4d19-4a54-92e2-1c7a454fbedd\n	fi\n	echo	'Loading Linux 3.10-3-amd64 ...'\n	linux	/boot/vmlinuz-3.10-3-amd64 root=/dev/mapper/Chladni-root ro  drm.debug=255 debug loglevel=8 quiet initcall_debug printk.time=y\n	echo	'Loading initial ramdisk ...'\n	initrd	/boot/initrd.img-3.10-3-amd64\n}\nmenuentry 'Windows 7 (loader) (on /dev/sdb1)' --class windows --class os $menuentry_id_option 'osprober-chain-CE56E86356E84DB1' {\n	insmod part_msdos\n	insmod ntfs\n	set root='hd1,msdos1'\n	if [ x$feature_platform_search_hint = xy ]; then\n	  search --no-floppy --fs-uuid --set=root --hint-bios=hd1,msdos1 --hint-efi=hd1,msdos1 --hint-baremetal=ahci1,msdos1 --hint='hd1,msdos1'  CE56E86356E84DB1\n	else\n	  search --no-floppy --fs-uuid --set=root CE56E86356E84DB1\n	fi\n	chainloader +1\n}";

#    extraEntriesBeforeNixOS = true;
};

  networking.hostName = "Chladni"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables Wireless.

  # Add filesystem entries for each partition that you want to see
  # mounted at boot time.  This should include at least the root
  # filesystem.

  fileSystems."/".device = "/dev/Chladni/nix";

  fileSystems."/home" =     # where you want to mount the device
     { device = "/dev/Chladni/home";  # the device
       fsType = "ext4";      # the type of the partition
       options = "data=journal";
     };

  # List swap partitions activated at boot time.
  swapDevices =
    [ { device = "/dev/Chladni/swap_1"; }
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
  services.openssh.forwardX11 = true;
  programs.ssh.startAgent = false;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  services.dovecot2 = {
    enable = true;
      enablePop3 = false;
    mailLocation = "maildir:/home/%u/Maildir:LAYOUT=fs";
    sslServerKey = "/root/rsa.key";
    sslServerCert = "/root/pubkey.pem";
    sslCACert = "/root/pubkey.pem";
    extraConfig = "verbose_ssl = yes\n";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  services.cron.mailto = "bergey@localhost";
  services.cron.systemCronJobs = [ 
    "*/15 * * * * bergey export PATH=${pkgs.offlineimap}/bin:${pkgs.stdenv}/bin && offlineimap | /home/bergey/code/utility/add-date.sh >> /home/bergey/tmp/offlineimap-log 2>&1"
    "*/15 * * * * bergey ${pkgs.python3}/bin/python3 /home/bergey/code/utility/sort_mail.py ${pkgs.notmuch}/bin/notmuch >> /home/bergey/tmp/sort-log 2>&1"
    # "*/15 * * * * bergey pkill -2 -u $UID mu && sleep 1 && mu index"
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
      layout = "dvorak,us";
    xkbOptions = "grp:shifts_toggle";
    xrandrHeads = ["DVI-D-1" "DVI-I-1" ];

    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    windowManager.default = "xmonad";
    desktopManager.default = "none";
    startGnuPGAgent = true;
    
    displayManager.sessionCommands = ''
      xmodmap ~/.Xmodmap
      xscreensaver -no-splash &
      emacs &
      ~/code/build/noip-2.1.9-1/noip2
    '';
   };


  # hardware.opengl.videoDrivers = [ "nvidia" ];
  # hardware.opengl.videoDrivers = [ "nouveau" ];
  # services.xserver.videoDrivers = [ "nouveau" ];
  services.xserver.videoDrivers = [ "nvidia" ];
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
    # firefox
    chromiumWrapper
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
    # emacs24Packages.org
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
    xscreensaver

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
