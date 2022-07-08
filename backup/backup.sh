#!/bin/bash
echo "Running backup script..."

function rcon {
  echo "RCON: $1"
  /tmp/mcrcon -sc -H "$MINECRAFT_SERVER" -P "$MINERACFT_SERVER_PORT" -p "$MINECRAFT_RCON_PASSWORD" "$1"
}

BACKUP_NAME=$(date +\%Y-\%m-\%d_\%H\%M\%S).gz

# Disable world writing
rcon "save-off"
rcon "save-all"

# Backup world
tar zcvf "/backup/$BACKUP_NAME" /mc/world

# Enable world writing
rcon "save-on"
echo "Done!"
