#!/bin/bash

source variables.sh
source environment.sh

function missing_ranges_sql_example {
    set_environment
    kubectl --kubeconfig "${K8S_CONFIG}" -n "${NAMESPACE}" exec -i "${DATABASE_K8S_KIND}"/mysql -c mysql -- sh -c "MYSQL_PWD='${DATABASE_PASSWORD}' mysql -t -h '${DATABASE_HOST}' --user='${DATABASE_USER}' -e \"
        SELECT email 
        FROM project.users u
        WHERE u.status = 'ACTIVE' 
        ORDER BY 1;
    \"" | \
    grep -oE "${MISSING_RANGE_PREFIX}\d+" | \
    grep -oE '\d+' | \
    sort | \
    tr '\n' ' ' | \
    sh missing-ranges.sh
}

missing_ranges_sql_example