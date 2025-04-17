#!/bin/bash

# Get the absolute path to the virtual environment and script
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_ACTIVATE="$PROJECT_DIR/venv/bin/activate"
SCRIPT_PATH="$PROJECT_DIR/dwh_mondial.py"

# Ensure the script is executable
chmod +x "$SCRIPT_PATH"

# Create a temporary file for the new crontab
TEMP_CRONTAB=$(mktemp)

# Check if there's an existing crontab
crontab -l > "$TEMP_CRONTAB" 2>/dev/null

# Check if the job is already in crontab to avoid duplicates
if ! grep -q "$SCRIPT_PATH" "$TEMP_CRONTAB"; then
    # Add the new cron job to run every 5 minutes
    echo "*/5 * * * * source $VENV_ACTIVATE && python $SCRIPT_PATH >> $PROJECT_DIR/etl_log.txt 2>&1" >> "$TEMP_CRONTAB"
    
    # Install the new crontab
    crontab "$TEMP_CRONTAB"
    echo "Cron job installed successfully. ETL will run every 5 minutes."
    echo "Output will be logged to $PROJECT_DIR/etl_log.txt"
else
    echo "Cron job already exists. No changes made."
fi

# Clean up
rm "$TEMP_CRONTAB"

# Print current crontab for verification
echo "Current cron jobs:"
crontab -l