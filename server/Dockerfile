FROM openjdk

# Meta
LABEL maintainer="alexander@iteam.se"

WORKDIR /mc
ADD ./run.sh /run.sh

# Download desired server.jar from Mojang
ARG JAR
ADD $JAR /mc/server.jar

# Server
EXPOSE 25565

# RCON
EXPOSE 25565

CMD sh /run.sh