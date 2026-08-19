kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.6.1/standard-install.yaml

helm upgrade -i --create-namespace --namespace kgateway-system --version v2.4.2 kgateway-crds oci://cr.kgateway.dev/kgateway-dev/charts/kgateway-crds
helm upgrade -i --namespace kgateway-system --version v2.4.2 kgateway oci://cr.kgateway.dev/kgateway-dev/charts/kgateway -f values-kgateway.yml

kubectl apply -f gateway.yml
