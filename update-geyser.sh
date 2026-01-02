#!/bin/bash
# Auto-update Geyser config.yml and extensions from GitHub
# This script runs inside the Docker container

set -e

# Configuration
GITHUB_REPO="https://raw.githubusercontent.com/ryansabin/minecraft/main"
CONFIG_URL="$GITHUB_REPO/config.yml"
EXTENSIONS_LIST_URL="$GITHUB_REPO/geyser-extensions.txt"
CONFIG_PATH="/data/plugins/Geyser-Spigot/config.yml"
EXTENSIONS_DIR="/data/plugins/Geyser-Spigot/extensions"
TEMP_CONFIG="/tmp/config.yml.new"
TEMP_EXTENSIONS_LIST="/tmp/geyser-extensions.txt"
NEEDS_RESTART=false

echo "[$(date)] Checking for updates..."

# Create extensions directory if it doesn't exist
mkdir -p "$EXTENSIONS_DIR"

# ============================================
# Check config.yml updates
# ============================================
echo "[$(date)] Checking config.yml..."

if ! curl -fsSL "$CONFIG_URL" -o "$TEMP_CONFIG"; then
    echo "[$(date)] WARNING: Failed to download config.yml from GitHub"
else
    if [ ! -f "$CONFIG_PATH" ]; then
        echo "[$(date)] Config file doesn't exist, creating..."
        cp "$TEMP_CONFIG" "$CONFIG_PATH"
        NEEDS_RESTART=true
    elif ! cmp -s "$TEMP_CONFIG" "$CONFIG_PATH"; then
        echo "[$(date)] Config.yml has changed, updating..."
        cp "$CONFIG_PATH" "$CONFIG_PATH.backup.$(date +%Y%m%d-%H%M%S)"
        cp "$TEMP_CONFIG" "$CONFIG_PATH"
        NEEDS_RESTART=true
    else
        echo "[$(date)] Config.yml is up to date"
    fi
fi

# ============================================
# Check Geyser extensions updates
# ============================================
echo "[$(date)] Checking Geyser extensions..."

if ! curl -fsSL "$EXTENSIONS_LIST_URL" -o "$TEMP_EXTENSIONS_LIST"; then
    echo "[$(date)] WARNING: Failed to download extensions list from GitHub"
else
    # Parse and download each extension
    while IFS='|' read -r url filename || [ -n "$url" ]; do
        # Skip empty lines and comments
        [[ -z "$url" || "$url" =~ ^[[:space:]]*# ]] && continue

        # Trim whitespace
        url=$(echo "$url" | xargs)
        filename=$(echo "$filename" | xargs)

        extension_path="$EXTENSIONS_DIR/$filename"
        temp_extension="/tmp/$filename"

        echo "[$(date)] Processing $filename..."

        if curl -fsSL "$url" -o "$temp_extension"; then
            # Check if extension exists and is different
            if [ ! -f "$extension_path" ]; then
                echo "[$(date)] New extension: $filename"
                mv "$temp_extension" "$extension_path"
                NEEDS_RESTART=true
            elif ! cmp -s "$temp_extension" "$extension_path"; then
                echo "[$(date)] Extension updated: $filename"
                cp "$extension_path" "$extension_path.backup.$(date +%Y%m%d-%H%M%S)"
                mv "$temp_extension" "$extension_path"
                NEEDS_RESTART=true
            else
                echo "[$(date)] Extension up to date: $filename"
                rm -f "$temp_extension"
            fi
        else
            echo "[$(date)] WARNING: Failed to download $filename from $url"
            rm -f "$temp_extension"
        fi
    done < "$TEMP_EXTENSIONS_LIST"
fi

# ============================================
# Restart if needed
# ============================================
if [ "$NEEDS_RESTART" = true ]; then
    echo "[$(date)] Changes detected - restart required"
    echo "[$(date)] NOTE: Container will auto-restart on config changes via Docker watch or manual restart"
    # Don't restart from inside the container - let Docker handle it
    # This prevents infinite restart loops
else
    echo "[$(date)] No changes detected"
fi

# Cleanup
rm -f "$TEMP_CONFIG" "$TEMP_EXTENSIONS_LIST"
