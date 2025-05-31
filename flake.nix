{
  description = "A highly customizable Haskell flake";
  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      # If using stack this version needs to match an LTS version from
      # https://www.stackage.org/
      ghcVersion = "984";
      pkgs = nixpkgs.legacyPackages.${system};
      hPkgs = pkgs.haskell.packages."ghc${ghcVersion}";
      ghc = hPkgs.ghcWithPackages (ps:
        with ps;
        [
          # Packages to make available to GHC
          ghcid # Needed for nixvim LSP
          # Other Haskell modules go here:
        ]);
      myLocalDevTools = with pkgs; [
        # System level dependencies
        ghc # GHC compiler in the desired version (will be available on PATH)
        cabal-install # Cabal
        python312Packages.grip # Amazing tool to live preview README changes
        stack-wrapped # See below for what this is
        haskellPackages.implicit-hie # Needed for nixvim LSP (auto generate LSP hie.yaml file from cabal)
        (haskell-language-server.override {
          supportedGhcVersions = [ "${ghcVersion}" ];
        })
        # Other development tools:
        /* haskellPackages.ormolu # Haskell formatter
           haskellPackages.hlint # Haskell codestyle checker
           haskellPackages.hoogle # Lookup Haskell documentation
           haskellPackages.retrie # Haskell refactoring tool
           haskellPackages.threadscope # A graphical tool for profiling parallel Haskell programs
           haskellPackages.markdown-unlit # Literate Haskell support for Markdown
        */
        # External libraries that may be required:
        zlib # External C library needed by some Haskell packages
      ];

      # Wrap Stack to work with our Nix integration. We don't want to modify
      # stack.yaml so non-Nix users don't notice anything.
      # - no-nix: We don't want Stack's way of integrating Nix.
      # --system-ghc    # Use the existing GHC on PATH (will come from this Nix file)
      # --no-install-ghc  # Don't try to install GHC if no matching GHC found on PATH
      # https://docs.haskellstack.org/en/stable/topics/nix_integration/
      stack-wrapped = pkgs.symlinkJoin {
        name = "stack"; # Make this wrapped version as the usual `stack`
        paths = [ pkgs.stack ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/stack \
            --add-flags "\
              --no-nix \
              --system-ghc \
              --no-install-ghc \
            "
        '';
      };
    in {
      defaultPackage.${system} = pkgs.haskellPackages.developPackage {
        root = ./.;
        modifier = drv: pkgs.haskell.lib.addBuildTools drv myLocalDevTools;
      };
      devShells.${system}.default = pkgs.mkShell {
        # Make external Nix c libraries like zlib known to GHC, like
        # pkgs.haskell.lib.buildStackProject does
        # https://github.com/NixOS/nixpkgs/blob/d64780ea0e22b5f61cd6012a456869c702a72f20/pkgs/development/haskell-modules/generic-stack-builder.nix#L38
        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath myLocalDevTools;
        nativeBuildInputs = myLocalDevTools;
      };
    };
}
