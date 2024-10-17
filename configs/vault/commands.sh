helm repo add hashicorp https://helm.releases.hashicorp.com
helml install vault hashicorp/vault --namespace vault -f values.yml

k -n vault exec -it pods/vault-0 -- vault operator init
k -n vault exec -it pods/vault-0 -- vault operator unseal
