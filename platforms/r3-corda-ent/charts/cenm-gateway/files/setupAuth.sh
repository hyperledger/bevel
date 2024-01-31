#!/bin/sh
# log in and cache access token
ACCESS_TOKEN=""
while [ -z "${ACCESS_TOKEN}" ]
do
    TOKEN_RESPONSE="$(curl -X POST --data "grant_type=password" --data "username=admin" --data "password=p4ssWord" http://${1}:${2}/api/v1/authentication/authenticate)"
    ACCESS_TOKEN="$(echo ${TOKEN_RESPONSE} | jq -r '.access_token')"
    sleep 5
done

pwd
ls -alR

echo
echo "========================= Creating users ========================="
for i in u/*.json
do
    echo
    echo ">>>>>>>> User: ${i}"
    cat ${i}; echo
    curl -X POST -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" --data-binary "@${i}" http://${1}:${2}/api/v1/admin/users
    echo
done

echo
echo "========================= Creating groups ========================="
for i in g/*.json
do
    echo
    echo ">>>>>>>> Group: ${i}"
    cat ${i}; echo
    curl -X POST -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" --data-binary "@${i}" http://${1}:${2}/api/v1/admin/groups
    echo
done

echo
echo "========================= Assigning roles to groups ========================="
for role in "CASigner" "ConfigurationMaintainer" "ConfigurationReader" "NetworkMaintainer" "NetworkOperator" "NetworkOperationsReader" "NonCASigner"; do
 file='./r/'$role'.json'
 echo
 echo ">>>>>>>> Role: ${file}"
 cat ${file}; echo
 curl -X PATCH -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/merge-patch+json" --data-binary "@${file}" http://${1}:${2}/api/v1/admin/roles/${role}
 echo
done
