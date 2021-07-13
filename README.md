# minecraft

I have prepared a docker image that allows you to easily run your own Minecraft server. If you want you can complete your server with rsync backups, overviewer map and discord integration.

The examples below show you how the server stack is run using docker-compose, running the stack in kubernetes or docker swarm is very similar.

## Running

### Minecraft server

```yaml
# docker-compose.yaml
version: '3.8'

services:

  # Minecraft server
  server:
    image: iteamacr/minecraft-server:1.17
    networks:
      - default
    ports:
      - "25565:25565" # server
      - "25575:25575" # rcon
    volumes:
      - minecraft:/mc

volumes:
  minecraft:
```

### Minecraft Overviewer

[Minecraft Overviewer](http://docs.overviewer.org/en/latest/) generates a beautiful map of your server and combined with an httpd like nginx you can host the map on the web.

```yaml
# docker-compose.yaml
version: '3.8'

services:

  # Minecraft server
  server:
    image: iteamacr/minecraft-server:1.17
    networks:
      - default
    ports:
      - "25565:25565" # server
      - "25575:25575" # rcon
    volumes:
      - minecraft:/mc
  
  # Overviewer
  overviewer:
    image: iteamacr/minecraft-overviewer:1.17
    volumes:
      - map:/map
      - minecraft:/mc:nocopy
  nginx:
    image: nginx
    networks:
      - default
    volumes:
      - map:/usr/share/nginx/html
    ports:
      - 80:80

volumes:
  map:
  minecraft:
```

### Discord integration

My `iteamacr/minecraft-discord` image works by tailing the log file and pushing any new lines to a discord webhook. This enables your to monitor the activity and chat on the server via discord.

![Discord example](https://raw.githubusercontent.com/alexanderczigler/minecraft/master/discord/example.png)

```yaml
# docker-compose.yaml
version: '3.8'

services:

  # Minecraft server
  server:
    image: iteamacr/minecraft-server:1.17
    networks:
      - default
    ports:
      - "25565:25565" # server
      - "25575:25575" # rcon
    volumes:
      - minecraft:/mc
  
  # Overviewer
  overviewer:
    image: iteamacr/minecraft-overviewer:1.17
    volumes:
      - map:/map
      - minecraft:/mc:nocopy
  nginx:
    image: nginx
    networks:
      - default
    volumes:
      - map:/usr/share/nginx/html
    ports:
      - 80:80

  # Discord
  discord:
    image: iteamacr/minecraft-discord:latest
    environment:
      # Set your Discord webhook here.
      - WEBHOOK=https://discordapp.com/api/webhooks/123/abc
    volumes:
      - minecraft:/minecraft:nocopy

volumes:
  map:
  minecraft:
```

## Advanced

If you are aiming for a more fault-tolerant environment, you may want to map your volumes to a network drive rather than a local folder.

### Swarm example

```yaml
volumes:
  map:
    driver_opts:
      type: "nfs"
      o: "addr=188.166.25.183,nolock,soft,ro"
      device: ":/mnt/volume_ams3_01/swarm/map"
  map_rw:
    driver_opts:
      type: "nfs"
      o: "addr=188.166.25.183,nolock,soft,rw"
      device: ":/mnt/volume_ams3_01/swarm/map"
  minecraft:
    driver_opts:
      type: "nfs"
      o: "addr=188.166.25.183,nolock,soft,ro"
      device: ":/mnt/volume_ams3_01/swarm/minecraft"
  minecraft_rw:
    driver_opts:
      type: "nfs"
      o: "addr=188.166.25.183,nolock,soft,rw"
      device: ":/mnt/volume_ams3_01/swarm/minecraft"
```