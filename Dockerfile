# USAGE: 
# docker build . -t baf-build
# docker run -v $(pwd)/config/:/home/build/config/ baf-build

FROM ubuntu:16.04

# Create working directory
WORKDIR /home/build

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        curl \
        unzip \
        default-jre \
        git \
        python \
        python3-dev \
        python3-pip && \
        pip3 install --no-cache --upgrade pip setuptools wheel && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install ansible && \
    pip3 install jmespath && \
    pip3 install openshift

RUN rm /etc/apt/apt.conf.d/docker-clean
RUN mkdir /etc/ansible/
RUN /bin/echo -e "[ansible_provisioners:children]\nlocal\n[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Copy code to container
COPY ./ /home/build/blockchain-automation-framework
COPY ./run.sh /home/build/run.sh
RUN chmod 755 /home/build/run.sh

# The path to mount the volume; should contain 
# 1) K8s config file as config
# 2) Network specific configuration file as network.yaml
# 3) Private key file which has write-access to the git repo

VOLUME /home/build/config/

CMD ["/home/build/run.sh"]
