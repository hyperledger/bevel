FROM ubuntu:16.04

ARG uid=1000

# Install environment
RUN apt-get update -y && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	supervisor

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CE7709D068DB5E88
RUN echo "deb https://repo.sovrin.org/deb xenial stable" >> /etc/apt/sources.list

RUN useradd -ms /bin/bash -u $uid indy

ARG indy_plenum_ver=1.12.6
ARG indy_node_ver=1.12.6

RUN apt-get update -y && apt-get install -y \
	indy-node=${indy_node_ver} \
    indy-plenum=${indy_plenum_ver} \
    && rm -rf /var/lib/apt/lists/*

COPY start-indy-node.sh /var/lib/indy
RUN chmod +x /var/lib/indy/start-indy-node.sh

VOLUME /var/lib/indy/data
VOLUME /var/lib/indy/keys

ENTRYPOINT ["/var/lib/indy/start-indy-node.sh"]