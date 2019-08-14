#!/bin/zsh

commandOutput=$(python3 /home/john/scripts/teleport.py $1 $2)
if [[ "$1" == "--list" || "$1" == "--set" ]]; then
    echo "$commandOutput"
elif [[ "$1" == "go" ]]; then
    if [[ "$commandOutput" == *"not found"* ]]; then
        echo "$commandOutput"
    else
        cd "$commandOutput"
        echo "Teleported to alias ${2}"
    fi
fi