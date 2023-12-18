#!/bin/bash

# currDB="Databases/iti"
clear -x;
echo "------------ SHOW TABLES ------------";

DIR="./$currDB"
if [ -d "$DIR" ] && [ "$(ls -A $DIR)" ]; then
   echo "Available tables"
  ls $DIR | awk 'BEGIN{FS="."}{ print $1 }'
  echo ""
  bash tablesMenu.sh
else
    echo "No tables to show"
    echo ""
    bash tablesMenu.sh
fi
