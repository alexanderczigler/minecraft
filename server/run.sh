#!/bin/sh
cd /mc

# Agree to EULA
echo "By running this container, you are agreeing to stick to the rules of the end user license agreement terms."

rm -fr /mc/eula.txt
java -Xmx${MEMORY_LIMIT}G -jar /mc/server.jar nogui
sed -i 's/false/true/g' /mc/eula.txt

# Enable RCON
sed -i "/enable-rcon=*/c\enable-rcon=$RCON_ENABLE" server.properties
sed -i "/rcon.password=*/c\rcon.password=$RCON_PASSWORD" server.properties

# Start server
java -Xmx${MEMORY_LIMIT}G -jar /mc/server.jar nogui
