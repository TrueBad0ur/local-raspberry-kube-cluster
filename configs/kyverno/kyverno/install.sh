helm repo add kyverno https://kyverno.github.io/kyverno/
kubectl create namespace kyverno
helm install kyverno --namespace kyverno kyverno/kyverno -f values.yml
