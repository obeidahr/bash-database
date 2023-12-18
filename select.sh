#!/bin/bash

echo "-------$tableName-------";
echo "--------SELECT----------";

options=("All" "Column" "By Column" "Return To Previous Menu");

select option in "${options[@]}"
do
    case $option in
        "All") bash displayTable.sh;;
        "Column") bash selectColumn.sh;;
        "By Column") bash selectByColumn.sh;;
        "Return To Previous Menu") bash tableMenu.sh;;
        *) echo "Invalid option $REPLY";;
    esac
done
