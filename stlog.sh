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
   # echo "Event logged: $event:$database $user:$user_type"
}

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <event> <database> <user> <user_type>"
    exit 1
fi

event=$1
database=$2
user=$3
user_type=$4

# Log the event
write_log "$event" "$database" "$user" "$user_type"
