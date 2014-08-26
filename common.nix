{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nix.gc.automatic = true;
  nix.gc.dates = "8:00";

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

}
