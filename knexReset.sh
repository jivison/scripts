#!/bin/zsh

knex migrate:rollback
knex migrate:latest

knex seed:run