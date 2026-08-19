helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade -i --create-namespace --namespace monitoring --version 88.5.0 monitoring prometheus-community/kube-prometheus-stack -f kube-prometheus-stack/values.yml

kubectl apply -f kube-prometheus-stack/grafana-httproute.yml

# grafana admin login: admin / prom-operator (see grafana.adminPassword in values.yml)
