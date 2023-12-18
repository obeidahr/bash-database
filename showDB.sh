#!/bin/bash

clear -x;
DBsDir="./Databases"
if [ -d "$DBsDir" ] && [ "$(ls -A $DBsDir)" ]; then
   echo "Available Databases:"
  ls $DBsDir
  echo ""
  bash DBMenu.sh
else 
    echo "No Databases to show-_-"
    echo ""
    bash DBMenu.sh
fi
