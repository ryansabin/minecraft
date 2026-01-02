# Minecraft Server with Geyser (Bedrock Support)

Paper server with cross-play support for Bedrock Edition players.

## Features

- Paper 1.21.11 with 4GB RAM
- Cross-play support (Java + Bedrock)
- Plugins: Geyser, Floodgate, Hurricane, ViaVersion

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

### 3. Install Geyser Extensions
Wait 2-3 minutes, then:
```bash
sudo mkdir -p /minecraft/plugins/Geyser-Spigot/extensions
sudo wget -O /minecraft/plugins/Geyser-Spigot/extensions/EmoteOffhand.jar https://download.geysermc.org/v2/projects/emoteoffhand/versions/latest/builds/latest/downloads/emoteoffhand
sudo wget -O /minecraft/plugins/Geyser-Spigot/extensions/ThirdPartyCosmetics.jar https://download.geysermc.org/v2/projects/thirdpartycosmetics/versions/latest/builds/latest/downloads/thirdpartycosmetics
sudo wget -O /minecraft/plugins/Geyser-Spigot/extensions/MCXboxBroadcastExtension.jar https://github.com/MCXboxBroadcast/Broadcaster/releases/download/118/MCXboxBroadcastExtension.jar
sudo wget -O /minecraft/plugins/Geyser-Spigot/config.yml https://raw.githubusercontent.com/ryansabin/minecraft/main/config.yml
docker restart minecraft
```

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

### Performance Optimizations
- `NETWORK_COMPRESSION_THRESHOLD: "-1"` - Compression disabled (no CPU overhead, uses more bandwidth)
- `GEYSER_BEDROCK_COMPRESSION_LEVEL: "3"` - Low compression for Bedrock (less CPU, more bandwidth)
- `VIEW_DISTANCE: "8"` - Reduced from default 10 (significant CPU/memory savings)
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

## Troubleshooting

### Server won't start
Check logs: `docker logs minecraft`. Verify ports 25565 and 19132 are available.

### Bedrock players can't connect
- Open port 19132/UDP in firewall
- Check Geyser loaded in logs
- Try direct IP connection (not Friends list)

### PlayStation connection issues
Set in `docker-compose.yml`:
```yaml
GEYSER_BEDROCK_COMPRESSION_LEVEL: "6"
SNOOPER_ENABLED: "false"
```
PlayStation may need MTU set to 1473 in network settings. See [PLAYSTATION-FIX.md](PLAYSTATION-FIX.md) for details.

### MCXboxBroadcast connection warnings
These warnings don't break gameplay. Players can still connect via direct IP. To disable warnings:
```bash
# Edit config to disable broadcasting
sudo nano /minecraft/plugins/Geyser-Spigot/extensions/MCXboxBroadcastExtension/config.yml
# Set enabled: false
docker restart minecraft
```

### Performance issues
Increase `MEMORY` in docker-compose.yml or reduce `VIEW_DISTANCE`.

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
