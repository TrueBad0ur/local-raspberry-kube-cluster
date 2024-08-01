helm repo add grafana https://grafana.github.io/helm-charts
helm install -f ./grafana/values.yml grafana grafana/grafana

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install -f ./prometheus/values.yml prometheus prometheus-community/prometheus

prometheus server url - http://prometheus-server.default.svc
