FROM alexanderczigler/cron
LABEL maintainer="dev@ilix.se"

# Install gnupg2 to be able to add overviewer's key.
RUN apt update
RUN apt -y install build-essential git gnupg2 python3 python3-pil python3-dev python3-numpy wget

# Compile overviewer.
RUN git clone https://github.com/overviewer/Minecraft-Overviewer.git /overviewer
RUN python3 /overviewer/setup.py build
RUN python3 /overviewer/setup.py install

# Add crontab.
COPY crontab /etc/cron.d/crontab

# Add config file.
COPY config /etc/overviewer.config

# Setup render user (this user runs overviewer).
RUN adduser --disabled-password --gecos "" overviewer

# Setup textures + config + map dir.
ARG minecraft_version=1.19
RUN mkdir -p /home/overviewer/.minecraft/versions/${minecraft_version}/
RUN wget https://overviewer.org/textures/${minecraft_version} -O /home/overviewer/.minecraft/versions/${minecraft_version}/${minecraft_version}.jar
RUN chown -R overviewer:overviewer /home/overviewer/.minecraft/
RUN mkdir -p /home/overviewer/map && chown overviewer:overviewer /home/overviewer/map
