#!/bin/zsh

cwd=$(pwd) 


if [[ "$1" == "init" ]]; then
    rm -rf .todo
    mkdir .todo
    touch .todo/options.todo.json
    touch todo.json
    echo "{\"path\":\"${cwd}/todo.json\",\"optionsPath\":\"${cwd}/.todo/options.todo.json\"}" > .todo/options.todo.json
    echo "{\"items\" : []}" > todo.json
else
    node /home/john/scripts/todocli/findTodorc.js
    node /home/john/scripts/todocli/index.js
fis