FROM iteamacr/cron:oldstable
LABEL maintainer="alexander@iteam.se"

# Install gnupg2 to be able to add overviewer's key
RUN apt-get update
RUN apt-get -y install gnupg2 wget

# Setup overviewer in aptitude.
ADD http://overviewer.org/debian/overviewer.gpg.asc /tmp/overviewer.gpg.asc
RUN echo "deb http://overviewer.org/debian ./" >> /etc/apt/sources.list
RUN apt-key add /tmp/overviewer.gpg.asc

# Install overviewer and dependencies.
RUN apt-get update
RUN apt-get -y install minecraft-overviewer

# Setup textures
ARG minecraft_version
RUN mkdir -p ~/.minecraft/versions/${minecraft_version}/
RUN wget https://overviewer.org/textures/${minecraft_version} -O ~/.minecraft/versions/${minecraft_version}/${minecraft_version}.jar

# Add crontab.
COPY config /config
COPY crontab /etc/cron.d/crontab