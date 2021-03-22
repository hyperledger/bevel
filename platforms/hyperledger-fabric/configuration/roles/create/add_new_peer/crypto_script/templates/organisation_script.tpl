#!/bin/bash

set -x

CURRENT_DIR=${PWD}
FULLY_QUALIFIED_ORG_NAME="{{ component_ns }}"
ALTERNATIVE_ORG_NAMES=("{{ component_ns }}.svc.cluster.local" "{{ component_name }}.net" "{{ component_ns }}.{{ item.external_url_suffix }}")
ORG_NAME="{{ component_name }}"
AFFILIATION="{{ component_name }}"
SUBJECT="C={{ component_country }},ST={{ component_state }},L={{ component_location }},O={{ component_name }}"
SUBJECT_PEER="{{ component_subject }}"
CA="{{ ca_url }}"
CA_ADMIN_USER="${ORG_NAME}-admin"
CA_ADMIN_PASS="${ORG_NAME}-adminpw"

ORG_ADMIN_USER="Admin@${FULLY_QUALIFIED_ORG_NAME}"
ORG_ADMIN_PASS="Admin@${FULLY_QUALIFIED_ORG_NAME}-pw"

ORG_CYPTO_FOLDER="/crypto-config/peerOrganizations/${FULLY_QUALIFIED_ORG_NAME}"

ROOT_TLS_CERT="/crypto-config/peerOrganizations/${FULLY_QUALIFIED_ORG_NAME}/ca/ca.${FULLY_QUALIFIED_ORG_NAME}-cert.pem"

CAS_FOLDER="${HOME}/ca-tools/cas/ca-${ORG_NAME}"
ORG_HOME="${HOME}/ca-tools/${ORG_NAME}"

NO_OF_PEERS={{ peer_count | e }}
NO_OF_NEW_PEERS={{ new_peer_count | e }}

# Copy exisitng org certs
cp ${ORG_CYPTO_FOLDER}/msp/cacerts/* ${ORG_CYPTO_FOLDER}/msp/tlscacerts

# Copy existing org certs
cp ${ORG_HOME}/admin/msp/signcerts/* ${ORG_CYPTO_FOLDER}/msp/admincerts/${ORG_ADMIN_USER}-cert.pem

# Copy existing org certs
cp ${ORG_HOME}/admin/msp/signcerts/* ${ORG_HOME}/admin/msp/admincerts/${ORG_ADMIN_USER}-cert.pem

# Copy existing org certs
cp -R ${ORG_HOME}/admin/msp ${ORG_CYPTO_FOLDER}/users/${ORG_ADMIN_USER}

# Copy the TLS key and cert to the appropriate place
cp ${ORG_HOME}/admin/tls/keystore/* ${ORG_CYPTO_FOLDER}/users/${ORG_ADMIN_USER}/tls/client.key
cp ${ORG_HOME}/admin/tls/signcerts/* ${ORG_CYPTO_FOLDER}/users/${ORG_ADMIN_USER}/tls/client.crt
cp ${ORG_HOME}/admin/tls/tlscacerts/* ${ORG_CYPTO_FOLDER}/users/${ORG_ADMIN_USER}/tls/ca.crt


## Register and enroll peers and populate their MSP folder
COUNTER=`expr ${NO_OF_PEERS} - ${NO_OF_NEW_PEERS}`
while [  ${COUNTER} -lt ${NO_OF_PEERS} ]; do
	PEER="peer${COUNTER}.${FULLY_QUALIFIED_ORG_NAME}"
	CSR_HOSTS=${PEER}
	for i in "${ALTERNATIVE_ORG_NAMES[@]}"
	do
		CSR_HOSTS="${CSR_HOSTS},peer${COUNTER}.${i}"
	done
	echo "Registering and enrolling $PEER with csr hosts ${CSR_HOSTS}"
	
	# Register the peer
	fabric-ca-client register -d --id.name ${PEER} --id.secret ${PEER}-pw --id.type peer --tls.certfiles ${ROOT_TLS_CERT} --home ${CAS_FOLDER}

	# Enroll to get peers TLS cert
	fabric-ca-client enroll -d --enrollment.profile tls -u https://${PEER}:${PEER}-pw@${CA} -M ${ORG_HOME}/cas/peers/tls --csr.hosts "${CSR_HOSTS}" --tls.certfiles ${ROOT_TLS_CERT}  --csr.names "${SUBJECT_PEER}"


	# Copy the TLS key and cert to the appropriate place
	mkdir -p ${ORG_CYPTO_FOLDER}/peers/${PEER}/tls
	cp ${ORG_HOME}/cas/peers/tls/keystore/* ${ORG_CYPTO_FOLDER}/peers/${PEER}/tls/server.key
	
	cp ${ORG_HOME}/cas/peers/tls/signcerts/* ${ORG_CYPTO_FOLDER}/peers/${PEER}/tls/server.crt
	
	cp ${ORG_HOME}/cas/peers/tls/tlscacerts/* ${ORG_CYPTO_FOLDER}/peers/${PEER}/tls/ca.crt
	
	rm -rf ${ORG_HOME}/cas/peers/tls
	
	# Enroll again to get the peer's enrollment certificate (default profile)
	fabric-ca-client enroll -d -u https://${PEER}:${PEER}-pw@${CA} -M ${ORG_CYPTO_FOLDER}/peers/${PEER}/msp --tls.certfiles ${ROOT_TLS_CERT}  --csr.names "${SUBJECT_PEER}"



	# Create the TLS CA directories of the MSP folder if they don't exist.
	mkdir ${ORG_CYPTO_FOLDER}/peers/${PEER}/msp/tlscacerts
	cp ${ORG_CYPTO_FOLDER}/peers/${PEER}/msp/cacerts/* ${ORG_CYPTO_FOLDER}/peers/${PEER}/msp/tlscacerts
	
	# Copy the peer org's admin cert into target MSP directory
	mkdir -p ${ORG_CYPTO_FOLDER}/peers/${PEER}/msp/admincerts
	
	cp ${ORG_CYPTO_FOLDER}/msp/admincerts/${ORG_ADMIN_USER}-cert.pem ${ORG_CYPTO_FOLDER}/peers/${PEER}/msp/admincerts
	
	let COUNTER=COUNTER+1
done

cd ${CURRENT_DIR}
