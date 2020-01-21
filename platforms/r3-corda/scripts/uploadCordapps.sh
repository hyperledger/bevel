#!/bin/bash
# Copies the cordapps from path specified
# to the corda node specified in input

# Check if sufficient arguments are provided by user
if [[ $# != 4 ]]; then
  echo "Error! Please specify the target node, namespace, kubernetes-config and cordapps build path as arguments respectively"
  echo "E.g sh uploadCordapps.sh manufacturer manufacturer-ns /home/kube.yaml /home/supplychain/build"
  exit 0
else
  echo "Uploading cordapps for - "$1
  # Check if second argument is the path to a valid directory
  # If not, exit with error
  if [ -d $4 ]; then
    echo "Listing cordapps: "
    ls -l $4/*.jar
  else
    echo "Error! Cordapps Directory does not exist. Please provide a valid cordapp directory"
    exit 0
  fi
  # Get the pod-id for the Corda node with app name selector
  echo "Getting pod-id for node"
  podid=`KUBECONFIG=$3 kubectl get po --selector=app=$1 -n $2 -o name | cut -d'/' -f2`
  echo "pod id = "$podid
  # check if a valid podid is returned.
  # podid would be emplty string if no resource is found
  if [[ "$podid" = "" ]]; then
  # Error if pod with given name not found
    echo "Error! No '$1' node found..."
    exit 0
  fi
  # iterate through jar files present in /base/corda/cordapps path
  for cordapp in $4/*.jar; do
    KUBECONFIG=$3 kubectl cp $cordapp $2/${podid}:/base/corda/cordapps
    echo "$cordapp copied to node." 
  done
  # check if all files have been copied
  KUBECONFIG=$3 kubectl -n $2 exec ${podid} -- ls -ltr /base/corda/cordapps
  # restart the pod by deleting it
  KUBECONFIG=$3 kubectl -n $2 delete pod ${podid}
fi