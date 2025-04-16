# Haskell Flake Template

# What's included?

* ghc
* cabal
* stack
* hie

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

## Starting with your own git repository

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
## Stack (optional)

After Cabal has been setup (`cabal init`) it is possible to use stack as well:
```bash
stack init
```

## Optional

Allow direnv:
```bash
direnv allow
```

Download local hoogle index:
```bash
hoogle generate --download
```
