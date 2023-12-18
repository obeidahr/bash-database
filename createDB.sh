#!/bin/bash

clear -x;
read -rp "Enter database name: " newDB;

while ! [[ $newDB =~ ^([a-zA-Z])[a-zA-Z0-9\w_-]*([a-zA-Z0-9])$ ]]; do
    echo "$newDB is not a valid name";
    echo "database names should not have any special characters, spaces, doesn't start with a number or end with a '-' or '_'";
    echo ""
    read -rp "Enter database name: " newDB;
done


if test -d Databases/$newDB; then
    echo "";
    echo "This database already exists!";
    bash createDB.sh
else
    if mkdir -p Databases/$newDB 2>> log.out; then
        echo "$newDB database created succesfully";
        echo ""
	bash stlog.sh creatDB $newDB root owner
	groupadd $newDB;
	while IFS= read -r line
	do
		usermod -a -G $newDB $line
	done < "/bash-database/admin.txt"
        # select permation
	while [ true ]; do
   	   read -rp "Choose database perm private(pr) public(pu): (pr/pu)" colDataType;
     		case "$colDataType" in
         		"pr" | "PR" ) chmod 700 Databases/$newDB
                 		break;;
         		"pu" | "PU" ) chmod 777 Databases/$newDB
                 		break;;
         		* ) echo "Invalid option $REPLY";;
      		esac
	done
	echo "update permations success"
	bash DBMenu.sh
    else
        echo "Falied to create $newDB. Refer to log.out for more details."
        echo ""
        bash createDB.sh
    fi
fi
