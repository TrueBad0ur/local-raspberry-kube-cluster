#!/bin/bash

#helm repo add loft https://charts.loft.sh/
#helm upgrade --install my-vcluster vcluster --repo https://charts.loft.sh --namespace team-x --repository-config='' --create-namespace

#RELEASE_NAME=vcluster-platform
#RELEASE_NAMESPACE=vcluster-platform
#PLATFORM_VERSION='' # Set this to a specific version or leave empty to deploy the latest version

#helm upgrade $RELEASE_NAME vcluster-platform --install --repo https://charts.loft.sh/ --namespace $RELEASE_NAMESPACE --create-namespace --values ./vcluster-platform/values.yml

helm upgrade vcluster-platform loft/vcluster-platform --install --namespace vcluster-platform --create-namespace --values ./values.yml