#!/bin/bash

# for debugging
# currDB="Databases/iti"
# tableName="emp";

tableData="$currDB/$tableName.idb"
tableFormat="$currDB/.$tableName.frm"

columns=();
dataTypes=();

# get column names and dataTypes
read -d '\n' -r -a lines < "$tableFormat"
for i in "${!lines[@]}" # each line of the format table
do
  IFS=':' read -r -a column <<< "${lines[i]}"; # get parts of that particular line

  name=${column[0]};
  dataType=${column[1]};

  columns+=($name)
  dataTypes+=($dataType);
done

clear -x;
echo "---------------------------------------------";
echo "------Columns in the $tableName table--------";

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

        clear -x;
        echo "-------------";
        echo "Column: $column, Data Type: $colDataType"

        operator="";
        operatorOptions=("==" "<" ">" "<=" ">=");

        while [ true ]; do
            select option in "${operatorOptions[@]}"
            do
            	if ! [[ "\?" =~ "${option}" ]]; then # valid option
            	    operator=$option;
            	    break 2;
            	else 	# # not a valid option
            		echo "You need to choose one of the options";
            	fi
            done
        done

        clear -x;
        echo "-------$colname $operator ------";

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
    done
done

    clear -x;
	echo "-----------query Results----------"; # display the rows that have the queried value
	if [[ $operator = "==" ]]; then
        echo "------------ $colname $operator $value ------------";
        awk -v i="$colIndex" -v v=$value -F':' '{if ($i == v) print $0;}' $tableData;
    elif [[ $operator = "<" ]]; then
    	echo "------------ $colname $operator $value ------------";
    	awk -v i="$colIndex" -v v=$value -F':' '{if ($i < v) print $0;}' $tableData;
    elif [[ $operator = ">" ]]; then
    	echo "------------ $colname $operator $value ------------";
    	awk -v i="$colIndex" -v v=$value -F':' '{if ($i > v) print $0;}' $tableData;
    elif [[ $operator = "<=" ]]; then
    	echo "------------ $colname $operator $value ------------";
    	awk -v i="$colIndex" -v v=$value -F':' '{if ($i <= v) print $0;}' $tableData;
    elif [[ $operator = ">=" ]]; then
    	echo "------------ $colname $operator $value ------------";
    	awk -v i="$colIndex" -v v=$value -F':' '{if ($i >= v) print $0;}' $tableData;
    fi


echo "";
echo "";
echo "------------------------";
options=("Make Another Query" "Return To The Select Menu" "Return To The Table Menu");

select option in "${options[@]}"
do
    case $option in
        "Make Another Query") bash selectByColumn.sh;;
        "Return To The Select Menu") bash select.sh;;
        "Return To The Table Menu") bash tableMenu.sh;;
        *) echo "Invalid option $REPLY";;
    esac
done
