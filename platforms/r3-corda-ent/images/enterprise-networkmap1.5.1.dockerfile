FROM corda/enterprise-networkmap:1.5.1-zulu-openjdk8u242

ENV ACCEPT_LICENSE=Y
USER root
RUN apt-get update && apt-get install -y openssh-client
