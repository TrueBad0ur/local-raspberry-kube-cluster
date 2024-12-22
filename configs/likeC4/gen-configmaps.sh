#!/bin/zsh

kubectl -n likec4 create configmap likec4-config-root --from-file=./src/ --dry-run=client -o yaml | kubectl apply -f -
kubectl -n likec4 create configmap likec4-config-root-cloud --from-file=./src/cloud --dry-run=client -o yaml | kubectl apply -f -


### Add annotations
#
# kind: Deployment
# metadata:
#   annotations:
#     reloader.stakater.com/search: "true"
# spec:
#   template:

# kind: ConfigMap
# metadata:
#   annotations:
#     reloader.stakater.com/match: "true"
# data:
#   key: value
