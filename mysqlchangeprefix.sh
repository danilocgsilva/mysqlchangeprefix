#!/bin/bash

## version
VERSION="1.0.0"

ask () {
  read -p "$1" $2
  if [[ ${!2} = "" ]]
  then
    ask "$1" $2
  fi
}

loop_through_tables_with_prefix () {
  for i in $(mysql --login-path=$1 $2 -e "SHOW TABLES" | cat | sed 1d | sed -n /^$3/p)
  do
    new_table_name=$(get_name_name $i $3 $4)
    mysql --login-path=$1 $2 -e "RENAME TABLE $i TO $new_table_name"
    echo $i renomeada para $new_table_name
  done
}

get_name_name () {
  echo $1 | sed s/^$2/$3/g
}

## Main function
mysqlchangeprefix () {
  ask "Please, provides the login-path value: " login_path
  ask "Please, provides the database name: " database_name
  ask "Please, provides the old prefix: " database_old_prefix
  ask "Please, provides the new prefix: " database_new_prefix

  loop_through_tables_with_prefix \
    $login_path                   \
    $database_name                \
    $database_old_prefix          \
    $database_new_prefix
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
