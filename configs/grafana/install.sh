helm repo add grafana https://grafana.github.io/helm-charts
kubectl apply -f ./grafana/certificate.yml
helm install -f ./grafana/values.yml grafana grafana/grafana -n monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
kubectl apply -f ./prometheus/certificate.yml
helm install -f ./prometheus/values.yml prometheus prometheus-community/prometheus -n monitoring

prometheus server url - http://prometheus-server.monitoring.svc
grafana dashboard - 12132
