#!/bin/bash

clear -x;

echo "-------$tableName-------";
echo "-------- Update ----------";

options=("Column" "By Column" "Return To Previous Menu");

select option in "${options[@]}"
do
    case $option in
        "Column") bash updateColumn.sh;;
        "By Column") bash updateByColumn.sh;;
        "Return To Previous Menu") bash tableMenu.sh;;
        *) echo "Invalid option $REPLY";;
    esac
done
