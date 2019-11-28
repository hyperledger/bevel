FROM amazonlinux:2
LABEL VENDOR="Accenture" \
      MAINTAINER="Accenture"
EXPOSE 8080
#ENV NMS_TLS=false
#ENV NMS_DOORMAN=true
#ENV NMS_CERTMAN=true
#ENV NMS_PORT=8080
#ENV NMS_DB=db
#ENV NMS_MONGO_CONNECTION_STRING=mongodb://localhost:27017
#ENV NMS_MONGOD_LOCATION=/opt/networkmap/mongodb-linux-x86_64-amazon2-4.0.4/bin/mongod
WORKDIR /opt/networkmap
RUN yum install -y java-1.8.0-openjdk-headless shadow-utils.x86_64 \
  && yum clean all \
  && mkdir -p /opt/networkmap/db /opt/networkmap/logs /home/networkmap \
  && groupadd -g 1000 -r networkmap \
  && useradd -r -u 1000 -g networkmap networkmap \
  && chgrp -R 0 /opt/networkmap \
  && chmod -R g=u /opt/networkmap \
  && chown -R networkmap:networkmap /opt/networkmap /home/networkmap
USER networkmap
VOLUME /opt/networkmap/db /opt/networkmap/logs
COPY target/network-map-service.jar /opt/networkmap/network-map.jar