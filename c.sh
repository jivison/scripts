#!/bin/zsh
#$ {"name": "c", "language": "shell", "description": "Compiles and runs a c program"}

gcc -o "$1" "${1}.c"
exec "./$1"