#!/bin/bash

echo "-------$tableName-------";
echo "------------------------";

options=("Display Table(retrieving data)" "Insert" "Select" "Update" "Delete" "Return To Previous Menu");

select option in "${options[@]}"
do
    case $option in
        "Display Table(retrieving data)") bash displayTable.sh;;
        "Insert") bash insert.sh;;
        "Select") bash select.sh;;
        "Update") bash update.sh;;
        "Delete") bash delete.sh;;
        "Return To Previous Menu") bash tablesMenu.sh;;
        *) echo "Invalid option $REPLY";;
    esac
done
