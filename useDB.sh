#!/bin/bash

clear -x;
read -rp "Enter Database name: " currDB;

while ! [[ $currDB =~ ^([a-zA-Z])[a-zA-Z0-9\w_-]*([a-zA-Z0-9])$ ]]; do
    echo "$currDB is not a valid name";
    echo "database names should not have any special characters, spaces, doesn't start with a number or end with a '-' or '_'";
    echo ""
    read -rp "Enter database name: " currDB;
done


# check if database exists
if [[ -d Databases/$currDB ]]
then
    echo "$currDB is selected.";
    echo ""
    export  currDB=Databases/$currDB;
    bash tablesMenu.sh;
else
    echo "Database does not exist.";
    echo ""
    bash DBMenu.sh
fi
