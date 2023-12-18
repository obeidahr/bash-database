#!/bin/bash

tables_menu(){
    options=("Show Tables" "Create New Table" "Use Table" "Delete Table" "Return To Main Menu");

    select option in "${options[@]}"
    do
        case $option in
            "Show Tables") bash showTables.sh;;
            "Create New Table") bash createTables.sh;;
            "Use Table") bash useTable.sh;;
            "Delete Table") bash deleteTable.sh;;
            "Return To Main Menu") bash DBMenu.sh;;
            *) echo "Invalid option $REPLY";;
        esac
    done
}

tables_menu
