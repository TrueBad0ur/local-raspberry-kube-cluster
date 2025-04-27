helm repo add joxit https://helm.joxit.dev

helm upgrade --install docker-registry-ui joxit/docker-registry-ui -f values.yml
