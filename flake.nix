{
  description = "A highly customizable Haskell flake";
  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      ghcVersion = "98";
      pkgs = nixpkgs.legacyPackages.${system};
      hPkgs = pkgs.haskell.packages."ghc${ghcVersion}";
      ghc = hPkgs.ghcWithPackages (ps:
        with ps; [
          # Packages to make available to GHC
          ghcid # Needed for nixvim LSP
          megaparsec
        ]);
      myLocalDevTools = with pkgs; [
        # System level dependencies
        ghc
        cabal-install
        haskellPackages.implicit-hie # Needed for nixvim LSP
        (haskell-language-server.override {
          supportedGhcVersions = [ "${ghcVersion}" ];
        })
      ];
      myLibDeps = with pkgs;
        [
          # External libraries that may be required
          zlib
        ];
    in {
      defaultPackage.${system} = pkgs.haskellPackages.developPackage {
        root = ./.;
        modifier = drv: pkgs.haskell.lib.addBuildTools drv myLocalDevTools;
      };
      devShells.${system}.default = pkgs.mkShell {
        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath myLibDeps;
        nativeBuildInputs = myLocalDevTools;
      };
    };
}
