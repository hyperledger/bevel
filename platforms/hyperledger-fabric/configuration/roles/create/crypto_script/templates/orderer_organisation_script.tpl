#!/bin/bash

set -x

CURRENT_DIR=${PWD}
FULLY_QUALIFIED_ORG_NAME="{{ component_ns }}"
EXTERNAL_URL_SUFFIX="{{ item.external_url_suffix }}"
ALTERNATIVE_ORG_NAMES=("{{ item.external_url_suffix }}")
ORG_NAME="{{ component_name }}"
SUBJECT="C={{ component_country }},ST={{ component_state }},L={{ component_location }},O={{ component_name }}"
SUBJECT_PEER="{{ component_subject }}"
CA="{{ ca_url }}"
CA_ADMIN_USER="${ORG_NAME}-admin"
CA_ADMIN_PASS="${ORG_NAME}-adminpw"

ORG_ADMIN_USER="Admin@${FULLY_QUALIFIED_ORG_NAME}"
ORG_ADMIN_PASS="Admin@${FULLY_QUALIFIED_ORG_NAME}-pw"

ORG_CYPTO_FOLDER="/crypto-config/ordererOrganizations/${FULLY_QUALIFIED_ORG_NAME}"

ROOT_TLS_CERT="/crypto-config/ordererOrganizations/${FULLY_QUALIFIED_ORG_NAME}/ca/ca.${FULLY_QUALIFIED_ORG_NAME}-cert.pem"

CAS_FOLDER="${HOME}/ca-tools/cas/ca-${ORG_NAME}"
ORG_HOME="${HOME}/ca-tools/${ORG_NAME}"

## Enroll CA administrator for Org. This user will be used to create other identities
fabric-ca-client enroll -d -u https://${CA_ADMIN_USER}:${CA_ADMIN_PASS}@${CA} --tls.certfiles  ${ROOT_TLS_CERT} --home ${CAS_FOLDER} --csr.names "${SUBJECT_PEER}"

## Get the CA cert and store in Org MSP folder
fabric-ca-client getcacert -d -u https://${CA} --tls.certfiles ${ROOT_TLS_CERT} -M ${ORG_CYPTO_FOLDER}/msp

if [ "{{ proxy }}" != "none" ]; then
    mv ${ORG_CYPTO_FOLDER}/msp/cacerts/*.pem ${ORG_CYPTO_FOLDER}/msp/cacerts/ca-${FULLY_QUALIFIED_ORG_NAME}-${EXTERNAL_URL_SUFFIX}-8443.pem
fi
mkdir ${ORG_CYPTO_FOLDER}/msp/tlscacerts
cp ${ORG_CYPTO_FOLDER}/msp/cacerts/* ${ORG_CYPTO_FOLDER}/msp/tlscacerts

## Register and enroll admin for Org and populate admincerts for MSP
fabric-ca-client register -d --id.name ${ORG_ADMIN_USER} --id.secret ${ORG_ADMIN_PASS} --id.type admin --csr.names "${SUBJECT_PEER}" --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.AffiliationMgr=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" --tls.certfiles ${ROOT_TLS_CERT} --home ${CAS_FOLDER}

fabric-ca-client enroll -d -u https://${ORG_ADMIN_USER}:${ORG_ADMIN_PASS}@${CA} --tls.certfiles ${ROOT_TLS_CERT} --home ${ORG_HOME}/admin --csr.names "${SUBJECT_PEER}"

mkdir -p ${ORG_CYPTO_FOLDER}/msp/admincerts
cp ${ORG_HOME}/admin/msp/signcerts/* ${ORG_CYPTO_FOLDER}/msp/admincerts/${ORG_ADMIN_USER}-cert.pem

mkdir ${ORG_HOME}/admin/msp/admincerts
cp ${ORG_HOME}/admin/msp/signcerts/* ${ORG_HOME}/admin/msp/admincerts/${ORG_ADMIN_USER}-cert.pem

mkdir -p ${ORG_CYPTO_FOLDER}/users/${ORG_ADMIN_USER}
cp -R ${ORG_HOME}/admin/msp ${ORG_CYPTO_FOLDER}/users/${ORG_ADMIN_USER}

if [ "{{ proxy }}" != "none" ]; then
    mv ${ORG_CYPTO_FOLDER}/users/${ORG_ADMIN_USER}/msp/cacerts/*.pem ${ORG_CYPTO_FOLDER}/users/${ORG_ADMIN_USER}/msp/cacerts/ca-${FULLY_QUALIFIED_ORG_NAME}-${EXTERNAL_URL_SUFFIX}-8443.pem
fi

# Get TLS cert for admin and copy to appropriate location
fabric-ca-client enroll -d --enrollment.profile tls -u https://${ORG_ADMIN_USER}:${ORG_ADMIN_PASS}@${CA} -M ${ORG_HOME}/admin/tls --tls.certfiles ${ROOT_TLS_CERT}  --csr.names "${SUBJECT_PEER}"

# Copy the TLS key and cert to the appropriate place
mkdir -p ${ORG_CYPTO_FOLDER}/users/${ORG_ADMIN_USER}/tls
cp ${ORG_HOME}/admin/tls/keystore/* ${ORG_CYPTO_FOLDER}/users/${ORG_ADMIN_USER}/tls/client.key
cp ${ORG_HOME}/admin/tls/signcerts/* ${ORG_CYPTO_FOLDER}/users/${ORG_ADMIN_USER}/tls/client.crt
cp ${ORG_HOME}/admin/tls/tlscacerts/* ${ORG_CYPTO_FOLDER}/users/${ORG_ADMIN_USER}/tls/ca.crt

cd ${CURRENT_DIR}
