#!/bin/bash

## version
VERSION="0.0.1"

ask () {
  read -p "$1" $2
  if [[ ${!2} = "" ]]
  then
    ask "$1" $2
  fi
}

## Main function
mysqlchangeprefix () {
  ask "Please, provides the login-path value: " login_path
  ask "Please, provides the database name: " database_name
  ask "Please, provides the prefix: " database_prefix
  echo login_path $login_path
  echo database_name $database_name
  echo database_prefix $database_prefix
}

## detect if being sourced and
## export if so else execute
## main function with args
if [[ /usr/local/bin/shellutil != /usr/local/bin/shellutil ]]; then
  export -f mysqlchangeprefix
else
  mysqlchangeprefix "${@}"
  exit 0
fi
