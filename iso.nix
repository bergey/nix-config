# https://nixos.wiki/wiki/Creating_a_NixOS_live_CD
# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.
{config, pkgs, ...}:
{
    imports = [
        <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

        # Provide an initial copy of the NixOS channel so that the user
        # doesn't need to run "nix-channel --update" first.
        <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ];

    networking.wireless.enable = false;
    networking.networkmanager.enable = true; # NetworkManager, including nmcli & nmtui (no applet)

    i18n = {
        consoleKeyMap = "dvorak";
        defaultLocale = "en_US.UTF-8";
    };
    time.timeZone = "UTC";
  
    environment.systemPackages = with pkgs; [
        acpi
        curl
        git
        gitAndTools.hub
        gnupg
        mr
        pass
        ripgrep
        rsync
        stow
        w3m
        wget
        vim
    ] ++ (import <nixpkgs/nixos/modules/profiles/base.nix> {lib = pkgs.lib; inherit pkgs;}).environment.systemPackages;

    hardware.u2f.enable = true;
}
