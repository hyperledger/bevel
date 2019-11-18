# USAGE: 
# docker build . -t baf-build
# docker run --volume=$(pwd)/network-cordav2.yaml:/home/build/network.yaml baf-build

FROM ubuntu:16.04

ARG ANSIBLE_VERSION=2.8.6
ARG KUBECTL_VERSION=v1.15.0

# Create working directory
WORKDIR /home/build

# Install environment
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        curl \
        unzip \
        python \
        python3-dev \
        python3-pip && \
        pip3 install --no-cache --upgrade pip setuptools wheel && \
    rm -rf /var/lib/apt/lists/*

# Install Ansible
RUN pip3 install ansible==${ANSIBLE_VERSION} --upgrade

# Install Kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /bin/kubectl

# Install AWS CLI
RUN pip3 install awscli --upgrade

# Copy code to container
COPY ./platforms /home/build/platforms
COPY ./run.sh /home/build/run.sh
RUN chmod 755 /home/build/run.sh

# The path to pass in the network.yml file
VOLUME /home/build/network.yaml

CMD ["/home/build/run.sh"]