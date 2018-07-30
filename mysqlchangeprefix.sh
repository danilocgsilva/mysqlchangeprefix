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

loop_through_tables_with_prefix () {
  mysql --login-path=$1 $2 -e "SHOW TABLES" | cat | sed 1d | sed -n /^$3/p
}

## Main function
mysqlchangeprefix () {
  ask "Please, provides the login-path value: " login_path
  ask "Please, provides the database name: " database_name
  ask "Please, provides the prefix: " database_prefix

  loop_through_tables_with_prefix $login_path $database_name $database_prefix
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
