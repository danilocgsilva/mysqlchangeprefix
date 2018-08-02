#!/bin/bash

## version
VERSION="1.1.0"

ask () {
  read -p "$1" $2
  if [[ ${!2} = "" ]]
  then
    ask "$1" $2
  fi
}

ask_secret () {
  read -s -p "$1" $2
  echo ""
  if [[ ${!2} = "" ]]
  then
    ask_secret "$1" $2
    echo ""
  fi
}

loop_through_tables_with_prefix () {
  loginpath=$1
  databasename=$2
  olddatabaseprefix=$3
  newdatabaseprefix=$4
  username=$5
  password=$6

  #loop_tables $loginpath $databasename $username $password $olddatabaseprefix

  for i in $(loop_tables $loginpath $databasename $username $password $olddatabaseprefix)
  do
    oldtablename=$i
    new_table_name=$(get_name_name $oldtablename $olddatabaseprefix $newdatabaseprefix)
    rename_table $loginpath $databasename $username $password $oldtablename
    echo $i renamed to $new_table_name
  done
}


loop_tables () {

  loginpath=$1
  databasename=$2
  username=$3
  password=$4
  olddatabaseprefix=$5

  if [[ $loginpath != "-" ]]
  then
    mysql --login-path=$1 $databasename -e "SHOW TABLES" | cat | sed 1d | sed -n /^$olddatabaseprefix/p
  else
    mysql -u$username -p$password $databasename -e "SHOW TABLES" | cat | sed 1d | sed -n /^$olddatabaseprefix/p
  fi
}


rename_table () {
  loginpath=$1
  databasename=$2
  username=$3
  password=$4
  oldtablename=$5

  if [ $loginpath != "-" ]
  then
    mysql --login-path=$loginpath $databasename -e "RENAME TABLE $oldtablename TO $new_table_name"
  else
    mysql -u$username -p$password $databasename -e "RENAME TABLE $oldtablename TO $new_table_name"
  fi
}

get_name_name () {
  echo $1 | sed s/^$2/$3/g
}

## Main function
mysqlchangeprefix () {
  read -p "Please, provides the login-path value: " login_path
  ask "Please, provides the database name: " database_name
  ask "Please, provides the old prefix: " database_old_prefix
  ask "Please, provides the new prefix: " database_new_prefix

  if [[ $login_path = "" ]]
  then
    ask "Please, provides the database username: " username
    ask_secret "Please, provides the database password: " password
    login_path="-"
  fi

  loop_through_tables_with_prefix \
    $login_path                   \
    $database_name                \
    $database_old_prefix          \
    $database_new_prefix          \
    $username                     \
    $password
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
