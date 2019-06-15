FROM openjdk

ARG JAR
ADD $JAR /mc/server.jar
ADD ./run.sh /run.sh

EXPOSE 25565

WORKDIR /mc
CMD sh /run.sh

# Meta
LABEL maintainer="alexander@iteam.se"