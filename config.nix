pkgs :
{
  allowUnfree = true;
  packageOverrides = self: with self; rec {

    haskellTools = spec: ([
        spec.ghc
        sloccount
    ] ++ (with spec.hsPkgs; [
        hlint
        cabalInstall
    ]) ++ (with haskellPackages_ghc783; [
        cabal2nix
        hasktags
        # threadscope # broken 2014-11-19
    ]));

    ghcEnv = spec: myEnvFun {
        name = spec.name;
        buildInputs = haskellTools spec ++ myHaskellPackages spec;
    };

    ghcEnv_g42 = ghcEnv {
        name = "ghc742";
        ghc = ghc.ghc742;
        hsPkgs = haskellPackages_ghc742;
    };

    ghcEnv_763 = ghcEnv {
        name = "ghc763";
        ghc = ghc.ghc763;
        hsPkgs = haskellPackages_ghc763;
    };

    ghcEnv_783 = ghcEnv {
        name = "ghc783";
        ghc = ghc.ghc783;
        hsPkgs = haskellPackages_ghc783;
    };

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

      docutilsEnv = myEnvFun {
          name = "docutils";
          buildInputs = with python33Packages; [
              haskellPackages.pandoc
              ipython
              docutils
              pygments
          ];
      };
      pythonEnv = myEnvFun {
        name = "python";
        buildInputs = with python33Packages; [
            git
            stdenv
            zlib
            python27Full
            ipython
            pandas
            matplotlib
            scipy
            tkinter
            ];
      };

      # jsEnv = myEnvFun {
      jsTools = buildEnv {
        name = "js";
        # buildInputs = [
        paths = [
              # nodePackages.browserify
              nodePackages.jshint
              nodePackages.gulp
              nodePackages.grunt-cli
              nodePackages.mocha
              nodejs
              rubyLibs.sass
        ];
    };

    # rarely used
    androidEnv = myEnvFun {
      name = "android";
      buildInputs = [
          davfs
          wdfs-fuse
          androidsdk
      ];
    };


    arduinoEnv = myEnvFun {
        name = "arduino";
        buildInputs = [
            arduino_core
            avrgcclibc
            avrdude
            ino
            stdenv
        ];
    };

    scalaEnv = myEnvFun {
        name = "scala";
        buildInputs = [
            sbt
            scala
        ];
    };

    clojureEnv = myEnvFun {
        name = "clojure";
        buildInputs = [
            leiningen
        ];
    };

    rustEnv = myEnvFun {
        name = "rust";
        buildInputs = [
            rust
        ];
    };

    # this is very long!
    myHaskellPackages = spec: with spec.hsPkgs; [
        HUnit
        aeson
        attoparsec
        cassava
        cereal
        colour
        conduit
        dataDefault
        diagramsCairo
        diagramsContrib
        diagramsLib
        digest
        glib
        gtk
        # hakyll # broken 2014-11-19
        highlightingKate
        hinotify
        hsBibutils
        hslogger
        hspec
        # ncurses # broken 2014-11-19
        network
        optparseApplicative
        pandoc
        pango
        parsec
        primitive
        random
        regexPosix
        semigroups
        shelly
        tasty
        terminfo
        testFramework
        text
        textIcu
        transformers
        unixCompat
        unorderedContainers
        utf8String
        zlib
        cairo
    ]

    ++ stdenv.lib.optionals
        (stdenv.lib.versionOlder "7.7" spec.ghc.version)
        # Packages that only work in 7.8+
        [   units
            criterion
        ]

    ++ stdenv.lib.optionals
        (stdenv.lib.versionOlder "7.5" spec.ghc.version)
        # Packages that only work in 7.6+
        [
            linear
            lens
        ];

    };
}
