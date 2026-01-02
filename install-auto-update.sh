#!/bin/bash
# Install the auto-update system for config.yml
# Run this script once to set up automatic updates

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPDATE_SCRIPT="$SCRIPT_DIR/update-config.sh"

echo "Installing config.yml auto-update system..."

# Make the update script executable
chmod +x "$UPDATE_SCRIPT"

# Create a cron job that runs every 5 minutes
CRON_JOB="*/5 * * * * $UPDATE_SCRIPT >> /var/log/minecraft-config-update.log 2>&1"

# Check if the cron job already exists
if crontab -l 2>/dev/null | grep -q "update-config.sh"; then
    echo "Cron job already exists"
else
    # Add the cron job
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "Cron job added - will check for updates every 5 minutes"
fi

# Create log file if it doesn't exist
sudo touch /var/log/minecraft-config-update.log
sudo chmod 644 /var/log/minecraft-config-update.log

echo "Installation complete!"
echo ""
echo "The system will now check for config.yml updates every 5 minutes."
echo "View logs with: tail -f /var/log/minecraft-config-update.log"
echo ""
echo "To manually trigger an update: $UPDATE_SCRIPT"
echo "To uninstall: crontab -e (then remove the update-config.sh line)"
