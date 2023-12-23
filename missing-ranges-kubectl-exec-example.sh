#!/bin/bash

source variables.sh
source environment.sh

function missing_ranges_kubectl_exec_example {
    set_environment
    kubectl --kubeconfig "${K8S_CONFIG}" -n "${NAMESPACE}" exec -i deployment/project -c project -- sh -c "wget -q -O- --method GET http://localhost:8080/users" | \
    grep -oE "email\"\s*:\s*\"${MISSING_RANGE_PREFIX}\d+" | \
    grep -oE "${MISSING_RANGE_PREFIX}\d+" | \
    grep -oE '\d+' | \
    sort | \
    tr '\n' ' ' | \
    sh missing-ranges.sh
}

missing_ranges_kubectl_exec_example