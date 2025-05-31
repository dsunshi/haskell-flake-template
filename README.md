<p align="center">
<img src="https://github.com/dsunshi/haskell-flake-template/blob/2a638a0ddd4bc605f0609531258af2207689bfda/assets/Haskell_Nix.png" width="480" height="270" /> 
</p>

# Haskell Flake Template

# What's included?

* [GHC](https://www.haskell.org/ghc/)
* [Cabal](https://www.haskell.org/cabal/)
* [Grip](https://github.com/joeyespo/grip)
* [Stack](https://docs.haskellstack.org/en/stable/)
  * `stack.yaml`
  * `shell.nix`
* [implicit-hie](https://github.com/Avi-D-coder/implicit-hie)
* [haskell-language-server](https://github.com/haskell/haskell-language-server)
* `.gitignore`
* `.envrc`
* `clean.sh`
* [Nix flake](https://wiki.nixos.org/wiki/Flakes)
  * `flake.nix`

## C-libraries (often required by Haskell applications):

* zlib

## Optional features

It should be easy to add the following by un-commenting code in `flake.nix`:
* [ormolu](https://github.com/tweag/ormolu)
* [hlint](https://github.com/ndmitchell/hlint)
* [hoogle](https://github.com/ndmitchell/hoogle?tab=readme-ov-file#command-line-version)
* [retrie](https://github.com/facebookincubator/retrie)
* [threadscope](https://github.com/haskell/ThreadScope)
* [markdown-unlint](https://github.com/sol/markdown-unlit)

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

## Starting your own project

Since `haskell-flake-template` is it's own `git` repository you may want to delete this information and restart your project as it's own `git` project. You can do this by:

1. Remove all `haskell-flake-template` `git` data:
```bash
rm -rf .git/
```

2. Create a new `git` project:
```bash
git init
```

> [!TIP]
> It is also possible to run the included `clean.sh` to revert the template into a fresh
> state, ready to start a new project (the next steps).
> [!CAUTION]
> Once you create your project, this should **never** be used again.

3. Setup Cabal:
```bash
cabal init
```
**or**
```bash
cabal init --non-interactive
```

### Adding Haskell libraries

> [!NOTE]
> In order to add a Haskell library, add the name of the library:
> 1. In `flake.nix` under the comment `# Other Haskell modules go here:` inside the variable `ghc`
> 2. In the `build-depends` section of your `.cabal` file

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
> [!CAUTION]
> `Failed to run ["cabal","v2-repl" ...`

when using `vim/nvim` it may be necesarry to have a `hie.yaml` file. This flake includes
a tool `gen-hie` which will echo the proper outputs to `stdout`. Therefore, if you would like to
auto-generate `hie.yaml` it is as simple as:

```bash
gen-hie > hie.yaml
```
in the root directory of your project.

## Cabal hints

For the sake of cabal, and the haskell-lsp any new modules (haskell source files) need to be
added to your `.cabal` file in the `other-modules:` section.

### Optional

Download local hoogle index:
```bash
hoogle generate --download
```
