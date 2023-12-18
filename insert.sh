#!/bin/bash

# for debugging
# currDB="Databases/iti"
# tableName="emp";

tableData="$currDB/$tableName.idb"
tableFormat="$currDB/.$tableName.frm"

newRecord="";

# read columns info from tableName.metadata into array
read -d '\n' -r -a lines < "$tableFormat"

for i in "${!lines[@]}" # indices of the array 0,1,2
do
    # read column attributs
    IFS=':' read -r -a column <<< "${lines[i]}";
    name=${column[0]};
    dataType=${column[1]};
    PK=${column[2]};

    function validateValue(){
        # validate the new value type
        if [[ $dataType == "number" ]]; then
            while ! [[ $value =~ ^[0-9]+$ ]]; do
                echo "$name must be a number.";
                echo ""
                read -rp "Enter $name: " value;
            done
        elif [[ $dataType == "string" ]]; then
            while ! [[ $value =~ ^[a-zA-Z]+$ ]]; do
                echo "$name must be a string.";
                echo ""
                read -rp "Enter $name: " value;
            done
        fi

        # validate if PK
        if [[ $PK == "yes" ]]; then
            # get all column data from tableData
            read -d '' -r -a dataLines < "$tableData"  # all table
            
            #loop over column data to check pk if unique
            for j in "${!dataLines[@]}";
            do
                IFS=':' read -r -a record <<< "${dataLines[$j]}"; # record(row)
                while [[ ${record[i]} == $value ]]; do
                    echo "$name is a primary key and must be unique.";
                    echo ""
                    read -rp "Enter $name: " value;
                    validateValue;
                done
            done
        fi
    }

    #read new column value from user
    read -rp "Enter $name: " value;
    validateValue;
    
    if [[ $i == 0 ]]; then
        newRecord=$value;
    else
        newRecord+=":$value";
    fi
done

if ! [[ $newRecord == "" ]]; then
    if echo $newRecord >> "$tableData"; then
        clear -x;
        echo "Record stored succesfully.";
  	bash stlog.sh insert $newRecord root owner
    else
        echo "ERROR: Failed to store record.";
    fi
else
    echo "ERROR: Record is empty.";
fi

echo ""
bash tableMenu.sh
