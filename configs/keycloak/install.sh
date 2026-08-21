helm repo add codecentric https://codecentric.github.io/helm-charts
helm repo update

kubectl create namespace keycloak --dry-run=client -o yaml | kubectl apply -f -

# admin bootstrap creds, generated once, kept out of git:
kubectl create secret generic keycloak-admin-credentials -n keycloak \
  --from-literal=KC_BOOTSTRAP_ADMIN_USERNAME=admin \
  --from-literal=KC_BOOTSTRAP_ADMIN_PASSWORD="$(openssl rand -base64 18 | tr -d '=+/' | cut -c1-20)" \
  --dry-run=client -o yaml | kubectl apply -f -

helm upgrade -i --namespace keycloak --version 7.2.3 keycloak codecentric/keycloakx -f values.yml

# these creds only work on first boot (fresh/empty DB) - once the master realm exists,
# Keycloak ignores them; reset the "data" PVC to re-bootstrap.
