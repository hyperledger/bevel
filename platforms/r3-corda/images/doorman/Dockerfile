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
#ENV NMS_MONGOD_LOCATION=/opt/doorman/mongodb-linux-x86_64-amazon2-4.0.4/bin/mongod
WORKDIR /opt/doorman
RUN yum install -y java-1.8.0-openjdk-headless shadow-utils.x86_64 \
  && yum clean all \
  && mkdir -p /opt/doorman/db /opt/doorman/logs /home/doorman \
  && groupadd -g 1000 -r doorman \
  && useradd -r -u 1000 -g doorman doorman \
  && chgrp -R 0 /opt/doorman \
  && chmod -R g=u /opt/doorman \
  && chown -R doorman:doorman /opt/doorman /home/doorman
USER doorman
VOLUME /opt/doorman/db /opt/doorman/logs
COPY target/doorman.jar /opt/doorman/doorman.jar