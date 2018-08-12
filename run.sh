#!/bin/sh
cd /mc
curl -o server.jar https://launcher.mojang.com/mc/game/1.12/server/8494e844e911ea0d63878f64da9dcc21f53a3463/server.jar

rm -fr /mc/eula.txt
java -Xmx2G -jar /mc/server.jar
sed -i 's/false/true/g' /mc/eula.txt
java -Xmx2G -jar /mc/server.jar
