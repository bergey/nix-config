pkgs : 
{ 
  cabal.libraryProfiling = true;
  packageOverrides = self : rec {
    ghc74 = self.haskellPackages_ghc742.ghcWithPackagesOld (hsPkgs : [
    ]);
    ghc74-platform = self.haskellPackages_ghc742.ghcWithPackagesOld (hsPkgs : [
      hsPkgs.haskellPlatform
    ]);
    ghc76 = self.haskellPackages_ghc763.ghcWithPackagesOld (hsPkgs : []);
    # everything I like to have around to make Diagrams builds faster
    ghc76-diagrams = self.haskellPackages_ghc763.ghcWithPackagesOld (hsPkgs : [
      hsPkgs.zlib
      hsPkgs.OpenGL
      hsPkgs.GLFWB
      hsPkgs.glib
      hsPkgs.pango
      hsPkgs.lens
    ]);
    ghc76-cairo = self.haskellPackages_ghc763.ghcWithPackagesOld (hsPkgs : [ 
    hsPkgs.zlib
    hsPkgs.pango
    hsPkgs.text-icu
    ]);
    ghc76-zlib = self.haskellPackages_ghc763.ghcWithPackagesOld (hsPkgs : [
      hsPkgs.zlib
      hsPkgs.terminfo
    ]);
    ghc78 = self.haskellPackages_ghc782.ghcWithPackagesOld (hsPkgs : [ ]);
    ghc78-diagrams = self.haskellPackages_ghc782.ghcWithPackagesOld (hsPkgs : [ 
      hsPkgs.zlib
      hsPkgs.OpenGL
      hsPkgs.GLFWB
      hsPkgs.glib
      hsPkgs.pango
      hsPkgs.lens
      hsPkgs.gio
      hsPkgs.gtk
    ]);
    ghc78-cairo = self.haskellPackages_ghc782.ghcWithPackagesOld (hsPkgs : [ 
    hsPkgs.zlib
    hsPkgs.pango
    ]);
    ghc78-base = self.haskellPackages_ghc782.ghcWithPackagesOld (hsPkgs : [
    hsPkgs.zlib
    hsPkgs.terminfo]);
    ghcHEAD = self.haskellPackages_ghcHEAD.ghcWithPackagesOld (hsPkgs : [
    hsPkgs.zlib
    ]);

    pythonEnv = self.myEnvFun {
      name = "python";
      buildInputs = [
        self.python3
      ];
    };

};
}
