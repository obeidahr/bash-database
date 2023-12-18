#!/bin/bash

clear -x;
read -rp "Enter Table Name: " tableName;

# check if database exists
if [ -f  "$currDB/$tableName.idb" ] && [ -f  "$currDB/.$tableName.frm" ]; then
    echo "$tableName is selected.";
    echo ""
    export  tableName;
    bash tableMenu.sh;
else
    echo "$tableName table does not exist.";
    echo ""
    bash tablesMenu.sh
fi
