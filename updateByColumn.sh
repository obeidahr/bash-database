#!/bin/bash

# for debugging
# currDB="Databases/iti"
# tableName="emp";

tableData="$currDB/$tableName.idb"
tableFormat="$currDB/.$tableName.frm"

# which column to select records by
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


echo "Which column do you want to select records by?";
# show columnNames as options
while [ true ]; do
  select column in ${columns[@]};
  do
      if [[ "\?" =~ "${column}" ]]; then # valid option
          echo "You need to choose one of the options";
          continue 2;
      fi

      let colIndex=($REPLY)
      colname="${columns[$((colIndex-1))]}"
      colDataType="${dataTypes[$((colIndex-1))]}"
      colPK="${PKs[$((colIndex-1))]}"

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

    read -d '' -r -a dataLines < "$tableData"  # all table
    #loop over column data to check pk if unique
    for j in "${!dataLines[@]}";
    do
        IFS=':' read -r -a record <<< "${dataLines[$j]}"; # record(row)

        if [[ ${record[$((colIndex-1))]} == $value ]]; then
         # echo "Matched Records";
         break 3;
        fi
    done
    echo "No Matched Records, press Enter to select again";
  done
done

queryColumnName=$colname

echo "Which column do you want to update?";
# show columnNames as options
while [ true ]; do
  select column in ${columns[@]};
  do
      if [[ "\?" =~ "${column}" ]]; then # valid option
          echo "You need to choose one of the options";
          continue 2;
      fi

      let updateColIndex=($REPLY)
      colname="${columns[$((updateColIndex-1))]}"
      colDataType="${dataTypes[$((updateColIndex-1))]}"
      colPK="${PKs[$((updateColIndex-1))]}"

    #read new value from user
    function validateValue(){
        # validate the new value type
        if [[ $colDataType == "number" ]]; then
            while ! [[ $updateColValue =~ ^[0-9]+$ ]]; do
                echo "$colname must be a number.";
                echo ""
                read -rp "Enter $colname: " updateColValue;
            done
        elif [[ $colDataType == "string" ]]; then
            while ! [[ $updateColValue =~ ^[a-zA-Z]+$ ]]; do
                echo "$colname must be a string.";
                echo ""
                read -rp "Enter $colname: " updateColValue;
            done
        fi

        # validate if PK
        if [[ $colPK == "yes" ]]; then
            # get all column data from tableData
            read -d '' -r -a dataLines < "$tableData"  # all table
            
            #loop over column data to check pk if unique
            for j in "${!dataLines[@]}";
            do
                IFS=':' read -r -a record <<< "${dataLines[$j]}"; # record(row)
                while [[ ${record[$((updateColIndex-1))]} == $updateColValue ]]; do
                    echo "$colname is a primary key and must be unique.";
                    echo ""
                    read -rp "Enter $colname: " updateColValue;
                    validateValue;
                done
            done
        fi
    }

    #read new column value from user
    read -rp "Enter $colname: " updateColValue;
    validateValue;

    break 2;
  done
done

clear -x;
echo "------------ UPDATE $tableName set $colname = $updateColValue where $queryColumnName = $value ------------";
echo "$(awk -v i="$colIndex" -v ui="$updateColIndex" -v v=$value -v nv=$updateColValue -F':' 'BEGIN{OFS=FS}{if ($i == v) $ui=nv; print $0;}' $tableData)" 1> $tableData
echo "------------ is run successfully ------------";
bash stlog.sh updateByColumn "" root owner
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
