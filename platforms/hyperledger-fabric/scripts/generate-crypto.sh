#!/bin/bash
if [ $# -lt 6 ]; then
	echo "Usage : . generate-crypto.sh orderer|peer <namespace> <nodename> <no of peers: min 1> <affiliation> <subject> <external-url>"
	exit
fi
set -x
CURRENT_DIR=${PWD}
FULLY_QUALIFIED_ORG_NAME=$2
ALTERNATIVE_ORG_NAMES=()
ORG_NAME=$3
TYPE_FOLDER=$1s
NO_OF_PEERS=$4
AFFILIATION=$5
SUBJECT=$6
if [ "$1" = "orderer" ]; then
	ALTERNATIVE_ORG_NAMES=($2 "demo.fabric.blockchaincloudpoc.com")
else
	ALTERNATIVE_ORG_NAMES=($2 $2".demo.fabric.blockchaincloudpoc.com")
fi
CA="ca.${FULLY_QUALIFIED_ORG_NAME}:7054"
CA_ADMIN_USER="${FULLY_QUALIFIED_ORG_NAME}-admin"
CA_ADMIN_PASS="${FULLY_QUALIFIED_ORG_NAME}-adminpw"

ORG_ADMIN_USER="Admin@${FULLY_QUALIFIED_ORG_NAME}"
ORG_ADMIN_PASS="Admin@${FULLY_QUALIFIED_ORG_NAME}-pw"

ORG_CYPTO_FOLDER="/crypto-config/$1Organizations/${FULLY_QUALIFIED_ORG_NAME}"

ROOT_TLS_CERT="/crypto-config/$1Organizations/${FULLY_QUALIFIED_ORG_NAME}/ca/ca.${FULLY_QUALIFIED_ORG_NAME}-cert.pem"

CAS_FOLDER="${HOME}/ca-tools/cas/ca-${ORG_NAME}"
ORG_HOME="${HOME}/ca-tools/${ORG_NAME}"

## Enroll CA administrator for Org. This user will be used to create other identities
fabric-ca-client enroll -d -u https://${CA_ADMIN_USER}:${CA_ADMIN_PASS}@${CA} --tls.certfiles ${ROOT_TLS_CERT} --home ${CAS_FOLDER} --csr.names ${SUBJECT}

## Get the CA cert and store in Org MSP folder
fabric-ca-client getcacert -d -u https://${CA} --tls.certfiles ${ROOT_TLS_CERT} -M ${ORG_CYPTO_FOLDER}/msp
mkdir ${ORG_CYPTO_FOLDER}/msp/tlscacerts
cp ${ORG_CYPTO_FOLDER}/msp/cacerts/* ${ORG_CYPTO_FOLDER}/msp/tlscacerts

## Register and enroll admin for Org and populate admincerts for MSP
if [ "$1" = "peer" ]; then
	# Add affiliation for organisation
	fabric-ca-client affiliation add ${AFFILIATION} -u https://${CA_ADMIN_USER}:${CA_ADMIN_PASS}@${CA} --tls.certfiles ${ROOT_TLS_CERT} --home ${CAS_FOLDER}
	fabric-ca-client register -d --id.name ${ORG_ADMIN_USER} --id.secret ${ORG_ADMIN_PASS} --id.type admin --csr.names "${SUBJECT}" --id.affiliation ${AFFILIATION} --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.AffiliationMgr=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" --tls.certfiles ${ROOT_TLS_CERT} --home ${CAS_FOLDER}
	fabric-ca-client enroll -d -u https://${ORG_ADMIN_USER}:${ORG_ADMIN_PASS}@${CA} --csr.names "${SUBJECT}" --id.affiliation ${AFFILIATION} --tls.certfiles ${ROOT_TLS_CERT} --home ${ORG_HOME}/admin

else
	fabric-ca-client register -d --id.name ${ORG_ADMIN_USER} --id.secret ${ORG_ADMIN_PASS} --id.type admin --csr.names "${SUBJECT}" --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.AffiliationMgr=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" --tls.certfiles ${ROOT_TLS_CERT} --home ${CAS_FOLDER}
	fabric-ca-client enroll -d -u https://${ORG_ADMIN_USER}:${ORG_ADMIN_PASS}@${CA} --csr.names "${SUBJECT}" --tls.certfiles ${ROOT_TLS_CERT} --home ${ORG_HOME}/admin
fi

mkdir -p ${ORG_CYPTO_FOLDER}/msp/admincerts
cp ${ORG_HOME}/admin/msp/signcerts/* ${ORG_CYPTO_FOLDER}/msp/admincerts/${ORG_ADMIN_USER}-cert.pem

mkdir ${ORG_HOME}/admin/msp/admincerts
cp ${ORG_HOME}/admin/msp/signcerts/* ${ORG_HOME}/admin/msp/admincerts/${ORG_ADMIN_USER}-cert.pem

mkdir -p ${ORG_CYPTO_FOLDER}/users/${ORG_ADMIN_USER}
cp -R ${ORG_HOME}/admin/msp ${ORG_CYPTO_FOLDER}/users/${ORG_ADMIN_USER}

# Get TLS cert for admin and copy to appropriate location
fabric-ca-client enroll -d --enrollment.profile tls -u https://${ORG_ADMIN_USER}:${ORG_ADMIN_PASS}@${CA} -M ${ORG_HOME}/admin/tls --tls.certfiles ${ROOT_TLS_CERT} --csr.names "${SUBJECT}"

# Copy the TLS key and cert to the appropriate place
mkdir -p ${ORG_CYPTO_FOLDER}/users/${ORG_ADMIN_USER}/tls
cp ${ORG_HOME}/admin/tls/keystore/* ${ORG_CYPTO_FOLDER}/users/${ORG_ADMIN_USER}/tls/client.key
cp ${ORG_HOME}/admin/tls/signcerts/* ${ORG_CYPTO_FOLDER}/users/${ORG_ADMIN_USER}/tls/client.crt
cp ${ORG_HOME}/admin/tls/tlscacerts/* ${ORG_CYPTO_FOLDER}/users/${ORG_ADMIN_USER}/tls/ca.crt

## Register and enroll peers and populate their MSP folder
COUNTER=0
while [ ${COUNTER} -lt ${NO_OF_PEERS} ] && [ "$1" = "peer" ]; do
	PEER="$1${COUNTER}.${FULLY_QUALIFIED_ORG_NAME}"
	CSR_HOSTS=${PEER}
	for j in "${ALTERNATIVE_ORG_NAMES[@]}"; do
		CSR_HOSTS="${CSR_HOSTS},$1${COUNTER}.${j}"
	done
	echo "Registering and enrolling $PEER with csr hosts ${CSR_HOSTS}"

	# Register the peer
	fabric-ca-client register -d --id.name ${PEER} --id.secret ${PEER}-pw --id.type peer --tls.certfiles ${ROOT_TLS_CERT} --home ${CAS_FOLDER}

	# Enroll to get peers TLS cert
	fabric-ca-client enroll -d --enrollment.profile tls -u https://${PEER}:${PEER}-pw@${CA} -M ${ORG_HOME}/cas/${TYPE_FOLDER}/tls --csr.hosts "${CSR_HOSTS}" --tls.certfiles ${ROOT_TLS_CERT}

	# Copy the TLS key and cert to the appropriate place
	mkdir -p ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/tls
	cp ${ORG_HOME}/cas/${TYPE_FOLDER}/tls/keystore/* ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/tls/server.key

	cp ${ORG_HOME}/cas/${TYPE_FOLDER}/tls/signcerts/* ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/tls/server.crt

	cp ${ORG_HOME}/cas/${TYPE_FOLDER}/tls/tlscacerts/* ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/tls/ca.crt

	rm -rf ${ORG_HOME}/cas/${TYPE_FOLDER}/tls

	# Enroll again to get the peer's enrollment certificate (default profile)
	fabric-ca-client enroll -d -u https://${PEER}:${PEER}-pw@${CA} -M ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/msp --tls.certfiles ${ROOT_TLS_CERT}

	# Create the TLS CA directories of the MSP folder if they don't exist.
	mkdir ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/msp/tlscacerts
	cp ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/msp/cacerts/* ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/msp/tlscacerts

	# Copy the peer org's admin cert into target MSP directory
	mkdir -p ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/msp/admincerts

	cp ${ORG_CYPTO_FOLDER}/msp/admincerts/${ORG_ADMIN_USER}-cert.pem ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/msp/admincerts

	let COUNTER=COUNTER+1
done

while [ ${COUNTER} -lt ${NO_OF_PEERS} ] && [ "$1" != "peer" ]; do
	PEER="$1.${FULLY_QUALIFIED_ORG_NAME}"
	CSR_HOSTS=${PEER}
	for j in "${ALTERNATIVE_ORG_NAMES[@]}"; do
		CSR_HOSTS="${CSR_HOSTS},$1.${j}"
	done
	echo "Registering and enrolling $PEER with csr hosts ${CSR_HOSTS}"

	# Register the peer
	fabric-ca-client register -d --id.name ${PEER} --id.secret ${PEER}-pw --id.type peer --tls.certfiles ${ROOT_TLS_CERT} --home ${CAS_FOLDER}

	# Enroll to get peers TLS cert
	fabric-ca-client enroll -d --enrollment.profile tls -u https://${PEER}:${PEER}-pw@${CA} -M ${ORG_HOME}/cas/${TYPE_FOLDER}/tls --csr.hosts "${CSR_HOSTS}" --tls.certfiles ${ROOT_TLS_CERT}

	# Copy the TLS key and cert to the appropriate place
	mkdir -p ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/tls
	cp ${ORG_HOME}/cas/${TYPE_FOLDER}/tls/keystore/* ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/tls/server.key

	cp ${ORG_HOME}/cas/${TYPE_FOLDER}/tls/signcerts/* ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/tls/server.crt

	cp ${ORG_HOME}/cas/${TYPE_FOLDER}/tls/tlscacerts/* ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/tls/ca.crt

	rm -rf ${ORG_HOME}/cas/${TYPE_FOLDER}/tls

	# Enroll again to get the peer's enrollment certificate (default profile)
	fabric-ca-client enroll -d -u https://${PEER}:${PEER}-pw@${CA} -M ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/msp --tls.certfiles ${ROOT_TLS_CERT}

	# Create the TLS CA directories of the MSP folder if they don't exist.
	mkdir ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/msp/tlscacerts
	cp ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/msp/cacerts/* ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/msp/tlscacerts

	# Copy the peer org's admin cert into target MSP directory
	mkdir -p ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/msp/admincerts

	cp ${ORG_CYPTO_FOLDER}/msp/admincerts/${ORG_ADMIN_USER}-cert.pem ${ORG_CYPTO_FOLDER}/${TYPE_FOLDER}/${PEER}/msp/admincerts

	let COUNTER=COUNTER+1
done

cd ${CURRENT_DIR}
