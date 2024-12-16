helm repo add aqua https://aquasecurity.github.io/helm-charts/

helm show values aqua/trivy-operator > values.yml

helm upgrade --install --namespace trivy-system --values ./values.yml trivy-operator aqua/trivy-operator
