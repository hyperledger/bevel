# Docker image for Bevel alpine utilities 
FROM alpine

WORKDIR /usr/src

RUN apk add --no-cache curl jq wget openssl
RUN wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.25.tar.gz -P /mysql
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.27.0/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin
