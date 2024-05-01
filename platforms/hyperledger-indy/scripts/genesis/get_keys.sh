#!/bin/bash
FILES_DIR=../../charts/indy-genesis/files
kubectl --namespace authority-ns get secret authority-trustee-identity-public -o jsonpath='{.data.value}' | base64 -d | jq '.["did"]'> $FILES_DIR/authority-trustee-did.json
kubectl --namespace authority-ns get secret authority-trustee-node-public-verif-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["verification-key"]' > $FILES_DIR/authority-trustee-verkey.json

kubectl --namespace university-ns get secret university-steward-1-identity-public -o jsonpath='{.data.value}' | base64 -d | jq '.["did"]'> $FILES_DIR/university-steward-1-did.json
kubectl --namespace university-ns get secret university-steward-1-node-public-verif-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["verification-key"]' > $FILES_DIR/university-steward-1-verkey.json
kubectl --namespace university-ns get secret university-steward-1-node-public-bls-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["bls-key-pop"]' > $FILES_DIR/university-steward-1-blspop.json
kubectl --namespace university-ns get secret university-steward-1-node-public-bls-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["bls-public-key"]' > $FILES_DIR/university-steward-1-blspub.json

kubectl --namespace university-ns get secret university-steward-2-identity-public -o jsonpath='{.data.value}' | base64 -d | jq '.["did"]'> $FILES_DIR/university-steward-2-did.json
kubectl --namespace university-ns get secret university-steward-2-node-public-verif-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["verification-key"]' > $FILES_DIR/university-steward-2-verkey.json
kubectl --namespace university-ns get secret university-steward-2-node-public-bls-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["bls-key-pop"]' > $FILES_DIR/university-steward-2-blspop.json
kubectl --namespace university-ns get secret university-steward-2-node-public-bls-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["bls-public-key"]' > $FILES_DIR/university-steward-2-blspub.json

kubectl --namespace university-ns get secret university-steward-3-identity-public -o jsonpath='{.data.value}' | base64 -d | jq '.["did"]'> $FILES_DIR/university-steward-3-did.json
kubectl --namespace university-ns get secret university-steward-3-node-public-verif-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["verification-key"]' > $FILES_DIR/university-steward-3-verkey.json
kubectl --namespace university-ns get secret university-steward-3-node-public-bls-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["bls-key-pop"]' > $FILES_DIR/university-steward-3-blspop.json
kubectl --namespace university-ns get secret university-steward-3-node-public-bls-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["bls-public-key"]' > $FILES_DIR/university-steward-3-blspub.json

kubectl --namespace university-ns get secret university-steward-4-identity-public -o jsonpath='{.data.value}' | base64 -d | jq '.["did"]'> $FILES_DIR/university-steward-4-did.json
kubectl --namespace university-ns get secret university-steward-4-node-public-verif-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["verification-key"]' > $FILES_DIR/university-steward-4-verkey.json
kubectl --namespace university-ns get secret university-steward-4-node-public-bls-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["bls-key-pop"]' > $FILES_DIR/university-steward-4-blspop.json
kubectl --namespace university-ns get secret university-steward-4-node-public-bls-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["bls-public-key"]' > $FILES_DIR/university-steward-4-blspub.json

# Sample below for employer option
# kubectl --namespace employer-ns get secret employer-trustee-identity-public -o jsonpath='{.data.value}' | base64 -d | jq '.["did"]'> $FILES_DIR/employer-trustee-did.json
# kubectl --namespace employer-ns get secret employer-trustee-node-public-verif-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["verification-key"]' > $FILES_DIR/employer-trustee-verkey.json

# kubectl --namespace employer-ns get secret employer-steward-1-identity-public -o jsonpath='{.data.value}' | base64 -d | jq '.["did"]'> $FILES_DIR/employer-steward-1-did.json
# kubectl --namespace employer-ns get secret employer-steward-1-node-public-verif-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["verification-key"]' > $FILES_DIR/employer-steward-1-verkey.json
# kubectl --namespace employer-ns get secret employer-steward-1-node-public-bls-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["bls-key-pop"]' > $FILES_DIR/employer-steward-1-blspop.json
# kubectl --namespace employer-ns get secret employer-steward-1-node-public-bls-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["bls-public-key"]' > $FILES_DIR/employer-steward-1-blspub.json
