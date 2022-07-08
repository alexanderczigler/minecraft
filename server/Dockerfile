FROM openjdk
LABEL maintainer="dev@ilix.se"

WORKDIR /mc
ADD ./run.sh /run.sh

# Download desired server.jar from Mojang
ARG JAR=https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar
ADD $JAR /mc/server.jar

# Server
EXPOSE 25565

# RCON
EXPOSE 25575

ENV MEMORY_LIMIT=2
CMD sh /run.sh
