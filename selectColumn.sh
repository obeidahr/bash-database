#!/bin/bash

# for debugging
# currDB="Databases/iti"
# tableName="emp";

clear -x;
tableData="$currDB/$tableName.idb"
tableFormat="$currDB/.$tableName.frm"

columns=()

# get column names
read -d '\n' -r -a lines < "$tableFormat"
for i in "${!lines[@]}" # each line of the format table
do
  IFS=':' read -r -a column <<< "${lines[i]}"; # get parts of that particular line
  name=${column[0]};
  columns+=($name)
done

# show columnNames as options
select column in ${columns[@]};
do
    clear -x;
    echo "Selected column: $column"
    let colIndex=($REPLY)

	awk -v i="$colIndex" -F':' '{ print $i }' $tableData # display the selected column
	break;
done


echo "------------------------";
bash tableMenu.sh
