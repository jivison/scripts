#!/bin/zsh

ghc -o "$1" "${1}.hs"
exec "./$1"