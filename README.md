{:.center}
[![Haskell Nix Flake](assets/Haskell_Nix.png)](https://github.com/dsunshi/haskell-flake-template)

# Haskell Flake Template

# What's included?

* ghc
* cabal
* stack
* hie
* `.gitignore`
* `.envrc`

## C-libraries (often required by Haskell applications):

* zlib

## Optional features

It should be easy to add the following by un-commenting code in `flake.nix`:
* ormolu
* hlint
* hoogle
* retrie
* threadscope
* markdown-unlint

# Getting Started

Checkout this repository:
```bash
git clone https://github.com/dsunshi/haskell-flake-template.git <my-project>
```

```bash
cd <my-project>
```

## Enable the flake

There are two ways to use the flake:
```bash
nix develop
```
(this would need to be done each time entering the `<my-project>` folder.

Allow direnv (once):
```bash
direnv allow
```

## Starting your own git repository

Since `haskell-flake-template` is it's own `git` repository you may want to delete this information and restart your project as it's own `git` project. You can do this by:

1. Remove all `haskell-flake-template` `git` data:
```bash
rm -rf .git/
```

2. Create a new `git` project:
```bash
git init
```

Setup Cabal:
```bash
cabal init
```
**or**
```bash
cabal init --non-interactive
```

### Adding Haskell libraries

In order to add a Haskell library, add the name of the library:
1. In `flake.nix` under the comment `# Other Haskell modules go here:` inside the variable `ghc`
2. In the `build-depends` section of your `.cabal` file

#### Example
In `flake.nix`:
```nix
      ghc = hPkgs.ghcWithPackages (ps:
        with ps;
        [
          # Packages to make available to GHC
          ghcid # Needed for nixvim LSP
          # Other Haskell modules go here:
          microlens
        ]);
```

In `<my-project>.cabal`:
```cabal
    build-depends:    base ^>=4.19.2.0, microlens
```

## Vim/Nvim

if you are facing code completion errors such as:
```
Failed to run ["cabal","v2-repl" ...
```
when using `vim/nvim` it may be necesarry to have a `hie.yaml` file. This flake includes
a tool `gen-hie` which will echo the proper outputs to `stdout`. Therefore, if you would like to
auto-generate `hie.yaml` it is as simple as:

```bash
gen-hie > hie.yaml
```
in the root directory of your project.

## Stack (optional)

After Cabal has been setup (`cabal init`) it is possible to use stack as well:
```bash
stack init
```

### Optional

Download local hoogle index:
```bash
hoogle generate --download
```

.center {
  text-align: center;
}
