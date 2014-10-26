pkgs : 
{ 
  allowUnfree = true;
  packageOverrides = self: with self; rec {
    # common haskell packages with external dependencies
    external-deps = (hsPkgs: [
      hsPkgs.zlib
      hsPkgs.terminfo
      hsPkgs.digest
      # hsPkgs.ncurses
      hsPkgs.regexPosix
      hsPkgs.utf8String
    ]);
    diagrams-external = (hsPkgs: (external-deps hsPkgs) ++ [
      hsPkgs.arithmoi
      hsPkgs.cairo
      # hsPkgs.directory
      hsPkgs.gio
      hsPkgs.glib
      hsPkgs.gtk
      hsPkgs.hinotify
      hsPkgs.pango
      hsPkgs.primitive
      hsPkgs.textIcu
    ]);
    # Haskell packages needed for diagrams-doc which have non-Haskell dependencies
    diagrams-doc = hs: (diagrams-external hs ++ [
      hs.unixCompat
      hs.liftedBase
      hs.hsBibutils
      hs.bytestringMmap
      hs.highlightingKate
      hs.network
      # hs.pandoc
    ]);
    # as much as is useful for building Diagrams quickly
    diagrams-deps = (hsPkgs:(diagrams-external hsPkgs) ++ [
      hsPkgs.lens
      hsPkgs.parsec
      hsPkgs.colour
      hsPkgs.text
      hsPkgs.semigroups
      hsPkgs.optparseApplicative
    ]);
    hakyll-deps = (hsPkgs: [
      hsPkgs.hakyll
    ]);
    ghc74-bare = self.haskellPackages_ghc742.ghcWithPackagesOld (hsPkgs : [ ]);
    ghc74 = self.haskellPackages_ghc742.ghcWithPackagesOld external-deps;
    ghc74-diagrams-ext = self.haskellPackages_ghc742.ghcWithPackagesOld diagrams-external;
    ghc74-diagrams = self.haskellPackages_ghc742.ghcWithPackagesOld diagrams-deps;
    ghc76-bare = self.haskellPackages_ghc763.ghcWithPackagesOld (hsPkgs : []);
    ghc76 = self.haskellPackages_ghc763.ghcWithPackagesOld external-deps;
    ghc76-diagrams = self.haskellPackages_ghc763.ghcWithPackagesOld diagrams-deps;
    ghc78-bare = self.haskellPackages_ghc783.ghcWithPackagesOld (hsPkgs : [ ]);
    ghc78 = self.haskellPackages_ghc783.ghcWithPackagesOld external-deps;
    ghc78-diagrams-ext = self.haskellPackages_ghc783.ghcWithPackagesOld diagrams-external;
    ghc78-diagrams = self.haskellPackages_ghc783.ghcWithPackagesOld diagrams-deps;
    ghc78-diagrams-doc = self.haskellPackages_ghc783.ghcWithPackagesOld diagrams-doc;
    ghc78-hakyll = self.haskellPackages_ghc783.ghcWithPackagesOld hakyll-deps;
    ghcHead = self.haskellPackages_ghcHEAD.ghcWithPackagesOld external-deps;
    ghcHead-diagrams = self.haskellPackages_ghcHEAD.ghcWithPackagesOld diagrams-deps;

    vcsTools = self.buildEnv {
        name = "vcsTools";
        paths = [
            subversion
            git
            bazaar
            darcs
            mercurial
            gitAndTools.hub
            mr
        ];
    };
    
    graphicsTools = buildEnv {
	name = "graphicsTools";
	paths = [
            inkscape
            gimp_2_8
            vlc
        ];
    };
 
    officeTools = buildEnv {
        name = "officeTools";
        paths = [
            calibre
            libreoffice 
        ];
    };

    rToolsEnv = buildEnv {
      name = "rTools";
      paths = with rPackages; [
        devtools
        ggplot2
        R
      ];
    };

    photoTools = buildEnv {
      name = "photoTools";
      paths = [
        gphoto2
        darktable
        gimp
        imagemagick
        perlPackages.ImageExifTool
      ];
    };

    cadTools = buildEnv {
      name = "cadTools";
      paths = [
        meshlab
        slic3r
        openscad
      ];
    };

    webBrowsers = buildEnv {
      name = "webBrowsers";
      paths = [
        firefox-bin
        chromium
        elinks
        # for comparison
        # uzbl
        # dwb
        # netsurf
      ];
};

      docTools = buildEnv {
        name = "docTools";
        paths = [
          calibre
          libreoffice
          haskellPackages.pandoc
          # texLiveFull
          zathura
        ];
      };

      avTools = buildEnv {
        name = "avTools";
        paths = [
          abcde
          id3v2
          vlc
        ];
      };

      vmTools = buildEnv {
        name = "vmTools";
        paths = [
          vagrant
          linuxPackages.virtualbox
        ];
      };

    immHg = self.haskellPackages.callPackage /home/bergey/code/contributing/imm {};
    imm = self.haskellPackages.callPackage /home/bergey/records/dotfiles/imm/.config/imm {imm = immHg;};
    };
}
