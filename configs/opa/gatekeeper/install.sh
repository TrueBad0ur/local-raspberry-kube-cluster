#helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
#helm install gatekeeper gatekeeper/gatekeeper --version 3.1.1 -n gatekeeper -f values.yml

kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/v3.18.2/deploy/gatekeeper.yaml
