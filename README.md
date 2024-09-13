# haskell-flake-template

Opinionated batteries included template project for Haskell development.

## What's included?

This project bundles serveral niceties to help getting started with a new Haskell project:
- Nix flake
  - [Haskell language server](https://github.com/haskell/haskell-language-server)
  - Haskell debug adapter protocol
  - CLI [hoogle](https://hoogle.haskell.org/)
  - [Cabal](https://www.haskell.org/cabal/)
- [direnv](https://direnv.net/)
- Cabal
  - Turn incomplete patterns into errors

# Getting started

1. Checkout this repository:
```bash
git clone https://github.com/dsunshi/haskell-flake-template.git
cd haskell-flake-template
```
2. Allow direnv:
```bash
direnv allow
```
3. Update Cabal:
```bash
cabal update
```
4. Download local hoogle index (optional):
```bash
hoogle generate --download
```
