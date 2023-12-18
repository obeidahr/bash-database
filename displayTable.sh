#!/bin/bash

# for debugging
# currDB="Databases/iti"
# tableName="emp";

clear -x;
tableData="$currDB/$tableName.idb"
tableFormat="$currDB/.$tableName.frm"

awk -F: 'BEGIN { ORS=":" }; { print $1 }' $tableFormat | sed 's/.$//'
printf "\n"
cat $tableData

echo ""
bash tableMenu.sh
