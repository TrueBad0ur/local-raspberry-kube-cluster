helm repo add argo https://argoproj.github.io/argo-helm
helm repo update argo

helm upgrade -i --create-namespace --namespace argo-cd --version 1.2.4 argocd-image-updater argo/argocd-image-updater -f values.yml
