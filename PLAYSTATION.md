# PlayStation Player Connection Fix Guide

## Quick Fix Checklist

If a PlayStation player is getting "Connection reset" errors, follow these steps in order:

### 1. Verify Server Setup (5 minutes)

```bash
# Check if Geyser is running
docker exec minecraft ls -la /data/plugins/ | grep -i geyser

# Check Geyser logs
docker logs minecraft | grep -i geyser

# Verify port is open
docker exec minecraft netstat -tulpn | grep 19132
```

### 2. Configure Geyser for PlayStation (Required)

After initial server startup, edit the Geyser config:

```bash
# Edit Geyser config
sudo nano /minecraft/plugins/Geyser-Spigot/config.yml
```

Find and modify these settings:

```yaml
bedrock:
  address: 0.0.0.0
  port: 19132
  
remote:
  address: 127.0.0.1
  port: 25565
  auth-type: online

# CRITICAL for PlayStation
enable-proxy-connections: true
connection-timeout: 30

# PlayStation works best with these settings
use-adapters: true
mtu: 1400
```

Save and restart:
```bash
docker restart minecraft
```

### 3. PlayStation Console Settings

Have the player do this on their PlayStation:

1. **Settings → Network → Set Up Internet Connection**
   - Select their connection (WiFi or LAN)
   - Select "Custom" setup
   - IP Address: Automatic
   - DHCP Host Name: Do Not Specify
   - DNS Settings: **Manual**
     - Primary DNS: `8.8.8.8`
     - Secondary DNS: `8.8.4.4`
   - MTU Settings: **Manual** → Enter `1473`
   - Proxy Server: Do Not Use

2. **Test Internet Connection**
   - NAT Type should be Type 1 or Type 2 (NOT Type 3)
   - If Type 3, router port forwarding is required

3. **Restart PlayStation**

### 4. Router Port Forwarding (If Behind NAT)

Forward these ports to your server's IP:

| Port  | Protocol | Service           |
|-------|----------|-------------------|
| 25565 | TCP      | Java Edition      |
| 19132 | UDP      | Bedrock Edition   |

**Important**: Port 19132 must be UDP, not TCP!

### 5. Firewall Rules (Linux Server)

```bash
# Allow Bedrock UDP traffic
sudo ufw allow 19132/udp
sudo ufw allow 25565/tcp

# Verify rules
sudo ufw status
```

### 6. Connection Methods for PlayStation

PlayStation players have 3 ways to connect:

#### Method A: Friends Tab (Easiest - requires MCXboxBroadcast)
1. Server owner adds PlayStation player as Microsoft/Xbox friend
2. Player goes to Minecraft → Friends tab
3. Server appears automatically
4. Click to join

#### Method B: Direct IP
1. Minecraft → Play → Servers tab
2. Scroll down and click "Add Server"
3. Enter:
   - Server Name: `Your Server Name`
   - Server Address: `your-public-ip`
   - Port: `19132`
4. Click "Save" then "Join"

#### Method C: LAN Discovery (Local network only)
1. Server owner enables LAN broadcast in Geyser config
2. PlayStation player looks in "Friends" or "LAN Games" tab
3. Server should appear automatically

### 7. Test Connection Progression

Have the PlayStation player test in this order:

1. **Internal IP First** (if on same network):
   - Try `192.168.1.XXX:19132` (your server's local IP)
   - If this works, problem is with external network/port forwarding

2. **External IP Next**:
   - Try your public IP: `XXX.XXX.XXX.XXX:19132`
   - Get your IP from: https://whatismyipaddress.com/

3. **Domain Name Last** (if you have one):
   - Try `yourserver.com:19132`

### 8. Common PlayStation Error Messages

| Error Message | Cause | Fix |
|---------------|-------|-----|
| "Unable to connect to world" | Port not open | Check firewall & port forwarding |
| "Connection reset" | Authentication timeout | Increase `connection-timeout` in Geyser |
| "Outdated server" / "Outdated client" | Version mismatch | Update server or client |
| Server not appearing in Friends | MCXboxBroadcast issue | Check extension is loaded |
| "Could not connect: timed out" | Wrong IP or port blocked | Verify IP/port and firewall |

### 9. Advanced: Floodgate Configuration

Edit `/minecraft/plugins/floodgate/config.yml`:

```yaml
player-link:
  enabled: true
  type: global
  allowed: true

disconnect-time: 30

# PlayStation-specific
key-file-name: "key.pem"
```

Restart server after changes:
```bash
docker restart minecraft
```

### 10. Debugging Steps

```bash
# Check if Geyser is listening on port 19132
docker exec minecraft ss -tulpn | grep 19132

# Monitor connections in real-time
docker logs -f minecraft | grep -i "connection\|geyser\|bedrock"

# Check Geyser errors
docker exec minecraft cat /data/logs/latest.log | grep -i error

# Verify Floodgate is working
docker exec minecraft cat /data/plugins/floodgate/key.pem
```

### 11. If Nothing Works

Last resort options:

1. **Use a VPN on the PlayStation**:
   - Some ISPs block or throttle game traffic
   - Configure VPN at router level

2. **Try a Different Geyser Build**:
   ```bash
   # Download standalone Geyser
   wget -O /minecraft/plugins/Geyser-Spigot.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot
   docker restart minecraft
   ```

3. **Check PlayStation Network Status**:
   - Visit: https://status.playstation.com/
   - PSN outages affect all online play

4. **Contact Your ISP**:
   - Some ISPs use CGNAT (Carrier-Grade NAT)
   - Request a public IP address
   - May require business internet plan

## Success Indicators

When everything is working, you should see:

```
[Geyser-Spigot] Player connected with username PlayStationPlayer
[Floodgate] PlayStationPlayer has been linked!
```

## Still Having Issues?

1. Share your Geyser config (remove sensitive info)
2. Check server logs during connection attempt
3. Have PlayStation player screenshot the exact error
4. Verify both client and server are on latest versions

## Performance Tips for PlayStation Players

Once connected, optimize their experience:

- Set server view-distance to 8-10 chunks
- Enable "Reduce Lag" in Geyser config
- Use Hurricane plugin (already installed) for better performance
- Have player disable unnecessary resource packs
