# Docker image for Bevel alpine utilities 
FROM alpine

WORKDIR /usr/src

RUN apk add --no-cache curl jq wget openssl
RUN wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.25.tar.gz -P /mysql
