FROM debian
LABEL maintainer="dev@ilix.se"

RUN apt-get update && apt-get install -y curl
CMD tail -n 1 -F /mc/logs/latest.log | while read line; do curl -H "Content-Type: application/json" -d '{"username": "", "content": "'"$line"'"}' -X POST $WEBHOOK; done
