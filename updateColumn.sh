#!/bin/bash

# for debugging
# currDB="Databases/iti"
# tableName="emp";

tableData="$currDB/$tableName.idb"
tableFormat="$currDB/.$tableName.frm"

# which column to update
columns=();
dataTypes=();
PKs=();

clear -x;
# get column names and dataTypes
read -d '\n' -r -a lines < "$tableFormat"
for i in "${!lines[@]}" # each line of the format table
do
  IFS=':' read -r -a column <<< "${lines[i]}"; # get parts of that particular line

  name=${column[0]};
  dataType=${column[1]};
  PK=${column[2]};

  columns+=($name)
  dataTypes+=($dataType);
  PKs+=($PK);
done


echo "Which column do you want to update?";
# show columnNames as options
while [ true ]; do
  select column in ${columns[@]};
  do
      let colIndex=($REPLY)
      colname="${columns[$((colIndex-1))]}"
      colDataType="${dataTypes[$((colIndex-1))]}"
      colPK="${PKs[$((colIndex-1))]}"

      # clear -x;
      echo "-------------";
      # validate if PK
      if [[ $colPK == "yes" ]]; then
        clear -x;
        echo "$colname is a primary key and must be unique.";
        echo "";
        REPLY=; # reshow the selection menu
      elif [[ $colPK == "no" ]]; then
        clear -x;
        echo "Column: $colname, Data Type: $colDataType";
        #read new value from user
        read -rp "Enter $colname: " value;

        # validate the new value type
        if [[ $colDataType == "number" ]]; then
            while ! [[ $value =~ ^[0-9]+$ ]]; do
              echo "";
              clear -x;
                echo "$colname must be a number.";
                echo ""
                read -rp "Enter $colname: " value;
            done
        elif [[ $colDataType == "string" ]]; then
            while ! [[ $value =~ ^[a-zA-Z]+$ ]]; do
              clear -x;
              echo "";
                echo "$colname must be a string.";
                echo ""
                read -rp "Enter $colname: " value;
            done
        fi
        break 2;
      fi
  done
done

clear -x;
echo "------------ UPDATE $tableName set $colname = $value ------------";
# awk -v i="$colIndex" -v v=$value -F':' '{if ($i == v) print $0;}' $tableData;
echo "$(awk -v i="$colIndex" -v v=$value -F':' 'BEGIN{OFS=FS}{$i=v; print $0;}' $tableData)" 1> $tableData
echo "------------ is run successfully ------------";
bash stlog.sh updateColumn "" root owner
echo "";
echo "";
echo "------------------------";
options=("Update Another Column" "Return To The Update Menu" "Return To The Table Menu");

select option in "${options[@]}"
do
    case $option in
        "Update Another Column") bash updateColumn.sh;;
        "Return To The Update Menu") bash update.sh;;
        "Return To The Table Menu") bash tableMenu.sh;;
        *) echo "Invalid option $REPLY";;
    esac
done
