#!/bin/bash

# Variables
NEW_SA_NAME="kubecost-cost-analyzer"

# Get the pod name using kubectl
POD_NAME=$(kubectl -n kubecost get pods -o=jsonpath='{.items[0].metadata.name}')

if [ -n "${POD_NAME}" ]; then
  # Get the current service account of the pod
  CURRENT_SA=$(kubectl -n kubecost get pod ${POD_NAME} -o=jsonpath='{.spec.serviceAccountName}')

  if [ "${CURRENT_SA}" != "${NEW_SA_NAME}" ]; then
    # Update the running pod with the new service account
    kubectl -n kubecost patch pod ${POD_NAME} -p "{\"spec\": {\"serviceAccountName\": \"${NEW_SA_NAME}\"}}"

    # Delete the pod to trigger a refresh with the new service account
    kubectl -n kubecost delete pod ${POD_NAME}
  else
    echo "Pod already using the desired service account"
  fi
else
  echo "No pods found in the kubecost namespace"
fi
