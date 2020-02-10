FROM aczigler/cron

# Meta
LABEL maintainer="alexander@iteam.se"

WORKDIR /tmp

RUN apt-get update && apt-get -y install rsync

# Install minecraft rcon client.
ADD https://github.com/Tiiffi/mcrcon/releases/download/v0.0.5/mcrcon-0.0.5-linux-x86-64.tar.gz /tmp/mcrcon-0.0.5-linux-x86-64.tar.gz
RUN tar zxvf mcrcon-0.0.5-linux-x86-64.tar.gz && rm mcrcon-0.0.5-linux-x86-64.tar.gz
RUN chmod +x mcrcon

# Setup backup system.
COPY crontab /etc/cron.d/crontab
COPY backup.sh /tmp/backup.sh