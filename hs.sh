#!/bin/zsh
#$ {"name": "hs", "language": "shell", "description": "Compiles and runs a haskell program"}

ghc -o "$1" "${1}.hs"
exec "./$1"