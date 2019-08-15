# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.trustedUsers = [ "bergey" ];
  nix.binaryCaches = [ "https://cache.nixos.org/" "https://nixcache.reflex-frp.org" ];
  nix.binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = true;
  services.zfs.autoScrub.enable = true;
  networking.hostId = "a9d1a9c2"; # required for ZFS

  networking.hostName = "prandtl"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # NetworkManager, including nmcli & nmtui (no applet)

  # Select internationalisation properties.
   i18n = {
     consoleFont = "Lat2-Terminus16";
     consoleKeyMap = "dvorak";
     defaultLocale = "en_US.UTF-8";
   };

  # Set your time zone.
  time.timeZone = "UTC";

#  virtualisation.xen = {
#    enable = true;
#    domain0MemorySize = 8192;
#  };
virtualisation.docker.enable = true;


  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
   environment.systemPackages = with pkgs; [
     cacert
     wget vim
     xlibs.xmodmap
     # pavucontrol
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.ssh.startAgent = false;

  hardware.pulseaudio.enable = true;
  hardware.u2f.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "dvorak";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.displayManager.slim.enable = true;

  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl intel-media-driver beignet ];

  systemd.user.services.xscreensaver = {
        enable = true;
        description = "XScreensaver";
        serviceConfig = {
            PartOf = [ "graphical-session.target" ];
            ExecStart = "${pkgs.xscreensaver}/bin/xscreensaver -no-splash";
        };
        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session-pre.target" ];
  };

  # https://nixos.wiki/wiki/Dropbox
  # https://discourse.nixos.org/t/using-dropbox-on-nixos/387/10
  systemd.user.services.dropbox = {
        enable = true;
        description = "Dropbox";
        serviceConfig = {
            ExecStart = "${pkgs.dropbox-cli}/bin/dropbox start";
            Type = "forking";
            ExecReload = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
            KillMode = "control-group"; # upstream recommends process
            Restart = "on-failure";
            PrivateTmp = true;
            ProtectSystem = "full";
            Nice = 10;
        };
        wantedBy = [ "graphical-session.target" ];
  };

  fileSystems."/mnt/babel" = {
      label = "Babel";
      fsType = "ext4";
      options = [ "relatime" "noauto" ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.extraUsers.bergey = {
     isNormalUser = true;
     uid = 1000;
     extraGroups = [ "audio" "wheel" "networkmanager" "docker" "dialout" ];
   };

  fonts.fonts = with pkgs; [
    gentium
    inconsolata
    # tex-gyre
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
