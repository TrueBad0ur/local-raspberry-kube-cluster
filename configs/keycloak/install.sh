helm repo add bitnami https://charts.bitnami.com/bitnami
helm install keycloak -n keycloak bitnami/keycloak --version 24.4.13 -f values.yml

intergrate with rancher:

https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/authentication-permissions-and-global-configuration/authentication-config/configure-keycloak-oidc

https://github.com/dsohk/rancher-keycloak-efk-integration-workshop/blob/main/docs/Exercise-1-Accessing-Rancher-and-Keycloak.md
