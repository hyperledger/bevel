FROM ubuntu:16.04

ARG uid=1000

# Install environment
RUN apt-get update -y && apt-get install -y \
	git \
	wget \
	python3.5 \
	python3-pip \
	python-setuptools \
	python3-nacl \
	apt-transport-https \
	ca-certificates \
	supervisor

RUN pip3 install -U \
	pip==9.0.3 \
	setuptools

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 68DB5E88
ARG indy_stream=master
RUN echo "deb https://repo.sovrin.org/deb xenial $indy_stream" >> /etc/apt/sources.list

RUN useradd -ms /bin/bash -u $uid indy

ARG indy_plenum_ver=1.11.0~dev945
ARG indy_node_ver=1.11.0~dev1123
ARG python3_indy_crypto_ver=0.4.5
ARG indy_crypto_ver=0.4.5
ARG python3_pyzmq_ver=18.1.0

RUN apt-get update -y && apt-get install -y \
        indy-plenum=${indy_plenum_ver} \
        indy-node=${indy_node_ver} \
        python3-indy-crypto=${python3_indy_crypto_ver} \
        libindy-crypto=${indy_crypto_ver} \
        python3-pyzmq=${python3_pyzmq_ver}

COPY start-indy-node.sh /var/lib/indy
RUN chmod +x /var/lib/indy/start-indy-node.sh

VOLUME /var/lib/indy/data
VOLUME /var/lib/indy/keys

ENTRYPOINT ["/var/lib/indy/start-indy-node.sh"]