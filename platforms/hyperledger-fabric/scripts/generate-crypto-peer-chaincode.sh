#!/bin/bash
if [ $# -lt 7 ]; then
	echo "Usage : . $0 <namespace> <nodename> <id-name> <id-type> <affiliation> <subject> <ca-server-url>"
	exit
fi

set -x

# Input parameters
FULLY_QUALIFIED_ORG_NAME=$1
ORG_NAME=$2
TYPE_FOLDER=peers
ID_NAME=$3
ID_TYPE=$4
AFFILIATION=$5
SUBJECT=$6
CA=$7

# Local variables
CURRENT_DIR=${PWD}
ORG_CYPTO_FOLDER="/crypto-config/peerOrganizations/${FULLY_QUALIFIED_ORG_NAME}"
ROOT_TLS_CERT="/crypto-config/peerOrganizations/${FULLY_QUALIFIED_ORG_NAME}/ca/ca.${FULLY_QUALIFIED_ORG_NAME}-cert.pem"
CAS_FOLDER="${HOME}/ca-tools/cas/ca-${ORG_NAME}"
ORG_HOME="${HOME}/ca-tools/${ORG_NAME}"


## Register and enroll chaincode cert for peer

# Get the user identity
ORG_USER="${ID_NAME}@${FULLY_QUALIFIED_ORG_NAME}"
ORG_USERPASS="${ID_NAME}@${FULLY_QUALIFIED_ORG_NAME}-pw"
ADMIN_USER="Admin@${FULLY_QUALIFIED_ORG_NAME}"
ADMIN_USERPASS="Admin@${FULLY_QUALIFIED_ORG_NAME}-pw"


CA_ADMIN_USER="${ORG_NAME}-admin"
CA_ADMIN_PASS="${ORG_NAME}-adminpw"

fabric-ca-client enroll -d -u https://${CA_ADMIN_USER}:${CA_ADMIN_PASS}@${CA} --tls.certfiles ${ROOT_TLS_CERT} --home ${CAS_FOLDER}

# Checking if the user msp folder exists in the CA server	
if [ ! -d "${ORG_HOME}/client${ID_NAME}" ]; then # if user certificates do not exist

	## Register and enroll User for Org
	fabric-ca-client register -d --id.name ${ORG_USER} --id.secret ${ORG_USERPASS} --id.type ${ID_TYPE} --csr.names "${SUBJECT}" --tls.certfiles ${ROOT_TLS_CERT} --home ${CAS_FOLDER}

	# Enroll the registered user to generate enrollment certificate
	fabric-ca-client enroll -d -u https://${ORG_USER}:${ORG_USERPASS}@${CA} --tls.certfiles ${ROOT_TLS_CERT} --home ${ORG_HOME}/client${ID_NAME}

	mkdir ${ORG_HOME}/client${ID_NAME}/msp/admincerts
	cp ${ORG_HOME}/client${ID_NAME}/msp/signcerts/* ${ORG_HOME}/client${ID_NAME}/msp/admincerts/${ORG_USER}-cert.pem

	mkdir -p ${ORG_CYPTO_FOLDER}/users/${ORG_USER}
	cp -R ${ORG_HOME}/client${ID_NAME}/msp ${ORG_CYPTO_FOLDER}/users/${ORG_USER}

	# Get TLS cert for user and copy to appropriate location
	fabric-ca-client enroll -d --enrollment.profile tls -u https://${ORG_USER}:${ORG_USERPASS}@${CA} -M ${ORG_HOME}/client${ID_NAME}/tls --tls.certfiles ${ROOT_TLS_CERT}

	# Copy the TLS key and cert to the appropriate place
	mkdir -p ${ORG_CYPTO_FOLDER}/users/${ORG_USER}/tls
	cp ${ORG_HOME}/client${ID_NAME}/tls/keystore/* ${ORG_CYPTO_FOLDER}/users/${ORG_USER}/tls/client.key
	cp ${ORG_HOME}/client${ID_NAME}/tls/signcerts/* ${ORG_CYPTO_FOLDER}/users/${ORG_USER}/tls/client.crt
	cp ${ORG_HOME}/client${ID_NAME}/tls/tlscacerts/* ${ORG_CYPTO_FOLDER}/users/${ORG_USER}/tls/ca.crt

else # If User certificate exists

	# Current datetime + 5 minutes | e.g. 20210302182036
	CUR_DATETIME=$(date -d "$(echo $(date)' + 5 minutes')" +'%Y%m%d%H%M%S')

	# Extracting "notAfter" datetime from the existing user certificate | e.g. 20210302182036
	CERT_DATETIME=$(date -d "$(echo $(openssl x509 -noout -enddate < ${ORG_HOME}/client${ID_NAME}/msp/signcerts/cert.pem) | sed 's/notAfter=//g')" +'%Y%m%d%H%M%S')

	# In case the certificate is expired or attrs key and value pairs do not match completly, generate a new certificate for the user
	if [ "${CUR_DATETIME}" -ge "$CERT_DATETIME" ]; then

		# Generate a new enrollment certificate
		fabric-ca-client enroll -d -u https://${ORG_USER}:${ORG_USERPASS}@${CA} --tls.certfiles ${ROOT_TLS_CERT} --home ${ORG_HOME}/client${ID_NAME}

		cp ${ORG_HOME}/client${ID_NAME}/msp/signcerts/* ${ORG_HOME}/client${ID_NAME}/msp/admincerts/${ORG_USER}-cert.pem
		cp -R ${ORG_HOME}/client${ID_NAME}/msp ${ORG_CYPTO_FOLDER}/users/${ORG_USER}

		# Get TLS cert for user and copy to appropriate location
		fabric-ca-client enroll -d --enrollment.profile tls -u https://${ORG_USER}:${ORG_USERPASS}@${CA} -M ${ORG_HOME}/client${ID_NAME}/tls --tls.certfiles ${ROOT_TLS_CERT}

		# Copy the TLS key and cert to the appropriate place
		cp ${ORG_HOME}/client${ID_NAME}/tls/keystore/* ${ORG_CYPTO_FOLDER}/users/${ORG_USER}/tls/client.key
		cp ${ORG_HOME}/client${ID_NAME}/tls/signcerts/* ${ORG_CYPTO_FOLDER}/users/${ORG_USER}/tls/client.crt
		cp ${ORG_HOME}/client${ID_NAME}/tls/tlscacerts/* ${ORG_CYPTO_FOLDER}/users/${ORG_USER}/tls/ca.crt
	fi
fi

cd ${CURRENT_DIR}
