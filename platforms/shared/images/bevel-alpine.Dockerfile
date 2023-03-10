# Docker image for Bevel alpine utilities 
FROM alpine

WORKDIR /usr/src

RUN apk add --no-cache curl jq openssl
