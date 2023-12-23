#!/bin/bash

source variables.sh
source environment.sh

function delete_namespaces {
    set -eu
    set_environment
    local name_prefix=${1}
	local range_start=${2}
	local range_end=${3}
    local name_filling=${4}
	local name_final_length=${5}
    local i
    for i in $(seq ${range_start} ${range_end})
    do
        local name=`printf "%${name_filling}${name_final_length}d" "${i}"`
        name=`echo "${name_prefix}${name}"`
        kubectl --kubeconfig "${K8S_CONFIG}" -n ${name} delete --all all --ignore-not-found
        kubectl --kubeconfig "${K8S_CONFIG}" delete ns ${name} --ignore-not-found
    done    
}

#sh delete_namespaces.sh 'test-ns-' 0 9 0 3
#sh delete_namespaces.sh 'test-ns-' 10 19 0 3
#sh delete_namespaces.sh 'test-ns-' 20 29 0 3
delete_namespaces ${1} ${2} ${3} ${4} ${5}