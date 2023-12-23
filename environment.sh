#!/bin/bash

source variables.sh

function set_load_test {
  DATABASE_PASSWORD=${LOAD_TEST_DATABASE_PASSWORD}
  DATABASE_HOST=${LOAD_TEST_DATABASE_HOST}
  DATABASE_USER=${LOAD_TEST_DATABASE_USER}
  DATABASE_K8S_KIND=deployment
  K8S_CONFIG=~/.kube/load-test
}

function set_integration_test {
  DATABASE_PASSWORD=${INTEGRATION_TEST_DATABASE_PASSWORD}
  DATABASE_HOST=${INTEGRATION_TEST_DATABASE_HOST}
  DATABASE_USER=${INTEGRATION_TEST_DATABASE_USER}
  DATABASE_K8S_KIND=statefulset
  K8S_CONFIG=~/.kube/integration-test
}

function set_local {
  DATABASE_PASSWORD=${LOCAL_DATABASE_PASSWORD}
  DATABASE_HOST=${LOCAL_DATABASE_HOST}
  DATABASE_USER=${LOCAL_DATABASE_USER}
  DATABASE_K8S_KIND=statefulset
  K8S_CONFIG=~/.kube/local
}

function set_environment {
  case "${K8S_CONFIG}" in
    *load*)
      set_load_test
      ;;
    *it*)
      set_integration_test
      ;;
    *local*)
      set_local
      ;;
    *)
      ;;
  esac
}