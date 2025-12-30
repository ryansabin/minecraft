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
- Generate the world with seed `46182117`
- Start on world name "Season4"

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

The server is configured with the following settings:

| Setting | Value |
|---------|-------|
| World Seed | 46182117 |
| World Name | Season4 |
| Memory | 4GB |
| Difficulty | Normal (2) |
| Timezone | America/Denver |
| Game Mode Enforcement | Enabled |

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
