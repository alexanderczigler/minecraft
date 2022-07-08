FROM openjdk
LABEL maintainer="dev@ilix.se"

WORKDIR /mc
ADD ./run.sh /run.sh

# Download desired server.jar from Mojang
ARG JAR=https://launcher.mojang.com/v1/objects/e00c4052dac1d59a1188b2aa9d5a87113aaf1122/server.jar # Default 1.19
ADD $JAR /mc/server.jar

# Server
EXPOSE 25565

# RCON
EXPOSE 25575

ENV MEMORY_LIMIT=2
CMD sh /run.sh
