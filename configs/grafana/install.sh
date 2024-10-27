helm repo add grafana https://grafana.github.io/helm-charts
kubectl apply -f ./grafana/certificate.yml
helm install -f ./grafana/values.yml grafana grafana/grafana -n monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
kubectl apply -f ./prometheus/certificate.yml
helm install -f ./prometheus/values.yml prometheus prometheus-community/prometheus -n monitoring

prometheus server url - http://prometheus-server.monitoring.svc.cluster.local
grafana dashboard - 12132
cool k8s dashboard - 15759

cool k8s dashboards:
k8s-system-api-server.json 	15761
k8s-system-coredns.json 	15762
k8s-views-global.json 		15757
k8s-views-nodes.json 		15759
k8s-views-pods.json 		15760
