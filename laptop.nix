# Edit this configuration file to define what should be installed on
# the system.  Help is available in the configuration.nix(5) man page
# or the NixOS manual available on virtual console 8 (Alt+F8).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
       ./systemPackages.nix
      ./common.nix
];

  boot.initrd.luks.devices = [
    {
      name = "luksroot";
      device = "/dev/sda4";
      preLVM = true;
    }
  ];

  nix.buildMachines = [{
    hostName = "bergey.hopto.org";
    sshUser = "bergey";
    system = "i686-linux";
    maxJobs = 4;
    sshKey = /home/bergey/.ssh/id_rsa;
    supportedFeatures = ["kvm"];
    mandatoryFeatures = [];
  }];
  nix.distributedBuilds = true;

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
    device = "/dev/sdb";
  }; 

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

    synaptics = {
      enable = true;
      minSpeed = "0.1";
      maxSpeed = "1.0";
      accelFactor = "0.05";
      additionalOptions = ''
        Option "MaxTapTime" "100"
      '';
    };
   };
}
