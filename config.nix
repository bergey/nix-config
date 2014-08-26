pkgs : 
{ 
  allowUnfree = true;
  packageOverrides = self: with self; rec {
    # common haskell packages with external dependencies
    external-deps = (hsPkgs: [
      hsPkgs.zlib
      hsPkgs.terminfo
      hsPkgs.digest
      hsPkgs.ncurses
    ]);
    diagrams-external = (hsPkgs: (external-deps hsPkgs) ++ [
      hsPkgs.glib
      hsPkgs.gio
      hsPkgs.gtk
      hsPkgs.pango
      hsPkgs.textIcu
      hsPkgs.arithmoi
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
    ghc74-diagrams = self.haskellPackages_ghc742.ghcWithPackagesOld diagrams-deps;
    ghc76-bare = self.haskellPackages_ghc763.ghcWithPackagesOld (hsPkgs : []);
    ghc76 = self.haskellPackages_ghc763.ghcWithPackagesOld external-deps;
    ghc76-diagrams = self.haskellPackages_ghc763.ghcWithPackagesOld diagrams-deps;
    ghc78-bare = self.haskellPackages_ghc783.ghcWithPackagesOld (hsPkgs : [ ]);
    ghc78 = self.haskellPackages_ghc783.ghcWithPackagesOld external-deps;
    ghc78-diagrams-ext = self.haskellPackages_ghc783.ghcWithPackagesOld diagrams-external;
    ghc78-diagrams = self.haskellPackages_ghc783.ghcWithPackagesOld diagrams-deps;
    ghc78-hakyll = self.haskellPackages_ghc783.ghcWithPackagesOld hakyll-deps;
    ghcHead = self.haskellPackages_ghcHEAD.ghcWithPackagesOld external-deps;
    ghcHead-diagrams = self.haskellPackages_ghcHEAD.ghcWithPackagesOld diagrams-deps;

    # hoogleLocal = self.haskellPackages.hoogleLocal.override {
    #  packages = diagrams-deps

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
};
}
