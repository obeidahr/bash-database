#!/bin/bash

options=("Show Databases" "Create New Database" "Use Database" "Delete Database" "Emptying Database" "backup" "Quit")

select option in "${options[@]}"
do
    case $option in
        "Show Databases") bash showDB.sh;;
        "Create New Database") bash createDB.sh;;
        "Use Database") bash useDB.sh;;
        "Delete Database") bash deleteDB.sh;;
	"Emptying Database") bash emptyDB.sh;;
	"backup") bash bac.sh;;
        "Quit") exit;;
        *) echo "Invalid option $REPLY";;
    esac
done
