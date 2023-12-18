#!/bin/bash

LOG_DIR="/bash-database/log"
LOG_PREFIX=""
DAYS_TO_KEEP=10

# Calculate the date of the log files to keep
DATE_TO_KEEP=$(date -d "$DAYS_TO_KEEP days ago" +%Y%m%d)

# Iterate over the log files in the directory
for log_file in "$LOG_DIR"*
do
    # Extract the date part from the log file name
    file_date=$(basename "$log_file" | cut -d "_" -f 3)

    # Compare the log file date with the date to keep
    if [[ $file_date -lt $DATE_TO_KEEP ]]; then
        # Remove log files older than the specified date
        rm "$log_file"
        echo "Deleted log file: $log_file"
    fi
done
