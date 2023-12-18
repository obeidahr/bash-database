#!/bin/bash

clear -x;
DBsDir="./Databases"
if [ -d "$DBsDir" ] && [ "$(ls -A $DBsDir)" ]; then
   echo "Available Databases"
  ls -l $DBsDir | grep [d,-]rwx
#  find $DBsDir -readable -exec ls {} \;
  echo ""
else 
    echo "No Databases to show"
    echo ""
fi
