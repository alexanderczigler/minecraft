#!/bin/sh
cd /mc
curl -o server.jar https://launcher.mojang.com/v1/objects/886945bfb2b978778c3a0288fd7fab09d315b25f/server.jar

rm -fr /mc/eula.txt
java -Xmx2G -jar /mc/server.jar
sed -i 's/false/true/g' /mc/eula.txt
java -Xmx2G -jar /mc/server.jar
