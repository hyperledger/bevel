#!/bin/bash
if [ $# -lt 7 ]; then
	echo "Usage : . $0 orderer|peer <namespace> <nodename> <user-identities> <affiliation> <subject> <ca-server-url>"
	exit
fi

set -x

CURRENT_DIR=${PWD}

# Input parameters
FULLY_QUALIFIED_ORG_NAME=$2
ORG_NAME=$3
TYPE_FOLDER=$1s
USER_IDENTITIES=$4
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
CUR_USER=0
TOTAL_USERS=$(echo ${USER_IDENTITIES} | base64 -d | sed -e 's/None/null/g' | tr "'" '"' | jq '. | length')
while [ ${CUR_USER} -lt ${TOTAL_USERS} ]; do
	
	# Get the user identity
	USER=$(echo ${USER_IDENTITIES} | base64 -d | sed -e 's/None/null/g' | tr "'" '"' | jq '.['${CUR_USER}'].identity' | sed -e 's/"//g')
	ORG_USER="${USER}@${FULLY_QUALIFIED_ORG_NAME}"
	ORG_USERPASS="${USER}@${FULLY_QUALIFIED_ORG_NAME}-pw"
	ADMIN_USER="Admin@${FULLY_QUALIFIED_ORG_NAME}"
	ADMIN_USERPASS="Admin@${FULLY_QUALIFIED_ORG_NAME}-pw"

	# Creating current user's current attrs string to pass in as argument while registering/updating identity
	CUR_ATTRS=0
	ATTRS="hf.Revoker=true"
	TOTAL_ATTRS=$(echo ${USER_IDENTITIES} | base64 -d | sed -e 's/None/null/g' | tr "'" '"' | jq '.['${CUR_USER}'].attributes | length')
	while [ ${CUR_ATTRS} -lt ${TOTAL_ATTRS} ]; do
		ATTRS=${ATTRS}","$(echo ${USER_IDENTITIES} | base64 -d | sed -e 's/None/null/g' | tr "'" '"' | jq '.['${CUR_USER}'].attributes['${CUR_ATTRS}'].key' | sed -e 's/"//g')"="$(echo ${USER_IDENTITIES} | base64 -d | sed -e 's/None/null/g' | tr "'" '"' | jq '.['${CUR_USER}'].attributes['${CUR_ATTRS}'].value' | sed -e 's/"//g')":ecert"
		CUR_ATTRS=$((CUR_ATTRS + 1))
	done

	# Checking if the user msp folder exists in the CA server	
	if [ ! -d "${ORG_HOME}/client${USER}" ]; then # if user certificates do not exist

		## Register and enroll User for Org
		if [ "$1" = "peer" ]; then
			fabric-ca-client register -d --id.name ${ORG_USER} --id.secret ${ORG_USERPASS} --id.type client --csr.names "${SUBJECT}" --id.affiliation ${AFFILIATION} --id.attrs "${ATTRS}" --tls.certfiles ${ROOT_TLS_CERT} --home ${CAS_FOLDER}
		else
			fabric-ca-client register -d --id.name ${ORG_USER} --id.secret ${ORG_USERPASS} --id.type client --csr.names "${SUBJECT}" --id.attrs "${ATTRS}" --tls.certfiles ${ROOT_TLS_CERT} --home ${CAS_FOLDER}
		fi

		# Enroll the registered user to generate enrollment certificate
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
	
	else # If User certificate exists
		
		# Current datetime + 5 minutes | e.g. 20210302182036
		CUR_DATETIME=$(date -d "$(echo $(date)' + 5 minutes')" +'%Y%m%d%H%M%S')
		
		# Extracting "notAfter" datetime from the existing user certificate | e.g. 20210302182036
		CERT_DATETIME=$(date -d "$(echo $(openssl x509 -noout -enddate < ${ORG_HOME}/client${USER}/msp/signcerts/cert.pem) | sed 's/notAfter=//g')" +'%Y%m%d%H%M%S')

		# Extracting the list of custom attrs from existing user certificate
		ATTRS_CERT="$(openssl x509 -text -noout -certopt no_subject,no_header,no_version,no_serial,no_signame,no_validity,no_issuer,no_pubkey,no_sigdump,no_aux < ${ORG_HOME}/client${USER}/msp/signcerts/cert.pem )"
		ATTRS_CERT="${ATTRS_CERT##*: }" # extracing the "attrs" JSON string
		
		# Check if the current list of attrs key and value pairs match with existing user certificate's attrs key and value pairs
		CUR_ATTRS=0
		MATCH_FLAG="true"
		while [ ${CUR_ATTRS} -lt ${TOTAL_ATTRS} ]; do
			CUR_KEY=$(echo ${USER_IDENTITIES} | base64 -d | sed -e 's/None/null/g' | tr "'" '"' | jq '.['${CUR_USER}'].attributes['${CUR_ATTRS}'].key' | sed -e 's/"//g')
			if [[ "$(echo ${ATTRS_CERT} | jq .attrs.${CUR_KEY} )" == "null" ]]; then
				MATCH_FLAG="false"
			fi
			CUR_ATTRS=$((CUR_ATTRS + 1))
		done

		# In case the certificate is expired or attrs key and value pairs do not match completly, generate a new certificate for the user
		if [ "${CUR_DATETIME}" -ge "$CERT_DATETIME" ] ||  [ "$MATCH_FLAG" == "false" ]; then

			# Checking the validity of each attrs key and value pair, such that only the current list of attrs reflect in the new certificate
			# whereas the other non-required attrs key and value pairs do not reflect on the new certificate
			TOTAL_CERT_ATTRS=$(echo ${ATTRS_CERT} | jq '.attrs | length' )
			CUR_CERT_ATTRS=0
			while [ ${CUR_CERT_ATTRS} -lt ${TOTAL_CERT_ATTRS} ]; do
				
				# Since Fabric-CA puts three default key-value pairs, this check is to avoid them to enter the processing
				if [ "$(echo ${ATTRS_CERT} | jq '.attrs | to_entries | .['${CUR_CERT_ATTRS}'].key' | sed -e 's/"//g')" != "hf.Affiliation" ] && [ "$(echo ${ATTRS_CERT} | jq '.attrs | to_entries | .['${CUR_CERT_ATTRS}'].key' | sed -e 's/"//g')" != "hf.Type" ] && [ "$(echo ${ATTRS_CERT} | jq '.attrs | to_entries | .['${CUR_CERT_ATTRS}'].key' | sed -e 's/"//g')" != "hf.EnrollmentID" ]; then
					
					# For each attrs key in the existing certificate checking if they exist in the current attrs list
					KEY_PRESENT="false"
					CUR_ATTRS=0
					while [ ${CUR_ATTRS} -lt ${TOTAL_ATTRS} ]; do
						if [ "$(echo ${ATTRS_CERT} | jq '.attrs | to_entries | .['${CUR_CERT_ATTRS}'].key' | sed -e 's/"//g')" == "$(echo ${USER_IDENTITIES} | base64 -d | sed -e 's/None/null/g' | tr "'" '"' | jq '.['${CUR_USER}'].attributes['${CUR_ATTRS}'].key' | sed -e 's/"//g')" ]; then
							KEY_PRESENT="true"
						fi
						CUR_ATTRS=$((CUR_ATTRS + 1))
					done

					# If the key is not present then, add it to the ${ATTRS} string without the 'ecert' flag, such that is doesnot appear on the new certificate
					if [ "${KEY_PRESENT}" == "false" ]; then
						ATTRS=${ATTRS}","$(echo ${ATTRS_CERT} | jq '.attrs | to_entries | .['${CUR_CERT_ATTRS}'].key' | sed -e 's/"//g')"="$(echo ${ATTRS_CERT} | jq '.attrs | to_entries | .['${CUR_CERT_ATTRS}'].value' | sed -e 's/"//g')
					fi
				
				fi
				CUR_CERT_ATTRS=$((CUR_CERT_ATTRS + 1))
			done
			
			# Updating the identity with current attrs
			fabric-ca-client identity modify ${ORG_USER} -d --type user --affiliation ${AFFILIATION} --attrs "${ATTRS}" --tls.certfiles ${ROOT_TLS_CERT} --home ${CAS_FOLDER}

			# Generate a new enrollment certificate
			fabric-ca-client enroll -d -u https://${ORG_USER}:${ORG_USERPASS}@${CA} --csr.names "${SUBJECT}" --tls.certfiles ${ROOT_TLS_CERT} --home ${ORG_HOME}/client${USER}
			
			cp ${ORG_HOME}/client${USER}/msp/signcerts/* ${ORG_HOME}/client${USER}/msp/admincerts/${ORG_USER}-cert.pem
			cp -R ${ORG_HOME}/client${USER}/msp ${ORG_CYPTO_FOLDER}/users/${ORG_USER}

			# Get TLS cert for user and copy to appropriate location
			fabric-ca-client enroll -d --enrollment.profile tls -u https://${ORG_USER}:${ORG_USERPASS}@${CA} -M ${ORG_HOME}/client${USER}/tls --tls.certfiles ${ROOT_TLS_CERT}

			# Copy the TLS key and cert to the appropriate place
			cp ${ORG_HOME}/client${USER}/tls/keystore/* ${ORG_CYPTO_FOLDER}/users/${ORG_USER}/tls/client.key
			cp ${ORG_HOME}/client${USER}/tls/signcerts/* ${ORG_CYPTO_FOLDER}/users/${ORG_USER}/tls/client.crt
			cp ${ORG_HOME}/client${USER}/tls/tlscacerts/* ${ORG_CYPTO_FOLDER}/users/${ORG_USER}/tls/ca.crt
		fi
	fi

	CUR_USER=$((CUR_USER + 1))
done
cd ${CURRENT_DIR}
