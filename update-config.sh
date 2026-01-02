#!/bin/bash
# Auto-update Geyser config.yml from GitHub
# This script checks if config.yml has changed in the GitHub repo and updates the server if needed

set -e

CONFIG_URL="https://raw.githubusercontent.com/ryansabin/minecraft/main/config.yml"
CONFIG_PATH="/minecraft/plugins/Geyser-Spigot/config.yml"
TEMP_CONFIG="/tmp/config.yml.new"
CONTAINER_NAME="minecraft"

echo "[$(date)] Checking for config.yml updates..."

# Download the latest config.yml from GitHub
if ! curl -fsSL "$CONFIG_URL" -o "$TEMP_CONFIG"; then
    echo "[$(date)] ERROR: Failed to download config.yml from GitHub"
    exit 1
fi

# Check if the config file exists on the server
if [ ! -f "$CONFIG_PATH" ]; then
    echo "[$(date)] Config file doesn't exist yet, copying..."
    sudo cp "$TEMP_CONFIG" "$CONFIG_PATH"
    sudo chown 1000:1000 "$CONFIG_PATH"
    echo "[$(date)] Config file created"
    rm -f "$TEMP_CONFIG"
    exit 0
fi

# Compare the files
if ! sudo cmp -s "$TEMP_CONFIG" "$CONFIG_PATH"; then
    echo "[$(date)] Config.yml has changed, updating..."

    # Backup the old config
    sudo cp "$CONFIG_PATH" "$CONFIG_PATH.backup.$(date +%Y%m%d-%H%M%S)"

    # Update the config
    sudo cp "$TEMP_CONFIG" "$CONFIG_PATH"
    sudo chown 1000:1000 "$CONFIG_PATH"

    # Restart the container
    echo "[$(date)] Restarting Minecraft server..."
    docker restart "$CONTAINER_NAME"

    echo "[$(date)] Server restarted with new config"
else
    echo "[$(date)] No changes detected"
fi

# Cleanup
rm -f "$TEMP_CONFIG"
