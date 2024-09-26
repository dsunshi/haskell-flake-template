{
  description = "my project description";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/master";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  # When building myApp through pkgs.haskell.lib.buildStackProject (down below)
  # Stack should download Haskell packages directly from Stackage and bypass Nix,
  # so force Nix to allow this "non-sandboxed" build. See https://zimbatm.com/notes/nix-packaging-the-heretic-way
  nixConfig.sandbox = "relaxed";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Nix GHC version needs to be the one that the stack.yaml resolver expects.
        #
        # Find out available Nix GHCs:
        # ```
        # $ nix repl
        # nix-repl> :lf nixpkgs
        # nix-repl> legacyPackages.x86_64-linux.haskell.packages.<TAB>
        # ```
        # `:lf` stands for "load flake"
        #
        # Find out expected Stack GHCs:
        # Visit https://www.stackage.org/ and look for LTS or Nightlies, e.g.
        # resolver: lts-20.11          expects ghc-9.2.5
        # resolver: nightly-2023-02-14 expects ghc-9.4.4
        #
        # So if you use "ghc944", set "resolver: nightly-2023-02-14" in your stack.yaml file
        hPkgs = pkgs.haskell.packages."ghc928";

        myLibDeps = [
          pkgs.zlib # External C compression library needed by some Haskell packages
        ];

        myLocalDevTools = with pkgs; [
          hPkgs.ghc # GHC compiler in the version above; verify with `ghc --version`
          hPkgs.haskell-language-server # LSP server for editor, this must match ghc in order to work!
          stack
          haskellPackages.hlint # Haskell codestyle checker
          haskellPackages.hoogle # Lookup Haskell documentation
          # hPkgs.cabal-install
        ];

        myApp = pkgs.haskell.lib.buildStackProject {
          name = "myStack";
          src = ./.;
          ghc = hPkgs.ghc;
          buildInputs = myLibDeps;
        };

      in {
        devShells.default = pkgs.mkShell {
          buildInputs = myLocalDevTools;

          # Make external Nix C libraries like zlib known to GHC, like pkgs.haskell.lib.buildStackProject does
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath myLibDeps;
        };
        packages.default = myApp;
      });
}

