# minecraft

I have prepared a docker image that allows you to easily run your own Minecraft server. If you want you can complete your server with rsync backups, overviewer map and discord integration.

The examples below show you how the server stack is run using docker-compose, running the stack in kubernetes or docker swarm is very similar.

## Running

### Minecraft server

If you simply want to run a server without any bells and whistles, you can do that away using the docker cli.

```bash
# Run a fresh server
docker run -p 25565:25565 -t alexanderczigler/minecraft-server:1.19

# Set a higher memory limit
docker run -p 25565:25565 -e MEMORY_LIMIT=4 -t alexanderczigler/minecraft-server:1.19

# Build the image locally and run a fresh server
docker build -t minecraft-server server
docker run -p 25565:25565 -t minecraft-server
```

You can also use my [example compose stack](https://github.com/alexanderczigler/minecraft/blob/main/server/docker-compose.yaml) to run a fresh server. It comes with a local volume so that your world and configuration is saved in case you replace the container with a newer one.

```bash
cd server
docker-compose up
```

### Minecraft Overviewer

[Minecraft Overviewer](http://docs.overviewer.org/en/latest/) generates a beautiful map of your server and combined with an httpd like nginx you can host the map on the web. In addition to the server itself, you will also need to run my `alexanderczigler/minecraft-overviewer` image and configure it to place the output html files somewhere. I usually bundle overviewer with an nginx container to host the html. When the container is running, it will trigger a re-render the map every minute, so that once a render is complete it will restart within a minute. This ensures that your map is always up-to-date.

_NOTE: The image uses `flock` to ensure that only one render is running at the same time._
_NOTE: It can take a few minutes for the map to appear for the first time, so be patient!_

Checkout the [example compose stack](https://github.com/alexanderczigler/minecraft/blob/main/overviewer/docker-compose.yaml) to see how you can run the server, overviewer and nginx.

```bash
cd overviewer
docker-compose up
```

### Discord integration

My `alexanderczigler/minecraft-discord` image works by tailing the log file and pushing any new lines to a discord webhook. This enables your to monitor the activity and chat on the server via discord. To learn how to create a webhook, check out [Discord's documentation](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks).

_NOTE: I recommend you create a dedicated channel for the Minecraft server as there will be a lot of text coming out from the server_

![Discord example](https://raw.githubusercontent.com/alexanderczigler/minecraft/main/discord/example.png)

Checkout the [example compose stack](https://github.com/alexanderczigler/minecraft/blob/main/discord/docker-compose.yaml) to see how you can run the server, overviewer and nginx. Remember to edit the `discord` service first to enter your webhook in the environment section!

```bash
cd discord
docker-compose up
```

## Swarm

If you are aiming for a more fault-tolerant environment, you may want to map your volumes to a network drive rather than a local folder. In addition to that it is a good idea to also take regular off-site backups. Below is an example of a docker swarm stack running all of the above services, including my `alexanderczigler/minecraft-backup` image.

### Example stack

```yaml
version: "3.8"

services:
  server:
    image: alexanderczigler/minecraft-server:1.19
    environment:
      - MEMORY_LIMIT=2
      - RCON_PASSWORD=my-rcon-password
    networks:
      - default
    ports:
      - "25565:25565"
    volumes:
      - type: volume
        source: minecraft_rw
        target: /mc
        volume:
          nocopy: true
    deploy:
      replicas: 1
  overviewer:
    image: alexanderczigler/minecraft-overviewer:1.19
    volumes:
      - type: volume
        source: minecraft
        target: /mc
        volume:
          nocopy: true
      - type: volume
        source: map_rw
        target: /map
        volume:
          nocopy: true
    deploy:
      replicas: 1
  nginx:
    image: matriphe/alpine-nginx
    networks:
      - default
      - proxy
    volumes:
      - type: volume
        source: map
        target: /www
        volume:
          nocopy: true
    deploy:
      replicas: 2
      labels: # NOTE: This example is using traefik as an http ingress
        traefik.port: 80
        traefik.docker.network: "proxy"
        traefik.frontend.rule: "Host:minecraft.your-domain.net" # Change this!
  discord:
    image: alexanderczigler/minecraft-discord:latest
    networks:
      default:
    environment:
      # Set your Discord webhook here.
      - WEBHOOK=https://discordapp.com/api/webhooks/123/abc # Change this!
    volumes:
      - type: volume
        source: minecraft
        target: /mc
        volume:
          nocopy: true
  backup:
    image: alexanderczigler/minecraft-backup:latest
    volumes:
      - type: volume
        source: minecraft
        target: /mc
        volume:
          nocopy: true
    networks:
      default:
    environment:
      - MINECRAFT_SERVER=server
      - MINERACFT_SERVER_PORT=25575
      - MINECRAFT_RCON_PASSWORD=verysecret # Change this!

networks:
  proxy:
    external: true

volumes:
  map:
    driver_opts:
      type: "nfs"
      o: "addr=188.166.25.183,nolock,soft,ro"
      device: ":/mnt/storage-server/minecraft-server/map"
  map_rw:
    driver_opts:
      type: "nfs"
      o: "addr=188.166.25.183,nolock,soft,rw"
      device: ":/mnt/storage-server/minecraft-server/map"
  minecraft:
    driver_opts:
      type: "nfs"
      o: "addr=188.166.25.183,nolock,soft,ro"
      device: ":/mnt/storage-server/minecraft-server/minecraft"
  minecraft_rw:
    driver_opts:
      type: "nfs"
      o: "addr=188.166.25.183,nolock,soft,rw"
      device: ":/mnt/storage-server/minecraft-server/minecraft"
```
