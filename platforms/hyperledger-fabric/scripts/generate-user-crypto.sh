#!/bin/bash
if [ $# -lt 7 ]; then
	echo "Usage : . $0 orderer|peer <namespace> <nodename> <no of users: min 1> <affiliation> <subject> <ca-server-url>"
	exit
fi

set -x

CURRENT_DIR=${PWD}
FULLY_QUALIFIED_ORG_NAME=$2

ORG_NAME=$3
TYPE_FOLDER=$1s
NO_OF_USERS=$4
AFFILIATION=$5
SUBJECT=$6

CA=$7

if [ "$1" != "peer" ]; then
	ORG_CYPTO_FOLDER="/crypto-config/ordererOrganizations/${FULLY_QUALIFIED_ORG_NAME}"
	ROOT_TLS_CERT="/crypto-config/ordererOrganizations/${FULLY_QUALIFIED_ORG_NAME}/ca/ca.${FULLY_QUALIFIED_ORG_NAME}-cert.pem"
else
	ORG_CYPTO_FOLDER="/crypto-config/$1Organizations/${FULLY_QUALIFIED_ORG_NAME}"
	ROOT_TLS_CERT="/crypto-config/$1Organizations/${FULLY_QUALIFIED_ORG_NAME}/ca/ca.${FULLY_QUALIFIED_ORG_NAME}-cert.pem"
fi



CAS_FOLDER="${HOME}/ca-tools/cas/ca-${ORG_NAME}"
ORG_HOME="${HOME}/ca-tools/${ORG_NAME}"

## Register and enroll users
USER=0
while [ ${USER} -lt ${NO_OF_USERS} ]; do
	## increment value first to avoid User0
	let USER=USER+1
	## Register and enroll User for Org
	ORG_USER="User${USER}@${FULLY_QUALIFIED_ORG_NAME}"
	ORG_USERPASS="User${USER}@${FULLY_QUALIFIED_ORG_NAME}-pw"

	if [ "$1" = "peer" ]; then
		fabric-ca-client register -d --id.name ${ORG_USER} --id.secret ${ORG_USERPASS} --id.type client --csr.names "${SUBJECT}" --id.affiliation ${AFFILIATION} --id.attrs "hf.Revoker=true" --tls.certfiles ${ROOT_TLS_CERT} --home ${CAS_FOLDER}
	else
		fabric-ca-client register -d --id.name ${ORG_USER} --id.secret ${ORG_USERPASS} --id.type client --csr.names "${SUBJECT}" --id.attrs "hf.Revoker=true" --tls.certfiles ${ROOT_TLS_CERT} --home ${CAS_FOLDER}
	fi

	fabric-ca-client enroll -d -u https://${ORG_USER}:${ORG_USERPASS}@${CA} --csr.names "${SUBJECT}" --tls.certfiles ${ROOT_TLS_CERT} --home ${ORG_HOME}/client${USER}

	mkdir ${ORG_HOME}/client${USER}/msp/admincerts
	cp ${ORG_HOME}/client${USER}/msp/signcerts/* ${ORG_HOME}/client${USER}/msp/admincerts/${ORG_USER}-cert.pem

	mkdir -p ${ORG_CYPTO_FOLDER}/users/${ORG_USER}
	cp -R ${ORG_HOME}/client${USER}/msp ${ORG_CYPTO_FOLDER}/users/${ORG_USER}

	# Get TLS cert for user and copy to appropriate location
	fabric-ca-client enroll -d --enrollment.profile tls -u https://${ORG_USER}:${ORG_USERPASS}@${CA} -M ${ORG_HOME}/client${USER}/tls --tls.certfiles ${ROOT_TLS_CERT}

	# Copy the TLS key and cert to the appropriate place
	mkdir -p ${ORG_CYPTO_FOLDER}/users/${ORG_USER}/tls
	cp ${ORG_HOME}/client${USER}/tls/keystore/* ${ORG_CYPTO_FOLDER}/users/${ORG_USER}/tls/client.key
	cp ${ORG_HOME}/client${USER}/tls/signcerts/* ${ORG_CYPTO_FOLDER}/users/${ORG_USER}/tls/client.crt
	cp ${ORG_HOME}/client${USER}/tls/tlscacerts/* ${ORG_CYPTO_FOLDER}/users/${ORG_USER}/tls/ca.crt
done
cd ${CURRENT_DIR}
