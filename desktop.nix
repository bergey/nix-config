# Edit this configuration file to define what should be installed on
# the system.  Help is available in the configuration.nix(5) man page
# or the NixOS manual available on virtual console 8 (Alt+F8).

{ config, pkgs, ... }:

{
  nix.buildCores = 0;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./systemPackages.nix
      ./common.nix
    ];

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

    extraEntries = "menuentry 'Windows 7 (loader) (on /dev/sdb1)' --class windows --class os $menuentry_id_option 'osprober-chain-CE56E86356E84DB1' {\n	insmod part_msdos\n	insmod ntfs\n	set root='hd1,msdos1'\n	if [ x$feature_platform_search_hint = xy ]; then\n	  search --no-floppy --fs-uuid --set=root --hint-bios=hd1,msdos1 --hint-efi=hd1,msdos1 --hint-baremetal=ahci1,msdos1 --hint='hd1,msdos1'  CE56E86356E84DB1\n	else\n	  search --no-floppy --fs-uuid --set=root CE56E86356E84DB1\n	fi\n	chainloader +1\n}";
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

  nix.sshServe = {
    enable = true;
    keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtnRP0IMsMMV3UKg1Rt7JCGoGYMD/3SbnF8+DRgNiVgvW81NGGZU06xbi9JAhh7F/Ph70WOdEpZ6SRpsQOSeAN2x+BKMSC4ijhzGTt4LfKtWeDm1T6UbVP1h3vGHX2gMmnRvXxBERhC69uFGvvZ9IiNIGGK9XAZjfVVQUiVrfazGEt9xSxaldztrP3I0RUsdpgnI4kSk8SWZQaBbpj4B0TDxbRJ0t+5pCoMRgRRghLr6/BDwX/OJl9jWqdq+8UYyBqxTSQGrLEBe9q7oDiDQ6GaMI8pNTPmpXDoPm8vqFpbf45S3OY6zvsArF8TTOee3M9QmycbUbJz4xKmXHH/sYz bergey@wonderlust" ];
  };

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
  services.printing = {
    enable = true;
    drivers = [pkgs.foomatic_filters];
  };

  services.cron.mailto = "bergey@localhost";
  services.cron.systemCronJobs = [ 
    "*/15 * * * * bergey export PATH=${pkgs.offlineimap}/bin:${pkgs.coreutils}/bin:${pkgs.gnused}/bin && offlineimap | /home/bergey/code/utility/add-date.sh >> /home/bergey/tmp/logs/offlineimap-log 2>&1"
    "*/15 * * * * bergey ${pkgs.python3}/bin/python3 /home/bergey/code/utility/sort_mail.py ${pkgs.notmuch}/bin/notmuch >> /home/bergey/tmp/logs/sort-log 2>&1"
 # "*/15 * * * * bergey pkill -2 -u $UID mu && sleep 1 && mu index"
    "1 1 * * * bergey export PATH=${pkgs.git}/bin:$PATH && /home/bergey/code/utility/auto-git.sh >> /home/bergey/tmp/logs/git-log 2>&1"
    "1 6 * * * bergey ${pkgs.python3}/bin/python3 /home/bergey/code/original/clean/clean.py"
    "23 12 * * * bergey /home/bergey/.config/imm/imm -u >> /home/bergey/tmp/logs/imm-log 2>&1"
    ];
  services.cron.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="1781", ATTR{idProduct}=="0c9f", GROUP="dialout", MODE="0666"
  '';

  services.virtualboxHost.enable = true;
  users.extraGroups.vboxusers.members = [ "bergey" ];

  networking.firewall.extraCommands = 
    "iptables -I nixos-fw 2 -p tcp -m tcp --dport 993 -j nixos-fw-accept
    iptables -I nixos-fw 2 -p udp -m udp --dport 60000:61000 -j nixos-fw-accept"; # IMAP & mosh

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
      layout = "dvorak,us";
    xkbOptions = "grp:shifts_toggle";
    xrandrHeads = ["DVI-D-0" "DVI-I-1" ];

    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    windowManager.default = "xmonad";
    desktopManager.default = "none";
    startGnuPGAgent = true;
    
    displayManager.sessionCommands = ''
      xmodmap ~/.Xmodmap
      xscreensaver -no-splash &
      emacs &
      ~/code/utility/logitech
      # ~/code/build/noip-2.1.9-1/noip2
    '';
   };

  # services.xserver.videoDrivers = [ "nouveau" ];
  services.xserver.videoDrivers = [ "nvidia" ];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql93;
    authentication = pkgs.lib.mkForce ''
      # Generated file; do not edit!
      local all yesodTutorial md5
      local all all ident
      host all all 127.0.0.1/32 md5
      host all all ::1/128 md5
    '';
  };
}
