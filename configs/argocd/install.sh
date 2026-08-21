helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

kubectl create namespace argo-cd --dry-run=client -o yaml | kubectl apply -f -

# OIDC (Keycloak) client secret, kept out of git - get the value from the
# "argocd" client in the "homelab" realm in Keycloak. Must be labeled so
# Argo CD's $secretName:key resolver can find it.
kubectl create secret generic argocd-oidc-secret -n argo-cd \
  --from-literal=oidc.keycloak.clientSecret="<argocd client secret from Keycloak>" \
  --dry-run=client -o yaml | kubectl apply -f -
kubectl label secret argocd-oidc-secret -n argo-cd app.kubernetes.io/part-of=argocd --overwrite

helm upgrade -i --namespace argo-cd --version 10.4.0 argocd argo/argo-cd -f values.yml

kubectl apply -f argocd-httproute.yml

# initial local admin login (fallback, in addition to "Log in via Keycloak"):
# admin / $(kubectl -n argo-cd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
