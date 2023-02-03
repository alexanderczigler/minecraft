FROM openjdk
LABEL maintainer="dev@ilix.se"

WORKDIR /mc
ADD ./run.sh /run.sh

# Minecraft version: 1.19.3
# https://www.minecraft.net/en-us/download/server
ADD https://piston-data.mojang.com/v1/objects/c9df48efed58511cdd0213c56b9013a7b5c9ac1f/server.jar /mc/server.jar

# Server
EXPOSE 25565

# RCON
EXPOSE 25575

ENV MEMORY_LIMIT=2
ENV RCON_ENABLE=false

CMD sh /run.sh
