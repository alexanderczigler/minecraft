#!/bin/sh
cd /mc

rm -fr /mc/eula.txt
java -Xmx2G -jar /mc/server.jar
sed -i 's/false/true/g' /mc/eula.txt
java -Xmx2G -jar /mc/server.jar