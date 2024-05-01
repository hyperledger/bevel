FROM ubuntu:16.04

USER root

ARG ROCKS_DB_VERSION=5.8.8
ARG LIBINDY_CRYPTO_VERSION=0.4.5
ARG INDY_NODE_VERSION=1.12.6

ENV VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3 \
    WORKON_HOME=$HOME/.virtualenvs \
    ENABLE_STDOUT_LOG=True \
    LOG_ROTATION_BACKUP_COUNT=10 \
    LEDGER_DIR='/var/lib/indy/data' \
    LOG_DIR='/var/log/indy' \
    KEYS_DIR='/var/lib/indy/keys-ktb-demo-client' \
    GENESIS_DIR='/var/lib/indy/genesis-ktb-demo-client' \
    BACKUP_DIR='/var/lib/indy/backup' \
    PLUGINS_DIR='/var/lib/indy/plugins' \
    NODE_INFO_DIR='/var/lib/indy/data' \
    NETWORK_NAME='bevel' \
    INDY_HOME=/opt/indy/ \
    INDY_CONFIG_DIR=/etc/indy/ \
    NODES_COUNT=4 \
    NODE_NAMES="node1,node2,node3,node4" \
    IPS="node1,node2,node3,node4" \
    NODE_PORTS="9701,9702,9703,9704" \
    CLIENT_PORTS="9705,9706,9707,9708" \
    VAULT_TOKEN=""

# Installing python and pip
RUN apt-get update && \
    apt-get install -y software-properties-common python-software-properties && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.5 python3-pip python3.5-dev jq

RUN pip3 install --upgrade "pip < 21.0" setuptools==50.3.2 Cython==0.29.36

# Installing virtualenvwrapper
RUN pip3 install virtualenvwrapper

# Setting up https for apt
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates

RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu xenial main universe" && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CE7709D068DB5E88 && \
    add-apt-repository "deb https://repo.sovrin.org/deb xenial stable" && \
    add-apt-repository "deb https://repo.sovrin.org/sdk/deb xenial stable" && \
    apt-get update

# Installing libsodium
RUN apt-get install -y libsodium18

# Installing RocksDB
RUN apt-get install -y libbz2-dev \
    zlib1g-dev \
    liblz4-dev \
    libsnappy-dev \
    rocksdb=${ROCKS_DB_VERSION}

# Installing Libindy and Libindy Crypto
RUN apt-get install -y libindy libindy-crypto=${LIBINDY_CRYPTO_VERSION}

# Installing indy node and plenum
RUN mkdir -p ${INDY_HOME}
WORKDIR ${INDY_HOME}
COPY config/indy_config.py ${INDY_CONFIG_DIR}
RUN /bin/bash -c "source /usr/local/bin/virtualenvwrapper.sh; mkvirtualenv ${NETWORK_NAME}; workon ${NETWORK_NAME}; pip3 install Cython==0.29.36 certifi==2021.10.8 pyzmq"
RUN /bin/bash -c "source /usr/local/bin/virtualenvwrapper.sh; workon ${NETWORK_NAME}; pip3 install indy-node==${INDY_NODE_VERSION}"   
RUN /bin/bash -c "source /usr/local/bin/virtualenvwrapper.sh; workon ${NETWORK_NAME}; pip3 install flake8 requests"

COPY src/identity_crypto_generator.py /.virtualenvs/${NETWORK_NAME}/lib/python3.5/site-packages/plenum/common/identity_crypto_generator.py
COPY src/identity_crypto_generator_v2.py /.virtualenvs/${NETWORK_NAME}/lib/python3.5/site-packages/plenum/common/identity_crypto_generator_v2.py
COPY src/generate_identity /.virtualenvs/${NETWORK_NAME}/bin/generate_identity
COPY src/generate_identityv2 /.virtualenvs/${NETWORK_NAME}/bin/generate_identityv2
COPY src/generate_identity.sh /usr/bin/generate_identity
COPY src/generate_identityv2.sh /usr/bin/generate_identityv2
RUN chmod +x /.virtualenvs/${NETWORK_NAME}/bin/generate_identity* && \
    chmod +x /usr/bin/generate_identity*

RUN echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.bashrc && \
    echo 'workon ${NETWORK_NAME}' >> ~/.bashrc

CMD /bin/bash
