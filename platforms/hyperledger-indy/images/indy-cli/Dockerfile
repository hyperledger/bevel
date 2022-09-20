
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y apt-transport-https

ARG indy_stream=master

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CE7709D068DB5E88
RUN echo "deb https://repo.sovrin.org/sdk/deb xenial $indy_stream" >> /etc/apt/sources.list

RUN apt-get update

RUN apt-get install -y indy-cli

RUN apt-get install -y jq

RUN apt-get install curl -y

COPY indy-ledger.sh /home/

RUN chmod +x /home/indy-ledger.sh
