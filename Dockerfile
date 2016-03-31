FROM java

WORKDIR /mc
ADD ./run.sh /run.sh

EXPOSE 25565
CMD sh /run.sh
