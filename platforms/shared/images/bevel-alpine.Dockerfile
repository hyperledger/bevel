# Docker image for Bevel alpine utilities 
FROM alpine

WORKDIR /usr/src

RUN apk add --no-cache curl jq openssl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.27.0/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin
