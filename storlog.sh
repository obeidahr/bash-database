#!/bin/bash

LOG_FILE="/bash-database/log.out"
DATE_FORMAT="+%a %b %d %T %Z %Y"

# Check if the user running the script is the owner or admin
if [ "$(id -u)" != "0" ]; then
    echo "Only owners and admins can perform backup and restore operations."
    exit 1
fi

# Function to write log events
write_log() {
    local event=$1
    local database=$2
    local user=$3
    local user_type=$4
    local date=$(date "$DATE_FORMAT")

    echo "$event:$database $user:$user_type $date" >> "$LOG_FILE"
    echo "Event logged: $event:$database $user:$user_type"
}

#echo "Select database event:"
#echo "1. Insert"
#echo "2. Update"
#echo "3. Delete"
#echo "4. Retrieve"
#read -p "Enter the event option (1-4): " event_option

case "$event_option" in
    1)
        event="insert"
        ;;
    2)
        event="update"
        ;;
    3)
        event="delete"
        ;;
    4)
        event="retrieve"
        ;;
    *)
        echo "Invalid event option."
        exit 1
        ;;
esac

read -p " " event
read -p "Enter the name of the database: " database
read -p "Enter the username: " user
read -p "Enter the user type (admin, owner, other): " user_type

# Log the event
write_log "$event" "$database" "$user" "$user_type"
