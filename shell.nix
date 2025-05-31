with (import <nixpkgs> { });

stdenv.mkDerivation {

  name = "stack-neovim-lsp";

  buildInputs = [ glpk pcre haskell.packages.lts-3_13.ghc ];

  STACK_IN_NIX_EXTRA_ARGS = " --extra-lib-dirs=${glpk}/lib"
    + " --extra-include-dirs=${glpk}/include" + " --extra-lib-dirs=${pcre}/lib"
    + " --extra-include-dirs=${pcre}/include";
}
