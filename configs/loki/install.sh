helm repo add grafana https://grafana.github.io/helm-charts
helm repo update grafana

helm upgrade --install loki grafana/loki --version 7.3.0 -n loki --create-namespace -f values.yml
