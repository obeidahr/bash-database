#!/bin/bash

BACKUP_DIR="/bash-database/opts/backups"
DATABASE_DIR="/bash-database/Databases"
DATE_FORMAT="+%Y%m%d"

# Check if the user running the script is the owner or admin
if [ "$(id -u)" != "0" ]; then
    echo "Only owners and admins can perform backup and restore operations."
    exit 1
fi

echo "Select backup option:"
echo "1. Backup all databases"
echo "2. Backup databases updated on a specific date"
read -p "Enter the option (1 or 2): " option

if [ "$option" == "1" ]; then
    # Create the backup directory
    mkdir -p "$BACKUP_DIR"

    read -p "Enter compression mode (zip, tar, or gzip): " compression_mode

    # Prompt for the date to filter databases
    read -p "Enter the date (YYYYMMDD) to filter databases: " specific_date
    backup_dir="$BACKUP_DIR/databases_updated_on_$specific_date"

    # Create the backup directory
    mkdir -p "$backup_dir"

    # Backup databases updated on the specific date
    case "$compression_mode" in
        zip)
            find "$DATABASE_DIR" -type f -newermt "$specific_date" ! -newermt "$specific_date + 1 day" -exec zip "$backup_dir/databases.zip" {} +
            ;;
        tar)
            find "$DATABASE_DIR" -type f -newermt "$specific_date" ! -newermt "$specific_date + 1 day" -exec tar -czvf "$backup_dir/databases.tar.gz" {} +
            ;;
        gzip)
            find "$DATABASE_DIR" -type f -newermt "$specific_date" ! -newermt "$specific_date + 1 day" -exec tar -czvf "$backup_dir/databases.tar.gz" {} +
            ;;
        *)
            echo "Invalid compression mode."
            exit 1
            ;;
    esac

    echo "Backup of databases updated on $specific_date completed."
elif [ "$option" == "2" ]; then
    echo "Invalid option."
    exit 1
else
    echo "Invalid option."
    exit 1
fi
