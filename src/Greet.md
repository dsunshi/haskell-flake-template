
# Literate Haskell

Code inside of the haskell fence will be compiled as part of the project:
```haskell
module Greet(greet) where

greet :: String -> String
greet name = "Hello " ++ name ++ "!!"
```
Here a single function `greet` is exported my the `Greet` module.

# Getting Started

1. Create a `.md` file (such as this!)
2. Create a symbolic link from the `.md` file to a `.lhs`:
```bash
ln -s Greet.md Greet.lhs
```
3. Add the module to your `.cabal` file:
```txt
    other-modules:      Greet
```
