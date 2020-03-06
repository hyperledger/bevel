FROM hyperledgerlabs/blockchain-linuxkit:latest
LABEL VENDOR="Hyperledger" \
MAINTAINER="Hyperledger"
EXPOSE 8080
#ENV NMS_TLS=false
#ENV NMS_DOORMAN=true
#ENV NMS_CERTMAN=true
#ENV NMS_PORT=8080
#ENV NMS_DB=db
#ENV NMS_MONGO_CONNECTION_STRING=mongodb://localhost:27017
#ENV NMS_MONGOD_LOCATION=/opt/doorman/mongodb-linux-x86_64-amazon2-4.0.4/bin/mongod
WORKDIR /opt/doorman
RUN mkdir -p /opt/doorman/db /opt/doorman/logs /home/doorman \
  && addgroup doorman \
  && adduser -G doorman -D -s doorman doorman \
  && chgrp -R 0 /opt/doorman \
  && chmod -R g=u /opt/doorman \
  && chown -R doorman:doorman /opt/doorman /home/doorman
USER root
VOLUME /opt/doorman/db /opt/doorman/logs
COPY target/doorman.jar /opt/doorman/doorman.jar
