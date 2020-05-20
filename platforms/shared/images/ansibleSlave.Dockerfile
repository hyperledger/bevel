FROM openjdk:8u181

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    acl \
    asciidoc \
    bzip2 \
    cdbs \
    curl \
    debhelper \
    debianutils \
    devscripts \
    docbook-xml \
    dpkg-dev \
    fakeroot \
    gawk \
    gcc \
    git \
    python \
    python3-dev \
    python3-pip \
    libffi-dev \
    libssl-dev \
    libxml2-utils \
    libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev \
    locales \
    make \
    mercurial \
    openssh-client \
    openssh-server \
    pass \
    reprepro \
    rsync \
    ruby \
    sshpass \
    sudo \
    tzdata \
    unzip \
    xsltproc \
    zip \
    awscli && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
RUN pip3 install ansible && \
    pip3 install jmespath && \
    pip3 install openshift && \
    pip3 install molecule[docker]

RUN apt-get update && \
    apt-get -y install apt-transport-https \
    ca-certificates \
    jq \
    dnsutils \
    gnupg2 \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
    apt-get update && \
    apt-get -y install docker-ce

ENV PATH=/root/bin:/root/.local/bin/:$PATH
RUN mkdir /etc/ansible/
RUN /bin/echo -e "[ansible_provisioners:children]\nlocal\n[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts
RUN locale-gen en_US.UTF-8
RUN ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
    for key in /etc/ssh/ssh_host_*_key.pub; do echo "localhost $(cat ${key})" >> /root/.ssh/known_hosts; done

# CMD ["/sbin/init"]
# default command: display Ansible version
CMD [ "ansible", "--version" ]
