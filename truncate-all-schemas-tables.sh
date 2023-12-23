#!/bin/bash

source variables.sh
source environment.sh

function truncate_all_schemas_tables {
    set_environment
    local schemas
    local tables
    schemas=$(kubectl --kubeconfig "${K8S_CONFIG}" -n "${NAMESPACE}" exec -i "${DATABASE_K8S_KIND}"/mysql -c mysql -- sh -c "MYSQL_PWD='${DATABASE_PASSWORD}' mysql -h '${DATABASE_HOST}' --user='${DATABASE_USER}' -e \"SHOW SCHEMAS;\"" | tail -n +2 | grep -Ev 'information_schema|innodb|mysql|performance_schema|sys|tmp')
    schemas=(${schemas})
    for schema in "${schemas[@]}"
    do
        tables=$(kubectl --kubeconfig "${K8S_CONFIG}" -n "${NAMESPACE}" exec -i "${DATABASE_K8S_KIND}"/mysql -c mysql -- sh -c "MYSQL_PWD='${DATABASE_PASSWORD}' mysql -h '${DATABASE_HOST}' --user='${DATABASE_USER}' -e \"USE ${schema}; SHOW TABLES;\"" | tail -n +2 | grep -Ev 'DATABASECHANGELOG|DATABASECHANGELOGLOCK' | sed s/^/TRUNCATE\ TABLE\ /g | sed s/$/\;/g | tr '\n' ' ')
        if [ -n "${tables}" ]
        then
            echo "truncating all ${schema} schema tables"
            kubectl --kubeconfig "${K8S_CONFIG}" -n "${NAMESPACE}" exec -i "${DATABASE_K8S_KIND}"/mysql -c mysql -- sh -c "MYSQL_PWD='${DATABASE_PASSWORD}' mysql -h '${DATABASE_HOST}' --user='${DATABASE_USER}' -e \"USE ${schema}; SET FOREIGN_KEY_CHECKS = 0; ${tables} SET FOREIGN_KEY_CHECKS = 1;\""
        fi
    done
}

truncate_all_schemas_tables
