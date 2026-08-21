helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

# Grafana OIDC (Keycloak) client secret, kept out of git - get the value from the
# "grafana" client in the "homelab" realm in Keycloak.
kubectl create secret generic grafana-oidc-secret -n monitoring \
  --from-literal=GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET="<grafana client secret from Keycloak>" \
  --dry-run=client -o yaml | kubectl apply -f -

helm upgrade -i --namespace monitoring --version 88.5.0 monitoring prometheus-community/kube-prometheus-stack -f kube-prometheus-stack/values.yml

kubectl apply -f kube-prometheus-stack/grafana-httproute.yml

# local Grafana admin (fallback, still enabled): admin / prom-operator - use "Sign in with Keycloak" for SSO
