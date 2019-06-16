#!/bin/bash
echo "Running backup script..."

function rcon {
  /tmp/mcrcon -sc -H "$MINECRAFT_SERVER" -P "$MINERACFT_SERVER_PORT" -p "$MINECRAFT_RCON_PASSWORD" "$1"
}

rcon "save-off"
rcon "save-all"
rsync -av /minecraft rsync://$RSYNC_USER@$RSYNC_HOST:$RSYNC_PATH
rcon "save-on"