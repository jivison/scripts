#!/bin/zsh
#$ {"name": "knexReset", "language": "shell", "description": "Resets the current knex database"}

knex migrate:rollback
knex migrate:latest

knex seed:run