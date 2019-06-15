FROM openjdk

# Meta
LABEL maintainer="alexander@iteam.se"

WORKDIR /mc
ADD ./run.sh /run.sh

ARG JAR
ADD $JAR /mc/server.jar

EXPOSE 25565
CMD sh /run.sh