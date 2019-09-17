#!/bin/zsh

gcc -o "$1" "${1}.c"
exec "./$1"