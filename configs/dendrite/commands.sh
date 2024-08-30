#!/bin/bash

helm repo add dendrite https://matrix-org.github.io/dendrite/

helm install dendrite dendrite/dendrite --values values.yml -n dendrite

k -n dendrite exec -it pods/POD -- sh
create-account -config ./dendrite.yaml -username test
