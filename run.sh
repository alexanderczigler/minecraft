#!/bin/sh
rm -fr /mc/eula.txt
java -Xmx2G -jar /mc/minecraft_server.jar
sed -i 's/false/true/g' /mc/eula.txt
java -Xmx2G -jar /mc/minecraft_server.jar
