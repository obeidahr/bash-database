#!/bin/bash

#echo "available databases:"
#ls /bash-database/Databases

#read -p "Enter the name of the Database to backup: " dbname

#if [[ ! -d "/bash-database/Databases/$dbname" ]]; then
#	echo "Database $dbname does not exist."
#	exit 1
#fi
BACKUP_DIR="/bash-database/opts/backups"
DATABASE_DIR="/bash-database/Databases"
DATE_FORMAT="+%Y%m%d"

echo "Select backup option:"
echo "1. Backup all databases"
echo "2. Backup databases updated on a specific date"
read -p "Enter the option (1 or 2): " option

#bachup_dir= "/bash-database/opt/backups/backup_$(date +%Y%m%d_%H%M%S)"

if [ "$option" == "1" ]; then 
        #mkdir -p "/bash-database/opts/backups/backup_$(date +%Y%m%d_%H%M%S)"
        #cp -r /bash-database/Databases "/bash-database/opts/backups/backup_$(date +%Y%m%d_%H%M%S)"
        # Backup all databases using the selected compression mode
    read -p "Enter compression mode (zip, tar, or gzip): " compression_mode
    case "$compression_mode" in
        zip)
            zip -r "$BACKUP_DIR/backup_$(date "$DATE_FORMAT")" "$DATABASE_DIR"
            ;;
        tar)
            tar -czvf "$BACKUP_DIR/backup_$(date "$DATE_FORMAT").tar.gz" "$DATABASE_DIR"
            ;;
        gzip)
            tar -czvf "$BACKUP_DIR/backup_$(date "$DATE_FORMAT").tar.gz" "$DATABASE_DIR"
            ;;
        *)
            echo "Invalid compression mode."
            exit 1
            ;;
    esac

    echo "Backup of all databases completed successfully."
	#echo "Backup of all databases completed successfully."
elif [ "$option" == "2" ]; then
        read -p "Enter the date (YYYYMMDD) to filter databases: " specific_date
        find /bash-database/Databases -type d -newermt "$specific_date" -exec cp -r {} "$backup_dir" \;
        echo "Backup of databases updated on $specific_date completed"
else
        echo "Invalid option."
        exit 1
fi
