#!/bin/bash
if [ $# -lt 9 ]; then
	echo "Usage : . $0 <namespace> <nodename> <chaincodeid-name> <id-type> <affiliation> <subject> <server-addr> <chaincode-version> <ca-url>"
	exit
fi

set -x

# Input parameters
# orgname-net
FULLY_QUALIFIED_ORG_NAME=$1
# orgname | lower
ORG_NAME=$2
TYPE_FOLDER=chaincode
# chaincode_name
CHAINCODE_NAME=$3
# chaincode
ID_TYPE=$4
# org_name
AFFILIATION=$5
# ca subject
SUBJECT=$6
# chaincode hostname
HOST=$7
# chaincode version
VERSION=$8
# CA Server url
CA=$9

# Local variables
CURRENT_DIR=${PWD}
ORG_CYPTO_FOLDER="/crypto-config/peerOrganizations/${FULLY_QUALIFIED_ORG_NAME}"
ROOT_TLS_CERT="/crypto-config/peerOrganizations/${FULLY_QUALIFIED_ORG_NAME}/ca/ca.${FULLY_QUALIFIED_ORG_NAME}-cert.pem"
CAS_FOLDER="${HOME}/ca-tools/cas/ca-${ORG_NAME}"
ORG_HOME="${HOME}/ca-tools/${ORG_NAME}"


## Register and enroll chaincode cert for peer	
# Get the user identity
ORG_USER="${CHAINCODE_NAME}-${VERSION}@${FULLY_QUALIFIED_ORG_NAME}"
ORG_USERPASS="${CHAINCODE_NAME}-${VERSION}@${FULLY_QUALIFIED_ORG_NAME}-pw"

CA_ADMIN_USER="${ORG_NAME}-admin"
CA_ADMIN_PASS="${ORG_NAME}-adminpw"

fabric-ca-client enroll -d -u https://${CA_ADMIN_USER}:${CA_ADMIN_PASS}@${CA} --tls.certfiles ${ROOT_TLS_CERT} --home ${CAS_FOLDER}

# Checking if the user msp folder exists in the CA server	
if [ ! -d "${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}" ]; then # if user certificates do not exist

	## Register and enroll User for Org
	fabric-ca-client register -d --id.name ${ORG_USER} --id.secret ${ORG_USERPASS} --id.type ${ID_TYPE} --csr.names "${SUBJECT}" --tls.certfiles ${ROOT_TLS_CERT} --home ${CAS_FOLDER}

	# Enroll the registered user to generate enrollment certificate
	fabric-ca-client enroll -d -u https://${ORG_USER}:${ORG_USERPASS}@${CA} --csr.names "${SUBJECT}" --tls.certfiles ${ROOT_TLS_CERT} --home ${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}

	mkdir ${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}/msp/admincerts
	cp ${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}/msp/signcerts/* ${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}/msp/admincerts/${ORG_USER}-cert.pem

	mkdir -p ${ORG_CYPTO_FOLDER}/chaincodes/${ORG_USER}
	cp -R ${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}/msp ${ORG_CYPTO_FOLDER}/chaincodes/${ORG_USER}

	# Get TLS cert for user and copy to appropriate location
	fabric-ca-client enroll -d --enrollment.profile tls -u https://${ORG_USER}:${ORG_USERPASS}@${CA} -M ${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}/tls --tls.certfiles ${ROOT_TLS_CERT} --csr.hosts "${HOST}"

	# Copy the TLS key and cert to the appropriate place
	mkdir -p ${ORG_CYPTO_FOLDER}/chaincodes/${ORG_USER}/tls
	cp ${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}/tls/keystore/* ${ORG_CYPTO_FOLDER}/chaincodes/${ORG_USER}/tls/client.key
	cp ${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}/tls/signcerts/* ${ORG_CYPTO_FOLDER}/chaincodes/${ORG_USER}/tls/client.crt
	cp ${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}/tls/tlscacerts/* ${ORG_CYPTO_FOLDER}/chaincodes/${ORG_USER}/tls/ca.crt

else # If User certificate exists

	# Current datetime + 5 minutes | e.g. 20210302182036
	CUR_DATETIME=$(date -d "$(echo $(date)' + 5 minutes')" +'%Y%m%d%H%M%S')

	# Extracting "notAfter" datetime from the existing user certificate | e.g. 20210302182036
	CERT_DATETIME=$(date -d "$(echo $(openssl x509 -noout -enddate < ${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}/msp/signcerts/cert.pem) | sed 's/notAfter=//g')" +'%Y%m%d%H%M%S')

	# In case the certificate is expired or attrs key and value pairs do not match completly, generate a new certificate for the user
	if [ "${CUR_DATETIME}" -ge "$CERT_DATETIME" ]; then

		# Generate a new enrollment certificate
		fabric-ca-client enroll -d -u https://${ORG_USER}:${ORG_USERPASS}@${CA} --csr.names "${SUBJECT}" --tls.certfiles ${ROOT_TLS_CERT} --home ${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}

		cp ${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}/msp/signcerts/* ${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}/msp/admincerts/${ORG_USER}-cert.pem
		cp -R ${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}/msp ${ORG_CYPTO_FOLDER}/chaincodes/${ORG_USER}

		# Get TLS cert for user and copy to appropriate location
		fabric-ca-client enroll -d --enrollment.profile tls -u https://${ORG_USER}:${ORG_USERPASS}@${CA} -M ${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}/tls --tls.certfiles ${ROOT_TLS_CERT} --csr.hosts "${HOST}"

		# Copy the TLS key and cert to the appropriate place
		cp ${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}/tls/keystore/* ${ORG_CYPTO_FOLDER}/chaincodes/${ORG_USER}/tls/client.key
		cp ${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}/tls/signcerts/* ${ORG_CYPTO_FOLDER}/chaincodes/${ORG_USER}/tls/client.crt
		cp ${ORG_HOME}/chaincodes/${CHAINCODE_NAME}/v${VERSION}/tls/tlscacerts/* ${ORG_CYPTO_FOLDER}/chaincodes/${ORG_USER}/tls/ca.crt
	fi
fi