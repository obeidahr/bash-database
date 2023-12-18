#!/bin/bash

clear -x;
echo "-------$tableName-------";
echo "--------Delete----------";

options=("By Column" "Return To Previous Menu");

select option in "${options[@]}"
do
    case $option in
        "By Column") bash deleteByColumn.sh;;
        "Return To Previous Menu") bash tableMenu.sh;;
        *) echo "Invalid option $REPLY";;
    esac
done
