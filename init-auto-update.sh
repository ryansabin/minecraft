#!/bin/bash
# Docker container init script to set up auto-update system
# This script runs inside the container on startup

set -e

echo "[init-auto-update] Setting up auto-update system..."

# Configuration
GITHUB_REPO="https://raw.githubusercontent.com/ryansabin/minecraft/main"
UPDATE_SCRIPT="/usr/local/bin/update-geyser.sh"
CRON_FILE="/etc/cron.d/geyser-auto-update"

# Download the update script
echo "[init-auto-update] Downloading update script..."
curl -fsSL "$GITHUB_REPO/update-geyser.sh" -o "$UPDATE_SCRIPT"
chmod +x "$UPDATE_SCRIPT"

# Set up cron job (runs every 5 minutes)
echo "[init-auto-update] Setting up cron job..."
cat > "$CRON_FILE" <<EOF
# Auto-update Geyser config.yml and extensions every 5 minutes
*/5 * * * * root $UPDATE_SCRIPT >> /data/logs/auto-update.log 2>&1
EOF

chmod 0644 "$CRON_FILE"

# Ensure cron is installed and running
if ! command -v cron &> /dev/null; then
    echo "[init-auto-update] Installing cron..."
    apt-get update -qq && apt-get install -y -qq cron > /dev/null
fi

# Start cron if not running
if ! pgrep -x "cron" > /dev/null; then
    echo "[init-auto-update] Starting cron daemon..."
    cron
fi

# Create log directory
mkdir -p /data/logs

# Run update script once immediately to install everything
echo "[init-auto-update] Running initial update..."
$UPDATE_SCRIPT

echo "[init-auto-update] Auto-update system ready!"
