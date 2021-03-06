#!/usr/bin/env bash

echo ${PLUGIN_KEYFILE} > /keyfile.json

set -a

if [ -f "${PWD}/${PLUGIN_ADDTL_ENV_VARS}" ]; then
  source ${PWD}/${PLUGIN_ADDTL_ENV_VARS}
  echo "Imported additional environment variables from ${PWD}/${PLUGIN_ADDTL_ENV_VARS}"
fi

gcloud auth activate-service-account --key-file=/keyfile.json --project=${PLUGIN_PROJECT}

if [ "$PLUGIN_STATE" == "latest" ]; then
	if gcloud deployment-manager deployments list | grep -q "${PLUGIN_DEPLOYMENT} "; then
	  gcloud deployment-manager deployments update ${PLUGIN_DEPLOYMENT} --config=${PLUGIN_CONFIG}
	else
	  gcloud deployment-manager deployments create ${PLUGIN_DEPLOYMENT} --config=${PLUGIN_CONFIG} --automatic-rollback-on-error
	fi
fi

if [ "$PLUGIN_STATE" == "absent" ]; then
	if gcloud deployment-manager deployments list | grep -q "${PLUGIN_DEPLOYMENT} "; then
	  gcloud deployment-manager deployments delete ${PLUGIN_DEPLOYMENT} -q
	fi
fi

exit
