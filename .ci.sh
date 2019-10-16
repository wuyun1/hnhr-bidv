#!/usr/bin/env bash

# yarn

export CICD_EXECUTION_SEQUENCE=${BUILD_NUMBER:-1}

docker build . -t  harbor.hft.jajabjbj.top:30088/hft/hnhr:${CICD_EXECUTION_SEQUENCE}
docker push harbor.hft.jajabjbj.top:30088/hft/hnhr:${CICD_EXECUTION_SEQUENCE}

envsubst '${CICD_EXECUTION_SEQUENCE}' < deployment.yaml > _deployment.yaml

kubectl apply -f _deployment.yaml
