#!/bin/bash

clear -x;
read -rp "Enter table name: " tableName;

# Validate the entered name
while ! [[ $tableName =~ ^([a-zA-Z])[a-zA-Z0-9\w_-]*([a-zA-Z0-9])$ ]]; do
    echo "$tableName is not a valid name";
    echo "table names should not have any special characters, spaces, doesn't start with a number or end with a '-' or '_'";
    echo ""
    read -rp "Enter table name: " tableName;
done

function createTableFiles(){
    currDB=$1;
    tableName=$2;

    success=0

    # create tableName.idb
    if touch "$currDB/$tableName.idb" 2>> log.out; then
        echo "Data table created sucessfully." >> log.out;
        # create .tableName.frm
        if touch "$currDB/.$tableName.frm" 2>> log.out; then
            echo "Format file created sucessfully." >> log.out;
        else
            echo "Falied to create the format file. Check log.out for more details.";
            success=1
        fi
    else
        echo "Falied to create data table. Check log.out for more details.";
        success=1
    fi

    echo $success;
}

function createColumns(){
	currDB=$1;
    tableName=$2;

    read -rp "Enter number of columns: " numCols;

    # Validate the entered col num
    while ! [[ $numCols =~ ^[0-9]+$ ]]; do
        echo "$numCols is not a valid number";
        echo ""
        read -rp "Enter number of columns: " numCols;
    done

    for (( i=0; i<$numCols; i++ ))
    do
        colMetadata="";
        read -rp "Enter column name: " colName;

        # Validate the entered column name
        while ! [[ $colName =~ ^([a-zA-Z])[a-zA-Z0-9\w_-]*([a-zA-Z0-9])$ ]]; do
            echo "$colName is not a valid name";
            echo "column names should not have any special characters, spaces, doesn't start with a number or end with a '-' or '_'";
            echo ""
            read -rp "Enter column name: " colName;
        done

        colMetadata="$colName";

        # select column datatype (string, number)
        while [ true ]; do
            read -rp "Choose column's datatype String(s) Number(n): (s/n)" colDataType;
            case "$colDataType" in
                "s" | "S" ) colMetadata="$colMetadata:string"
                            break;;
                "n" | "N" ) colMetadata="$colMetadata:number"
                            break;;
                * ) echo "Invalid option $REPLY";;
            esac
        done

        # Is it Primary-Key (PK): (y/n):

        if ! [[ $pkFlag ]]; then
            while [ true ]; do
                read -rp "Is it Primary-Key (PK): (y/n)" pk;
                case "$pk" in
                    "y" | "Y" ) colMetadata="$colMetadata:yes"
                                pkFlag=1;
                                break;;
                    "n" | "N" ) colMetadata="$colMetadata:no"
                                break;;
                    * ) echo "Invalid option $REPLY";;
                esac
            done
        else
            colMetadata="$colMetadata:no"
        fi

        # create row containing column-info in table.frm (colName:dataType:PK)
        echo $colMetadata >> "$currDB/.$tableName.frm";
        echo "Column format added $colMetadata" >> log.out;
    done
}

# currDB="Databases/iti"    # for easy access # for development # now you can run ./createTable.sh directly to add into iti

# main
if test -f $currDB/$tableName 2> log.out; then
	echo "Table already exists. Check log.out for more details.";
else
    if [ $(createTableFiles "$currDB" "$tableName")  == 0 ]; then
        createColumns "$currDB" "$tableName"
        echo ""
        echo "$tableName table is created sucessfully";

        echo ""
        bash tablesMenu.sh
    fi
fi
