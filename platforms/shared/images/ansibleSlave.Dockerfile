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
    python-setuptools \
    python-dev \
    python2.7 \
    libffi-dev \
    libssl-dev \
    libxml2-utils \
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
    awscli \
    && \
    apt-get clean
RUN easy_install pip && \
    pip install ansible && \
    pip install jmespath && \
    pip install openshift

RUN rm /etc/apt/apt.conf.d/docker-clean
RUN mkdir /etc/ansible/
RUN /bin/echo -e "[ansible_provisioners:children]\nlocal\n[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts
RUN locale-gen en_US.UTF-8
RUN ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
    for key in /etc/ssh/ssh_host_*_key.pub; do echo "localhost $(cat ${key})" >> /root/.ssh/known_hosts; done

# CMD ["/sbin/init"]
# default command: display Ansible version
CMD [ "ansible", "--version" ]