FROM alexanderczigler/cron
LABEL maintainer="dev@ilix.se"

# Install gnupg2 to be able to add overviewer's key
RUN apt-get update
RUN apt-get -y install gnupg2 wget

# Setup overviewer in aptitude.
ADD http://overviewer.org/debian/overviewer.gpg.asc /tmp/overviewer.gpg.asc
RUN echo "deb http://overviewer.org/debian ./" >> /etc/apt/sources.list
RUN apt-key add /tmp/overviewer.gpg.asc && rm -f /tmp/overviewer.gpg.asc

# Install overviewer and dependencies.
RUN apt-get update
RUN apt-get -y install minecraft-overviewer

# Add crontab.
COPY crontab /etc/cron.d/crontab

# Add config file
COPY config /etc/overviewer.config

# Setup render user (this user runs overviewer)
RUN adduser --disabled-password --gecos "" overviewer

# Setup textures + config + map dir
ARG minecraft_version=1.17
RUN mkdir -p /home/overviewer/.minecraft/versions/${minecraft_version}/
RUN wget https://overviewer.org/textures/${minecraft_version} -O /home/overviewer/.minecraft/versions/${minecraft_version}/${minecraft_version}.jar
RUN mkdir -p /home/overviewer/map && chown overviewer:overviewer /home/overviewer/map
