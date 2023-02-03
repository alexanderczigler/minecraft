# Minecraft for docker

I have prepared a set of docker images that you can use to run your own Minecraft server. It is currently updated for Minecraft `1.19.3`. Apart from the server itself there is an image for taking regular backups of the world files, a [Minecraft Overviewer](http://docs.overviewer.org/en/latest/) image and a Discord integration.

The examples below show you how the server stack is run using docker compose, running the stack in kubernetes or docker swarm is very similar.

## Running

To run everything locally, simply clone this repo and run `docker compose up`. This will download the pre-built images from Docker Hub and run them on your machine.

If you prefer to build everything locally you can use the `docker-compose.local.yaml` file instead. This is useful if you wish to make modifications to any of the Dockerfiles.

```bash
docker compose -f docker-compose.local.yaml up # Build all images locally before running.
```

### Minecraft server

The `minecraft-server` image runs the java version of Minecraft server. Starting it is easy with `docker run`. Here are some examples:

```bash
# Run a minecraft server.
docker run -p 25565:25565 -t alexanderczigler/minecraft-server

# Enable RCON.
docker run -p 25565:25565 -p 25575:25575 --env RCON_ENABLE=true --env RCON_PASSWORD=my-rcon-password -t alexanderczigler/minecraft-server

# Set a higher memory limit.
docker run -p 25565:25565 -e MEMORY_LIMIT=4 -t alexanderczigler/minecraft-server
```

### Minecraft Overviewer

[Minecraft Overviewer](http://docs.overviewer.org/en/latest/) generates a beautiful map of your server and combined with an httpd like nginx you can host the map on the web. In addition to the server itself, you will also need to run my `alexanderczigler/minecraft-overviewer` image and configure it to place the output html files somewhere. I usually bundle overviewer with an nginx container to host the html. When the container is running, it will trigger a re-render the map every minute, so that once a render is complete it will restart within a minute. This ensures that your map is always up-to-date.

_NOTE: The image uses `flock` to ensure that only one render is running at the same time._
_NOTE: It can take a few minutes for the map to appear for the first time, so be patient!_

### Discord integration

My `alexanderczigler/minecraft-discord` image works by tailing the log file and pushing any new lines to a discord webhook. This enables your to monitor the activity and chat on the server via discord. To learn how to create a webhook, check out [Discord's documentation](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks).

_NOTE: I recommend you create a dedicated channel for the Minecraft server as there will be a lot of text coming out from the server_

![Discord example](https://raw.githubusercontent.com/alexanderczigler/minecraft/main/discord/example.png)

## Swarm

If you are aiming for a more fault-tolerant environment, you may want to map your volumes to a network drive rather than a local folder. In addition to that it is a good idea to also take regular off-site backups. Below is an example of a docker swarm stack running all of the above services, including my `alexanderczigler/minecraft-backup` image.

### Example stack

```yaml
version: "3.8"

services:
  server:
    image: alexanderczigler/minecraft-server
    environment:
      - MEMORY_LIMIT=2
      - RCON_ENABLE=true
      - RCON_PASSWORD=verysecret
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
    image: alexanderczigler/minecraft-overviewer
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
