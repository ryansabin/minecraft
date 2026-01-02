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

Configure via environment variables in `docker-compose.yml`. Key settings:

- `MEMORY` - RAM allocation (e.g., `"4G"`)
- `VERSION` - Minecraft version
- `GAMEMODE` - survival, creative, adventure, spectator
- `DIFFICULTY` - peaceful, easy, normal, hard
- `MAX_PLAYERS` - Player limit
- `MOTD` - Server description
- `NETWORK_COMPRESSION_THRESHOLD` - Set to `512` if you see packet errors
- `GEYSER_BEDROCK_COMPRESSION_LEVEL` - Set to `6` for better Bedrock/PS performance
- `SNOOPER_ENABLED` - Set to `"false"` to disable telemetry

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

### Packet compression errors
Add to `docker-compose.yml`:
```yaml
NETWORK_COMPRESSION_THRESHOLD: "512"
```

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
