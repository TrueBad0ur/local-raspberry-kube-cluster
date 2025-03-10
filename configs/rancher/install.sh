helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

helm install rancher rancher-stable/rancher --version 2.10.3 --namespace cattle-system --create-namespace -f values.yml

k get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'
