# Minecraft Server with Geyser (Bedrock Support)

Paper server with cross-play support for Bedrock Edition players.

## Features

- Paper 1.21.11 with 4GB RAM
- Cross-play support (Java + Bedrock)
- Distant Horizons support (VIEW_DISTANCE: 32)
- Plugins: Geyser, Floodgate, Hurricane, ViaVersion, Chunky

## Prerequisites

- Docker and Docker Compose
- 4GB RAM
- Ports 25565 (Java) and 19132 (Bedrock)

## Setup

### 1. Create Directory
```bash
sudo mkdir -p /minecraft && sudo chmod 755 /minecraft
```

### 2. Start Server
```bash
docker-compose up -d
```

### 3. Auto-Update System
The auto-update system is automatically configured when the container starts. No manual setup required!

### 4. Authorize MCXboxBroadcast
1. Check logs for auth code: `docker logs -f minecraft`
2. Visit https://microsoft.com/link and enter the code
3. Sign in with a Microsoft account (use a dedicated account, not personal)
4. Set Xbox privacy to allow multiplayer and activity visibility to "Everyone"

## Connecting

- **Java Edition**: `your-server-ip:25565`
- **Bedrock Edition**: `your-server-ip:19132`

## Configuration

This server is optimized for best gameplay performance with minimal CPU overhead. Key settings in `docker-compose.yml`:

### Basic Settings
- `MEMORY: "4G"` - RAM allocation
- `VERSION: "1.21.11"` - Minecraft version
- `USE_AIKAR_FLAGS: "true"` - Performance-optimized JVM flags

### Distant Horizons Support
- `VIEW_DISTANCE: "32"` - Extended render distance for Distant Horizons client mod
- **Chunky plugin** - Pre-generates chunks for faster LOD loading
- Players need to install Distant Horizons mod on their client: https://modrinth.com/mod/distanthorizons

### Performance Optimizations
- `NETWORK_COMPRESSION_THRESHOLD: "-1"` - Compression disabled (no CPU overhead, uses more bandwidth)
- `GEYSER_BEDROCK_COMPRESSION_LEVEL: "3"` - Low compression for Bedrock (less CPU, more bandwidth)
- `SIMULATION_DISTANCE: "6"` - Reduced from default 10 (major CPU reduction for entities/mobs)
- `SYNC_CHUNK_WRITES: "false"` - Async chunk writing (reduces I/O lag spikes)
- `MAX_TICK_TIME: "120000"` - Prevents watchdog crashes during lag spikes
- `SPAWN_PROTECTION: "0"` - Disables spawn protection checks (minor CPU savings)
- `ENABLE_ROLLING_LOGS: "false"` - Reduces log I/O overhead
- `SNOOPER_ENABLED: "false"` - Disables telemetry (better performance and privacy)

### Geyser Configuration (config.yml)
The optimized Geyser config includes:
- **Timeouts increased to 120s** - Better stability for console players
- **Skin caching enabled (7 days)** - Reduces network calls
- **Compression level: 3** - Low CPU overhead
- **MTU: 1492** - Maximum MTU for less packet fragmentation
- **Java compression disabled** - No Java→Geyser compression overhead

Full config reference: https://github.com/itzg/docker-minecraft-server

## Commands

```bash
docker-compose up -d              # Start
docker-compose down               # Stop
docker restart minecraft          # Restart
docker logs -f minecraft          # View logs
docker exec -i minecraft rcon-cli # Execute commands
```

## Auto-Update System

The server includes an automatic update system that runs **inside the Docker container**. It checks for config.yml and Geyser extension changes from GitHub every 5 minutes.

### How It Works
- **Automatic setup**: The `init-auto-update.sh` script runs automatically when the container starts
- **Cron job**: Runs every 5 minutes inside the container to check for updates
- **Downloads from GitHub**: Pulls scripts and configs directly from the repository
- **No local files needed**: Everything is fetched from GitHub
- **Auto-reinitializes**: When Portainer redeploys the container (after GitHub changes), the init script runs again automatically

### Features
- Checks GitHub for updates every 5 minutes
- Updates `config.yml` automatically
- Updates Geyser extensions from `geyser-extensions.txt`
- Automatically backs up old files before updating
- Logs all updates to `/data/logs/auto-update.log`

### Managing Extensions
Edit `geyser-extensions.txt` in the GitHub repo to add/remove extensions:
```
# Format: URL|filename
https://download.geysermc.org/v2/projects/emoteoffhand/versions/latest/builds/latest/downloads/emoteoffhand|EmoteOffhand.jar
```

Push changes to GitHub and the container will auto-update within 5 minutes.

### Viewing Logs
```bash
docker exec minecraft tail -f /data/logs/auto-update.log   # View update logs
docker exec minecraft cat /usr/local/bin/update-geyser.sh  # View update script
```

## Troubleshooting

### Server won't start
Check logs: `docker logs minecraft`. Verify ports 25565 and 19132 are available.

### Bedrock players can't connect
- Open port 19132/UDP in firewall
- Check Geyser loaded in logs
- Try direct IP connection (not Friends list)

## Updating

```bash
docker-compose pull           # Update image
docker-compose down && docker-compose up -d  # Restart with new version
```

Change `VERSION` in docker-compose.yml to update Minecraft version.

## Resources

- [itzg/minecraft-server](https://github.com/itzg/docker-minecraft-server)
- [GeyserMC](https://geysermc.org/)
- [Paper](https://papermc.io/)
