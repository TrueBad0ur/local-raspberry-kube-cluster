helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

kubectl create namespace cattle-system

helml install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=rancher.kubehomelab.space \
  --set ingress.tls.source=letsEncrypt \
  --set letsEncrypt.email=myemail@gmail.com

k get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'
