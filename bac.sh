#!/bin/bash

BACKUP_DIR="/bash-database/opts/backups"
DATABASE_DIR="/bash-database/Databases"
DATE_FORMAT="+%Y%m%d"
MAX_BACKUP_COUNT=10
MAX_BACKUP_SIZE_MB=1

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

    # Prompt for scheduling option
    echo "Select scheduling option:"
    echo "1. Daily"
    echo "2. Weekly"
    echo "3. Monthly"
    read -p "Enter the scheduling option (1, 2, or 3): " scheduling_option

    case "$scheduling_option" in
        1)
            backup_dir="$BACKUP_DIR/daily/backup_$(date "$DATE_FORMAT")"
            ;;
        2)
            backup_dir="$BACKUP_DIR/weekly/backup_$(date "$DATE_FORMAT")"
            ;;
        3)
            backup_dir="$BACKUP_DIR/monthly/backup_$(date "$DATE_FORMAT")"
            ;;
        *)
            echo "Invalid scheduling option."
            exit 1
            ;;
    esac

    # Create the backup directory
    mkdir -p "$backup_dir"

    # Backup all databases using the selected compression mode
    case "$compression_mode" in
        zip)
            zip -r "$backup_dir/databases.zip" "$DATABASE_DIR"
            ;;
        tar)
            tar -czvf "$backup_dir/databases.tar.gz" "$DATABASE_DIR"
            ;;
        gzip)
            tar -czvf "$backup_dir/databases.tar.gz" "$DATABASE_DIR"
            ;;
        *)
            echo "Invalid compression mode."
            exit 1
            ;;
    esac

    echo "Backup of all databases completed successfully."
    bash stlog.sh backup "" root owner
elif [ "$option" == "2" ]; then
    # Check if the user is an owner or admin
    if [ "$(id -u)" != "0" ]; then
        echo "Only owners and admins can perform backup and restore operations."
        exit 1
    fi

    read -p "Enter the date (YYYYMMDD) to filter databases: " specific_date
    backup_dir="$BACKUP_DIR/databases_updated_on_$specific_date"

    # Create the backup directory
    mkdir -p "$backup_dir"

    read -p "Enter compression mode (zip, tar, or gzip): " compression_mode

    # Backup databases updated on the specific date
    case "$compression_mode" in
        zip)
            find "$DATABASE_DIR" -type d -newermt "$specific_date" -exec zip -r "$backup_dir/{}.zip" {} \;
            ;;
        tar)
            find "$DATABASE_DIR" -type d -newermt "$specific_date" -exec tar -czvf "$backup_dir/{}.tar.gz" {} \;
            ;;
        gzip)
            find "$DATABASE_DIR" -type d -newermt "$specific_date" -exec tar -czvf "$backup_dir/{}.tar.gz" {} \;
            ;;
        *)
            echo "Invalid compression mode."
            exit 1
            ;;
    esac

    echo "Backup of databases updated on $specific_date completed."
# Perform rotation based on backup date
    find "$BACKUP_DIR" -maxdepth 1 -type d -name "databases_updated_on_*" | sort -r | tail -n +$((MAX_BACKUP_COUNT + 1)) | xargs rm -rf

    # Perform rotation based on backup size
    total_size=0
    while IFS= read -rd '' file; do
        size=$(du -s -m "$file" | awk '{print $1}')
        total_size=$((total_size + size))
    done < <(find "$BACKUP_DIR" -maxdepth 1 -type d -name "databases_updated_on_*" -print0)

    while [ $total_size -gt $MAX_BACKUP_SIZE_MB ]; do
        oldest_backup=$(find "$BACKUP_DIR" -maxdepth 1 -type d -name "databases_updated_on_*" -printf '%T@ %p\n' | sort -n | head -n 1 | cut -d ' ' -f 2-)
        rm -rf "$oldest_backup"
        total_size=$((total_size - $(du -s -m "$oldest_backup" | awk '{print $1}')))
    done
else
    echo "Invalid option."
    exit 1
fi
