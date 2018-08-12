#!/bin/sh
cd /mc
curl -o server.jar https://launcher.mojang.com/mc/game/1.13/server/d0caafb8438ebd206f99930cfaecfa6c9a13dca0/server.jar

rm -fr /mc/eula.txt
java -Xmx2G -jar /mc/server.jar
sed -i 's/false/true/g' /mc/eula.txt
java -Xmx2G -jar /mc/server.jar
