FROM phusion/baseimage:0.11

LABEL net.corda.version = "4.4" \
      maintainer = "Hyperledger" \
      vendor = "R3"

RUN apt-get update && \
    apt-get install -y openjdk-8-jre && \
    rm -rf /var/cache/apt/* && \
    # Add user to run the app && \
    groupadd corda && \
    useradd -c "Corda user" -g corda -m -s /bin/bash corda && \
    # Create /opt/corda directory && \
    mkdir -p /opt/corda/plugins && \
    mkdir -p /opt/corda/logs

ARG var_CORDA_HOME=/opt/corda
ENV CORDA_HOME=$var_CORDA_HOME

# Env variables for running locally
ARG var_WEBAPP_NAME=webserver-supply-chain-0.1.jar
ARG var_WEBAPP_PROFILE=cordaTest
ENV WEBAPP_NAME=$var_WEBAPP_NAME
ENV WEBAPP_PROFILE=$var_WEBAPP_PROFILE

# expose generic ports here
EXPOSE 20001

# Copy jar
COPY build/webapps/$var_WEBAPP_NAME webserver-supply-chain-0.1.jar

RUN chown -R corda:corda /opt/corda

# Working directory for Corda
WORKDIR ${CORDA_HOME}
ENV HOME=${CORDA_HOME}
USER corda

# start it
CMD cp /webserver-supply-chain-0.1.jar ${CORDA_HOME} && java -Dspring.profiles.active=${WEBAPP_PROFILE} -jar webserver-supply-chain-0.1.jar 2>&1
