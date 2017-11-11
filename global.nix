let
  fetchNixpkgs = import ./fetchNixpkgs.nix;

  nixpkgs = fetchNixpkgs {
     rev = "7ebacd1a43d7112c75555414d968be9fc4c564a4";
     sha256 = "0rcipd0zkdrdk0r0rz59v5mdkqjgwpwnp2af6zdmgqxbh1467w8g";
  };

  pkgs = import nixpkgs { config = {}; };

in with pkgs; buildEnv {
  name = "bergey-env";
  paths= [
    gitAndTools.hub
    ripgrep
    notmuch
    stack
    vagrant
    unison
    ] ++ (if stdenv.isDarwin then [] else [
        gitAndTools.git-annex
        crawl
    ]);
  }
