pkgs : 
{ 
  allowUnfree = true;
  packageOverrides = self: with self; rec {
    # common haskell packages with external dependencies
    external-deps = (hsPkgs: [
      hsPkgs.zlib
      hsPkgs.terminfo
    ]);
    # as much as is useful for building Diagrams quickly
    diagrams-deps = (hsPkgs: [
      hsPkgs.zlib
      hsPkgs.terminfo
      hsPkgs.OpenGL
      hsPkgs.GLFWB
      hsPkgs.glib
      hsPkgs.gio
      hsPkgs.gtk
      hsPkgs.pango
      hsPkgs.lens
      hsPkgs.textIcu
    ]);
    ghc74-bare = self.haskellPackages_ghc742.ghcWithPackagesOld (hsPkgs : [ ]);
    ghc74 = self.haskellPackages_ghc742.ghcWithPackagesOld external-deps;
    ghc74-diagrams = self.haskellPackages_ghc742.ghcWithPackagesOld diagrams-deps;
    ghc76-bare = self.haskellPackages_ghc763.ghcWithPackagesOld (hsPkgs : []);
    ghc76 = self.haskellPackages_ghc763.ghcWithPackagesOld external-deps;
    ghc76-diagrams = self.haskellPackages_ghc763.ghcWithPackagesOld diagrams-deps;
    ghc78-bare = self.haskellPackages_ghc782.ghcWithPackagesOld (hsPkgs : [ ]);
    ghc78 = self.haskellPackages_ghc782.ghcWithPackagesOld external-deps;
    ghc78-diagrams = self.haskellPackages_ghc782.ghcWithPackagesOld diagrams-deps;
    ghcHEAD = self.haskellPackages_ghcHEAD.ghcWithPackagesOld external-deps;

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
            gimp_2_8 # server down?
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
};
}
