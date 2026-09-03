helm repo add grafana https://grafana.github.io/helm-charts
helm repo update grafana

helm upgrade --install promtail grafana/promtail --version 6.17.1 -n promtail --create-namespace -f values.yml
