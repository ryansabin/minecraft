# Minecraft Server with Geyser (Bedrock Support)

This Docker Compose setup creates a Minecraft Paper server with cross-play support for Bedrock Edition players through Geyser.

## Features

- **Paper Server** (Version 1.21.11)
- **Cross-play support** - Java and Bedrock players can join the same server
- **Optimized performance** with Aikar's flags
- **4GB RAM allocation**
- **Pre-configured plugins**:
  - Geyser (enables Bedrock Edition connections)
  - Floodgate (allows Bedrock players without Java accounts)
  - Hurricane (Geyser performance enhancements)
  - ViaVersion (backward compatibility)

## Prerequisites

- Docker installed on your system
- Docker Compose installed
- At least 4GB of available RAM
- Ports 25565 (Java) and 19132 (Bedrock) available

## Setup Instructions

### 1. Create the Minecraft Directory

```bash
sudo mkdir -p /minecraft
sudo chmod 755 /minecraft
```

### 2. Download the Configuration Files

Place the `docker-compose.yml` file in your working directory.

### 3. Start the Minecraft Server

```bash
docker-compose up -d
```

The server will:
- Accept the Minecraft EULA automatically
- Download and install Paper server
- Install all configured plugins
- Apply environment variables from docker-compose.yml

### 4. Install Geyser Extensions

After the initial server setup completes (wait about 2-3 minutes), install the Geyser extensions:

```bash
# Create extensions directory if it doesn't exist
sudo mkdir -p /minecraft/plugins/Geyser-Spigot/extensions

# Download extensions
sudo wget -O /minecraft/plugins/Geyser-Spigot/extensions/EmoteOffhand.jar https://download.geysermc.org/v2/projects/emoteoffhand/versions/latest/builds/latest/downloads/emoteoffhand

sudo wget -O /minecraft/plugins/Geyser-Spigot/extensions/ThirdPartyCosmetics.jar https://download.geysermc.org/v2/projects/thirdpartycosmetics/versions/latest/builds/latest/downloads/thirdpartycosmetics

sudo wget -O /minecraft/plugins/Geyser-Spigot/extensions/MCXboxBroadcastExtension.jar https://github.com/MCXboxBroadcast/Broadcaster/releases/download/118/MCXboxBroadcastExtension.jar

# Restart the container to load extensions
docker restart minecraft
```

### 5. Authorize MCXboxBroadcast with Microsoft Account

After installing MCXboxBroadcastExtension and restarting the server, you need to link it to a Microsoft account:

1. **Check server logs** for the authentication code:
```bash
docker logs -f minecraft
```

2. Look for a message showing a **code** (usually 6-8 characters)

3. **Visit the authorization link** in your web browser:
   - Go to: **https://www.microsoft.com/link** or **https://microsoft.com/devicelogin**
   - Enter the code exactly as shown in the logs
   - Sign in with your Microsoft account

4. **Complete authorization** and the server will confirm the connection

**Important recommendations:**
- Use a dedicated Microsoft account (not your personal account) for better security and to avoid personal notifications
- Set Xbox privacy settings to allow multiplayer
- Set activity visibility to "Everyone" so friends can discover the session
- The account may need Xbox Game Pass or Minecraft ownership to broadcast sessions

Once authorized, your server will be discoverable on Xbox Live, allowing console players to find and join your server from their friends list.

### 6. Verify Installation

Check server logs:
```bash
docker logs -f minecraft
```

Look for messages indicating successful plugin loading and server startup.

## Connecting to the Server

### Java Edition
- **Server Address**: `your-server-ip:25565`
- **Version**: 1.21.11 or compatible

### Bedrock Edition
- **Server Address**: `your-server-ip`
- **Port**: `19132`
- **Version**: Latest Bedrock version supported by Geyser

## Server Configuration

All server settings can be configured via environment variables in `docker-compose.yml`. Here are the available options:

### Required Settings

- **`EULA`** - Must be set to `"TRUE"` to accept the Minecraft End User License Agreement. Required for the server to start.

### Server Type & Version

- **`TYPE`** - The server type to use. Options: `VANILLA`, `SPIGOT`, `PAPER`, `PURPUR`, `FABRIC`, `FORGE`, `BUKKIT`, `CRAFTBUKKIT`, `SPONGEVANILLA`, `QUILT`, `NEOFORGE`, `LIMBO`, `MAGMA`, `MOHIST`, `CATSERVER`, `MOHIST`, `BUNGEECORD`, `VELOCITY`, `WATERFALL`, `TRAVERTINE`, `GEYSER`, `GEYSERSTANDBY`. Default: `VANILLA`
- **`VERSION`** - The Minecraft version to use (e.g., `"1.21.11"`, `"LATEST"`). Default: `LATEST`

### Memory & Performance

- **`MEMORY`** - Java heap memory allocation (e.g., `"4G"`, `"6G"`, `"8G"`). Format: number followed by G or M.
- **`USE_AIKAR_FLAGS`** - Set to `"true"` to use Aikar's optimized JVM flags for better performance. Recommended for Paper servers.

### World Settings

- **`LEVEL`** - The name of the world folder. Default: `world`
- **`SEED`** - The seed used for world generation. Can be any number or text string.
- **`LEVEL_TYPE`** - World generation type. Options: `DEFAULT`, `FLAT`, `LARGEBIOMES`, `AMPLIFIED`, `CUSTOMIZED`, `BUFFET`, `DEBUG_ALL_BLOCK_STATES`, `NORMAL`. Default: `DEFAULT`
- **`GENERATOR_SETTINGS`** - Custom generator settings for world generation (JSON format).
- **`GENERATE_STRUCTURES`** - Set to `"true"` to generate structures like villages and temples. Default: `true`
- **`MAX_WORLD_SIZE`** - Maximum world size in blocks. Default: `29999984`

### Gameplay Settings

- **`GAMEMODE`** - Default game mode for new players. Options: `survival`, `creative`, `adventure`, `spectator`. Default: `survival`
- **`FORCE_GAMEMODE`** - Set to `"true"` to force players to join in the default game mode. Default: `false`
- **`DIFFICULTY`** - Server difficulty. Options: `peaceful` (0), `easy` (1), `normal` (2), `hard` (3). Default: `easy`
- **`HARDCORE`** - Set to `"true"` to enable hardcore mode (permanent ban on death). Default: `false`
- **`PVP`** - Set to `"true"` to enable player versus player combat. Default: `true`
- **`ALLOW_FLIGHT`** - Set to `"true"` to allow players to fly in survival mode. Default: `false`
- **`ALLOW_NETHER`** - Set to `"true"` to allow players to travel to the Nether. Default: `true`
- **`ENABLE_COMMAND_BLOCK`** - Set to `"true"` to enable command blocks. Default: `false`

### Spawn Settings

- **`SPAWN_PROTECTION`** - Radius of protected area around spawn (0-16). Set to 0 to disable. Default: `16`
- **`SPAWN_MONSTERS`** - Set to `"true"` to allow monster spawning. Default: `true`
- **`SPAWN_ANIMALS`** - Set to `"true"` to allow animal spawning. Default: `true`
- **`SPAWN_NPCS`** - Set to `"true"` to allow NPC (villager) spawning. Default: `true`

### Player Settings

- **`MAX_PLAYERS`** - Maximum number of players that can connect simultaneously. Default: `20`
- **`PLAYER_IDLE_TIMEOUT`** - Minutes before idle players are kicked (0 to disable). Default: `0`
- **`WHITELIST`** - Set to `"true"` to enable whitelist. Default: `false`
- **`ENFORCE_WHITELIST`** - Set to `"true"` to kick players not on the whitelist. Default: `false`
- **`OP_PERMISSION_LEVEL`** - Default permission level for operators (1-4). Default: `4`
- **`FUNCTION_PERMISSION_LEVEL`** - Permission level for function commands (1-4). Default: `2`

### Network Settings

- **`SERVER_PORT`** - Port the server listens on. Default: `25565`
- **`SERVER_IP`** - IP address to bind to (leave empty to bind to all). Default: (empty)
- **`ONLINE_MODE`** - Set to `"true"` to verify players with Mojang authentication. Default: `true`
- **`NETWORK_COMPRESSION_THRESHOLD`** - Packet compression threshold (-1 to disable). Default: `256`
- **`MAX_TICK_TIME`** - Maximum milliseconds per tick before server considers itself crashed. Default: `60000`
- **`PREVENT_PROXY_CONNECTIONS`** - Set to `"true"` to prevent proxy connections. Default: `false`

### Performance Settings

- **`VIEW_DISTANCE`** - Number of chunks sent to players (3-32). Lower values improve performance. Default: `10`
- **`SIMULATION_DISTANCE`** - Chunks with active entities (5-32). Default: `10`
- **`MAX_BUILD_HEIGHT`** - Maximum build height. Default: `256`
- **`RATE_LIMIT`** - Maximum packets per user before kick. Default: `0` (disabled)
- **`USE_NATIVE_TRANSPORT`** - Set to `"true"` to use native transport for better performance. Default: `true`

### RCON & Remote Access

- **`ENABLE_RCON`** - Set to `"true"` to enable RCON remote console access. Default: `false`
- **`RCON_PASSWORD`** - Password for RCON access. Required if `ENABLE_RCON` is true.
- **`RCON_PORT`** - Port for RCON access. Default: `25575`

### Query & Status

- **`ENABLE_QUERY`** - Set to `"true"` to enable GameSpy4 protocol queries. Default: `false`
- **`QUERY_PORT`** - Port for query protocol. Default: `25565`
- **`ENABLE_STATUS`** - Set to `"true"` to allow status queries. Default: `true`

### Resource Packs

- **`RESOURCE_PACK`** - URL to a resource pack for players to download.
- **`RESOURCE_PACK_SHA1`** - SHA-1 hash of the resource pack for validation.
- **`REQUIRE_RESOURCE_PACK`** - Set to `"true"` to require resource pack acceptance. Default: `false`
- **`RESOURCE_PACK_PROMPT`** - Message displayed when prompting for resource pack.

### Server Properties

- **`MOTD`** - Message of the Day displayed in server list. Default: `A Minecraft Server`
- **`OVERRIDE_SERVER_PROPERTIES`** - Set to `"true"` to allow environment variables to override server.properties. Default: `false`
- **`SERVER_NAME`** - Name of the server as it appears in server list.

### Logging & Debugging

- **`LOG_IPS`** - Set to `"true"` to log IP addresses of connecting players. Default: `true`
- **`DEBUG`** - Set to `"true"` to enable debug logging. Default: `false`
- **`SNOOPER_ENABLED`** - Set to `"true"` to send anonymized data to Mojang. Default: `true`

### Advanced Settings

- **`SYNC_CHUNK_WRITES`** - Set to `"true"` to synchronously write chunks to disk. Default: `true`
- **`ENTITY_BROADCAST_RANGE_PERCENTAGE`** - Percentage of default entity tracking range. Default: `100`
- **`BROADCAST_CONSOLE_TO_OPS`** - Set to `"true"` to send console outputs to all operators. Default: `true`
- **`BROADCAST_RCON_TO_OPS`** - Set to `"true"` to send RCON outputs to all operators. Default: `true`
- **`ENFORCE_SECURE_PROFILE`** - Set to `"true"` to enforce secure profiles. Default: `true`
- **`ENABLE_JMX_MONITORING`** - Set to `"true"` to enable JMX monitoring. Default: `false`
- **`BUG_REPORT_LINK`** - URL for the "Report Bug" button in server list.

### Plugins & Mods

- **`PLUGINS`** - Multi-line list of plugin URLs to download automatically. One URL per line.
- **`MODS`** - Multi-line list of mod URLs to download automatically. One URL per line.
- **`REMOVE_OLD_MODS`** - Set to `"true"` to remove old mods before downloading new ones. Default: `false`
- **`REMOVE_OLD_MODS_DEPTH`** - Depth to search for old mods (1-3). Default: `1`

### System Settings

- **`TZ`** - Timezone for the server (e.g., `America/Denver`, `Europe/London`). Default: `UTC`
- **`JVM_OPTS`** - Additional JVM options to pass to the server.
- **`JVM_XX_OPTS`** - Additional JVM XX options (e.g., `-XX:+UseG1GC`).

### Backup & Maintenance

- **`ENABLE_AUTOPAUSE`** - Set to `"true"` to automatically pause server when no players. Default: `false`
- **`AUTOPAUSE_TIMEOUT_EST`** - Estimated seconds before autopause triggers. Default: `3600`
- **`AUTOPAUSE_TIMEOUT_KN`** - Known seconds before autopause triggers. Default: `120`
- **`AUTOPAUSE_PERIOD`** - Seconds between autopause checks. Default: `10`

## Useful Commands

### Start the server
```bash
docker-compose up -d
```

### Stop the server
```bash
docker-compose down
```

### Restart the server
```bash
docker restart minecraft
```

### View server logs
```bash
docker logs -f minecraft
```

### Access server console
```bash
docker attach minecraft
```
*Press `Ctrl+P` then `Ctrl+Q` to detach without stopping the server*

### Execute commands
```bash
docker exec -i minecraft rcon-cli
```

### Backup the server
```bash
sudo tar -czf minecraft-backup-$(date +%Y%m%d).tar.gz /minecraft
```

## File Structure

```
/minecraft/
├── plugins/
│   ├── Geyser-Spigot/
│   │   └── extensions/
│   │       ├── EmoteOffhand.jar
│   │       ├── ThirdPartyCosmetics.jar
│   │       └── MCXboxBroadcastExtension.jar
│   ├── Floodgate.jar
│   ├── Geyser-Spigot.jar
│   ├── Hurricane.jar
│   └── ViaVersion.jar
├── world/
├── world_nether/
├── world_the_end/
├── server.properties
└── ... (other server files)
```

## Troubleshooting

### Server won't start
- Check if ports 25565 and 19132 are available
- Verify Docker has sufficient memory allocated
- Check logs: `docker logs minecraft`

### Bedrock players can't connect
- Ensure port 19132/udp is open in your firewall
- Verify Geyser plugin loaded successfully in server logs
- Check Geyser configuration in `/minecraft/plugins/Geyser-Spigot/config.yml`

### Extensions not loading
- Ensure extensions are in the correct directory: `/minecraft/plugins/Geyser-Spigot/extensions/`
- Verify file permissions allow the container to read the files
- Check that the server was restarted after adding extensions

### Performance issues
- Increase memory allocation in docker-compose.yml (MEMORY: "6G" or higher)
- Reduce render distance in server.properties
- Consider enabling view-distance optimization in Paper config

## Updating

### Update server version
1. Edit `docker-compose.yml` and change the `VERSION` environment variable
2. Restart the container: `docker-compose down && docker-compose up -d`

### Update plugins
Plugins are automatically downloaded to their latest versions when specified with `/latest/` in the URL. To update:
```bash
docker-compose down
docker-compose up -d
```

### Update Docker image
```bash
docker-compose pull
docker-compose up -d
```

## Support

- **itzg/minecraft-server**: https://github.com/itzg/docker-minecraft-server
- **GeyserMC**: https://geysermc.org/
- **Paper**: https://papermc.io/

## License

This configuration uses open-source software. Please refer to individual project licenses:
- Minecraft is owned by Mojang/Microsoft
- Paper, Geyser, and other plugins have their own licenses
