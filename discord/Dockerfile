FROM debian

# Meta
LABEL maintainer="alexander@iteam.se"

RUN apt-get update && apt-get install -y curl
CMD tail -n 1 -F /minecraft/logs/latest.log | while read line; do curl -H "Content-Type: application/json" -d '{"username": "", "content": "'"$line"'"}' -X POST $WEBHOOK; done