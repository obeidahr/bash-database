#!/bin/bash

clear -x;
bash /bash-database/showDeletDatab.sh;
read -rp "Enter Database name: " databaseName;

#while ! [[ $currDB =~ ^([a-zA-Z])[a-zA-Z0-9\w_-]*([a-zA-Z0-9])$ ]]; do
 #   echo "$currDB is not a valid name";
  #  echo "database names should not have any special characters, spaces, doesn't start with a number or end with a '-' or '_'";
   # echo ""
    #read -rp "Enter database name: " currDB;
#done

if [ -d  "Databases/$databaseName" ]; then
    chmod +t "Databases/$databaseName";
    if [ "$(ls -A Databases/$databaseName)" = "" ]; then
      echo "Database is empty. Deleting it."
	bash stlog.sh deletDB $databaseName root owner
      rm -r Databases/$databaseName
    else
      echo "Database is not empty."
    fi
    bash DBMenu.sh
  else
    echo "No such Database"
    echo ""
    bash DBMenu.sh
fi
