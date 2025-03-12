helm repo add gpm https://sighupio.github.io/gatekeeper-policy-manager

helm upgrade --install --namespace gatekeeper-system --set image.tag=v1.0.13 --values values.yml gatekeeper-policy-manager gpm/gatekeeper-policy-manager

