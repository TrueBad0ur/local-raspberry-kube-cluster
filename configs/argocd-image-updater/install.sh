helm repo add argo https://argoproj.github.io/argo-helm
helm repo update argo

helm upgrade -i --create-namespace --namespace argo-cd --version 0.14.0 argocd-image-updater argo/argocd-image-updater -f values.yml
