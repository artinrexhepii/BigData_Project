#!/bin/bash

# Get the absolute path to the project directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$PROJECT_DIR/.." && pwd)"
VENV_DIR="$REPO_ROOT/venv"
SCRIPT_PATH="$SCRIPT_DIR/../scripts/dwh_mondial.py"
LOGS_DIR="$PROJECT_DIR/logs"

# Create logs directory if it doesn't exist
mkdir -p "$LOGS_DIR"

# Ensure the script is executable
chmod +x "$SCRIPT_PATH"

# If virtual environment doesn't exist, create it
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    cd "$REPO_ROOT" && python3 -m venv venv
    source "$VENV_DIR/bin/activate"
    pip install -r "$PROJECT_DIR/Data-Warehouse/requirements.txt"
    deactivate
fi

# Path to virtual environment activate script
VENV_ACTIVATE="$VENV_DIR/bin/activate"

# Create a temporary file for the new crontab
TEMP_CRONTAB=$(mktemp)

# Check if there's an existing crontab
crontab -l > "$TEMP_CRONTAB" 2>/dev/null

# Remove any existing jobs for this script to avoid duplication
grep -v "dwh_mondial.py" "$TEMP_CRONTAB" > "${TEMP_CRONTAB}.new"
mv "${TEMP_CRONTAB}.new" "$TEMP_CRONTAB"

# Add the new cron job to run every 5 minutes
echo "*/5 * * * * source $VENV_ACTIVATE && python $SCRIPT_PATH >> $LOGS_DIR/etl_cron.log 2>&1" >> "$TEMP_CRONTAB"

# Install the new crontab
crontab "$TEMP_CRONTAB"
echo "Cron job installed successfully. ETL will run every 5 minutes."
echo "Output will be logged to $LOGS_DIR/etl_cron.log"

# Clean up
rm "$TEMP_CRONTAB"

# Print current crontab for verification
echo "Current cron jobs:"
crontab -l