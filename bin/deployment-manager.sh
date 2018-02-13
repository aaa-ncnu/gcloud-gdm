#!/usr/bin/env bash

echo ${PLUGIN_KEYFILE} > /keyfile.json

gcloud auth activate-service-account --key-file=/keyfile.json --project=${PLUGIN_PROJECT}

if [ "$PLUGIN_STATE" == "latest" ]; then
	if gcloud deployment-manager deployments list | grep -q "${PLUGIN_DEPLOYMENT} "; then
	  gcloud deployment-manager deployments update ${PLUGIN_DEPLOYMENT} --config=${PLUGIN_CONFIG}
	else
	  gcloud deployment-manager deployments create ${PLUGIN_DEPLOYMENT} --config=${PLUGIN_CONFIG}
	fi
fi

if [ "$PLUGIN_STATE" == "absent" ]; then
	if gcloud deployment-manager deployments list | grep -q "${PLUGIN_DEPLOYMENT} "; then
	  gcloud deployment-manager deployments delete ${PLUGIN_DEPLOYMENT}
	fi
fi

exit